'use client';
import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import type { PartnerSection } from '../page';
import { LayoutDashboard, ShoppingBag, ClipboardCheck, DollarSign, Users, BarChart3, Settings, Bell, Menu, ChevronLeft, ChevronRight, Store, MessageSquare, UserCircle, LogOut, Copy, Check, Share2, Sparkles, X } from 'lucide-react';
import { Partner, partners, orders as defaultOrders } from '@/lib/casmikData';
import NotificationBell from '@/components/NotificationBell';

interface NavItem { id: PartnerSection; icon: React.ElementType; label: string; badge?: number; }

interface Props {
  activeSection: PartnerSection;
  onSectionChange: (s: PartnerSection) => void;
  children: React.ReactNode;
  currentPartner?: Partner | null;
}

export default function PartnerLayout({ activeSection, onSectionChange, children, currentPartner }: Props) {
  const [collapsed, setCollapsed] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [showReferModal, setShowReferModal] = useState(false);
  const [copiedCode, setCopiedCode] = useState(false);
  const [copiedLink, setCopiedLink] = useState(false);

  // Dynamic Live Counts
  const [ordersCount, setOrdersCount] = useState(0);
  const [inspectionCount, setInspectionCount] = useState(0);
  const [supportCount, setSupportCount] = useState(0);

  const getPartner = (): Partner => {
    if (currentPartner) return currentPartner;
    if (typeof window !== 'undefined') {
      try {
        const saved = localStorage.getItem('casmik_partner_session');
        if (saved) {
          const parsed = JSON.parse(saved);
          if (parsed && typeof parsed === 'object') return parsed;
        }
      } catch {}
    }
    return partners[0];
  };

  const partner: Partner = getPartner();
  const partnerId = partner?.id || 'partner-001';

  const updateRealCounts = () => {
    if (typeof window === 'undefined') return;
    try {
      const savedOrders = localStorage.getItem('casmik_partner_orders_v1') || localStorage.getItem('casmik_orders_v1');
      const list = savedOrders ? JSON.parse(savedOrders) : defaultOrders;
      if (Array.isArray(list)) {
        const partnerOrders = list.filter((o: any) => o.partnerId === partnerId);
        setOrdersCount(partnerOrders.filter((o: any) => o.status !== 'completed' && o.status !== 'cancelled').length);
        setInspectionCount(partnerOrders.filter((o: any) => ['inspection', 'accepted', 'picked_up'].includes(o.status)).length);
      }
    } catch {}

    try {
      const savedTickets = localStorage.getItem('casmik_support_tickets_v1');
      if (savedTickets) {
        const parsed = JSON.parse(savedTickets);
        if (Array.isArray(parsed)) {
          setSupportCount(parsed.filter((t: any) => t.status === 'open' || t.status === 'in_progress').length);
        }
      } else {
        setSupportCount(1);
      }
    } catch {}
  };

  useEffect(() => {
    updateRealCounts();
    const handleSync = () => updateRealCounts();
    window.addEventListener('casmik_orders_updated', handleSync);
    window.addEventListener('storage', handleSync);
    return () => {
      window.removeEventListener('casmik_orders_updated', handleSync);
      window.removeEventListener('storage', handleSync);
    };
  }, [partnerId]);

  const navItems: NavItem[] = [
    { id: 'dashboard', icon: LayoutDashboard, label: 'Dashboard' },
    { id: 'orders', icon: ShoppingBag, label: 'Orders', badge: ordersCount > 0 ? ordersCount : undefined },
    { id: 'inspection', icon: ClipboardCheck, label: 'Inspection', badge: inspectionCount > 0 ? inspectionCount : undefined },
    { id: 'payouts', icon: DollarSign, label: 'Payouts' },
    { id: 'customers', icon: Users, label: 'Customers' },
    { id: 'reports', icon: BarChart3, label: 'Reports' },
    { id: 'support', icon: MessageSquare, label: 'Support Tickets', badge: supportCount > 0 ? supportCount : undefined },
    { id: 'profile', icon: UserCircle, label: 'My Profile' },
    { id: 'settings', icon: Settings, label: 'Settings' },
  ];

  const handleLogout = () => {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('casmik_partner_session');
      window.location.href = '/partner/login';
    }
  };

  const initialLetter = partner?.storeName?.[0] || partner?.name?.[0] || 'P';
  const referralCode = `AMB-P${partnerId.replace(/\D/g, '') || '01'}`;
  const referralLink = `https://maaambikamobile.com/partner/signup?ref=${referralCode}`;

  const handleCopyCode = () => {
    navigator.clipboard?.writeText(referralCode);
    setCopiedCode(true);
    setTimeout(() => setCopiedCode(false), 2500);
  };

  const handleCopyLink = () => {
    navigator.clipboard?.writeText(referralLink);
    setCopiedLink(true);
    setTimeout(() => setCopiedLink(false), 2500);
  };

  const handleWhatsAppShare = () => {
    const text = encodeURIComponent(`Join Maa Ambika Mobile Partner Network and boost your store revenue with certified device trade-in, inspections & spot commissions! Use my referral code: ${referralCode}\n${referralLink}`);
    window.open(`https://wa.me/?text=${text}`, '_blank');
  };

  const SidebarContent = () => (
    <>
      <div className={`flex items-center h-16 border-b border-gray-100 flex-shrink-0 ${collapsed ? 'justify-center px-0' : 'px-4 gap-3'}`}>
        <div className="w-8 h-8 rounded-xl overflow-hidden bg-amber-500/20 border border-amber-500/30 flex items-center justify-center flex-shrink-0 p-0.5">
          <img src="/assets/images/app_logo.png" alt="Maa Ambika" className="w-full h-full object-contain" />
        </div>
        {!collapsed && (
          <div>
            <p className="font-black text-gray-900 text-sm leading-none">Maa Ambika</p>
            <p className="text-[10px] text-amber-600 font-semibold leading-none mt-1">Partner Portal</p>
          </div>
        )}
      </div>
      <nav className="flex-1 overflow-y-auto py-3 scrollbar-hide">
        {navItems.map((item) => {
          const active = activeSection === item.id;
          return (
            <button key={item.id} onClick={() => { onSectionChange(item.id); setMobileOpen(false); }}
              className={`w-full flex items-center mx-2 rounded-xl transition-all duration-150 mb-0.5 ${collapsed ? 'justify-center w-12 h-10 p-0' : 'gap-2.5 px-3 py-2.5'} ${active ? 'bg-primary text-white shadow-lg shadow-primary/20' : 'text-gray-500 hover:bg-gray-100 hover:text-gray-900'}`}
              style={{ width: collapsed ? '3rem' : 'calc(100% - 1rem)' }}
            >
              <item.icon size={17} className="flex-shrink-0" />
              {!collapsed && (
                <>
                  <span className="text-sm font-medium flex-1 text-left truncate">{item.label}</span>
                  {item.badge !== undefined && (
                    <span className="text-xs font-bold px-1.5 py-0.5 rounded-md bg-emerald-600 text-white animate-in zoom-in-50">{item.badge}</span>
                  )}
                </>
              )}
            </button>
          );
        })}
      </nav>
      {/* Refer & Earn Interactive */}
      {!collapsed && (
        <div className="mx-3 mb-3 bg-gradient-to-br from-primary/10 via-amber-50 to-green-100 rounded-2xl p-3 text-center border border-primary/20 shadow-xs">
          <p className="text-lg mb-1">🎁</p>
          <p className="text-xs font-black text-gray-900">Refer & Earn More</p>
          <p className="text-[11px] text-gray-500 mb-2 leading-tight">Refer peer stores &amp; earn ₹500 on their first completed trade-in!</p>
          <button 
            type="button"
            onClick={() => setShowReferModal(true)} 
            className="w-full py-1.5 bg-primary text-white rounded-xl text-xs font-bold hover:bg-primary/90 transition-all shadow-sm cursor-pointer"
          >
            Refer Now →
          </button>
        </div>
      )}
      <div className={`border-t border-gray-100 p-3 flex items-center flex-shrink-0 ${collapsed ? 'justify-center' : 'gap-3'}`}>
        <div className="w-8 h-8 rounded-full bg-primary flex items-center justify-center flex-shrink-0 text-white text-xs font-bold">
          {initialLetter}
        </div>
        {!collapsed && (
          <div className="flex-1 min-w-0">
            <p className="text-xs font-semibold text-gray-900 truncate">{partner?.storeName || partner?.name}</p>
            <p className="text-xs text-gray-400 truncate">ID: {partner?.id}</p>
          </div>
        )}
      </div>
    </>
  );

  return (
    <div className="flex h-screen bg-[#f8f9fb] overflow-hidden font-sans">
      {/* Desktop sidebar */}
      <aside className={`relative flex-shrink-0 bg-white border-r border-gray-100 flex flex-col transition-all duration-300 hidden md:flex ${collapsed ? 'w-16' : 'w-56'}`}>
        <SidebarContent />
        <button onClick={() => setCollapsed(c => !c)}
          className="absolute -right-3 top-20 w-6 h-6 rounded-full bg-white border border-gray-200 shadow-md flex items-center justify-center text-gray-500 hover:text-gray-800 z-10">
          {collapsed ? <ChevronRight size={12} /> : <ChevronLeft size={12} />}
        </button>
      </aside>

      {/* Mobile overlay */}
      {mobileOpen && (
        <div className="fixed inset-0 z-50 md:hidden">
          <div className="absolute inset-0 bg-black/50" onClick={() => setMobileOpen(false)} />
          <aside className="absolute left-0 top-0 bottom-0 w-56 bg-white flex flex-col">
            <SidebarContent />
          </aside>
        </div>
      )}

      <div className="flex-1 flex flex-col overflow-hidden">
        <header className="h-16 bg-white border-b border-gray-100 flex items-center px-4 lg:px-6 gap-4 flex-shrink-0">
          <button onClick={() => setMobileOpen(true)} className="md:hidden p-2 rounded-lg hover:bg-gray-100"><Menu size={20} /></button>
          <div className="flex-1">
            <h2 className="text-base font-bold text-gray-900 capitalize">
              {activeSection === 'profile' ? 'My Store Profile' :
               activeSection === 'dashboard' ? 'Store Dashboard' :
               activeSection === 'orders' ? 'Orders Management' :
               activeSection === 'inspection' ? 'Device Inspection Hub' :
               activeSection === 'payouts' ? 'Wallet & Payouts' :
               activeSection === 'customers' ? 'Store Customers' :
               activeSection === 'reports' ? 'Performance Reports' :
               activeSection === 'support' ? 'Support Tickets' :
               activeSection === 'settings' ? 'Store Settings' : activeSection}
            </h2>
          </div>
          <div className="flex items-center gap-3">
            <NotificationBell
              role="partner"
              onNavigateSection={(section) => onSectionChange(section as PartnerSection)}
              onNavigateToOrder={() => onSectionChange('orders')}
            />
            
            <div className="flex items-center gap-2 bg-gray-50 rounded-xl px-3 py-1.5 border border-gray-100">
              <div className="w-6 h-6 rounded-full bg-primary flex items-center justify-center text-white text-xs font-bold">
                {initialLetter}
              </div>
              <div className="hidden sm:block">
                <p className="text-xs font-bold text-gray-900 leading-none">{partner?.storeName || partner?.name}</p>
                <p className="text-xs text-gray-400 leading-none">ID: {partner?.id}</p>
              </div>
            </div>

            <button
              onClick={handleLogout}
              className="text-xs font-semibold text-red-600 hover:bg-red-50 rounded-lg px-2.5 py-1.5 transition-colors flex items-center gap-1 border border-red-200"
              title="Sign Out"
            >
              <LogOut size={13} />
              <span className="hidden sm:inline">Sign Out</span>
            </button>
          </div>
        </header>
        <main className="flex-1 overflow-y-auto p-4 lg:p-6">{children}</main>
      </div>

      {/* REFER & EARN MODAL */}
      {showReferModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-xs animate-in fade-in">
          <div className="bg-white rounded-3xl max-w-md w-full p-6 shadow-2xl border border-slate-100 relative animate-in zoom-in-95">
            <button
              type="button"
              onClick={() => setShowReferModal(false)}
              className="absolute top-4 right-4 text-slate-400 hover:text-slate-700 p-1.5 rounded-full hover:bg-slate-100 transition-colors"
            >
              <X size={18} />
            </button>

            <div className="flex items-center gap-3 mb-4">
              <div className="w-12 h-12 rounded-2xl bg-gradient-to-br from-amber-400 to-orange-500 text-white flex items-center justify-center shadow-md shadow-orange-500/20 text-xl font-bold">
                🎁
              </div>
              <div>
                <h3 className="text-lg font-black text-slate-900">Partner Referral Program</h3>
                <p className="text-xs text-slate-500">Invite local retail shops &amp; earn lifetime trade-in bonuses</p>
              </div>
            </div>

            {/* Perks breakdown */}
            <div className="space-y-2 mb-4">
              <div className="p-3 bg-amber-50 rounded-2xl border border-amber-200/80 text-xs text-amber-900 flex items-start gap-2">
                <Sparkles size={15} className="text-amber-600 mt-0.5 flex-shrink-0" />
                <span>
                  <strong>₹500 Instant Bonus:</strong> Credited to your wallet on the first completed customer trade-in by your referred partner.
                </span>
              </div>
              <div className="p-3 bg-emerald-50 rounded-2xl border border-emerald-200/80 text-xs text-emerald-900 flex items-start gap-2">
                <Check size={15} className="text-emerald-600 mt-0.5 flex-shrink-0" />
                <span>
                  <strong>2% Extra Margin:</strong> Earn on all secondary sales &amp; refurbishments sourced from your partner network.
                </span>
              </div>
            </div>

            {/* Referral Code Box */}
            <div className="mb-4">
              <label className="block text-xs font-bold text-slate-700 mb-1">Your Unique Partner Referral Code</label>
              <div className="flex items-center gap-2">
                <input
                  type="text"
                  readOnly
                  value={referralCode}
                  className="flex-1 px-3 py-2 bg-slate-100 border border-slate-200 rounded-xl font-mono text-sm font-black text-slate-800 text-center tracking-wider select-all"
                />
                <button
                  type="button"
                  onClick={handleCopyCode}
                  className="px-4 py-2 bg-slate-900 hover:bg-slate-800 text-white rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 cursor-pointer shadow-xs"
                >
                  {copiedCode ? <Check size={14} className="text-emerald-400" /> : <Copy size={14} />}
                  <span>{copiedCode ? 'Copied!' : 'Copy'}</span>
                </button>
              </div>
            </div>

            {/* Share buttons */}
            <div className="flex gap-2">
              <button
                type="button"
                onClick={handleWhatsAppShare}
                className="flex-1 py-3 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-black shadow-md shadow-emerald-600/20 transition-all flex items-center justify-center gap-1.5 cursor-pointer"
              >
                <Share2 size={14} />
                <span>Share via WhatsApp</span>
              </button>
              <button
                type="button"
                onClick={handleCopyLink}
                className="px-4 py-3 border border-slate-200 text-slate-700 hover:bg-slate-50 rounded-xl text-xs font-bold transition-colors cursor-pointer"
              >
                {copiedLink ? 'Link Copied!' : 'Copy Link'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
