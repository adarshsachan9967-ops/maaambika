'use client';
import React, { useState, useEffect } from 'react';
import { orders, deliveryAgents, getOrderStatusLabel, getOrderStatusColor } from '@/lib/casmikData';
import type { Order } from '@/lib/casmikData';
import { 
  MapPin, 
  Package, 
  CheckCircle, 
  Clock, 
  Star, 
  Truck, 
  Phone, 
  Navigation, 
  ArrowRight, 
  TrendingUp, 
  Calendar, 
  ShieldCheck, 
  AlertCircle,
  ExternalLink,
  ChevronRight,
  Flame,
  Zap,
  CheckCircle2,
  X,
  Gift,
  Award
} from 'lucide-react';

interface DeliveryDashboardProps {
  onNavigateToTasks?: () => void;
  onNavigateToEarnings?: () => void;
}

export default function DeliveryDashboard({ onNavigateToTasks, onNavigateToEarnings }: DeliveryDashboardProps) {
  const [taskList, setTaskList] = useState<Order[]>([]);
  const [agent, setAgent] = useState(deliveryAgents[0]);
  const [showBonusModal, setShowBonusModal] = useState(false);
  const [bonusClaimed, setBonusClaimed] = useState(false);

  const loadTasks = () => {
    try {
      const savedSession = localStorage.getItem('casmik_delivery_session');
      if (savedSession) {
        setAgent(JSON.parse(savedSession));
      }
    } catch {}

    try {
      const savedOrders = localStorage.getItem('casmik_orders_v1');
      if (savedOrders) {
        const parsed = JSON.parse(savedOrders);
        if (Array.isArray(parsed) && parsed.length > 0) {
          setTaskList(parsed);
          return;
        }
      }
    } catch {}
    setTaskList(orders);
  };

  useEffect(() => {
    loadTasks();
    const handleSync = () => loadTasks();
    window.addEventListener('casmik_orders_updated', handleSync);
    window.addEventListener('storage', handleSync);
    return () => {
      window.removeEventListener('casmik_orders_updated', handleSync);
      window.removeEventListener('storage', handleSync);
    };
  }, []);

  const pendingPickups = taskList.filter(o => ['assigned', 'accepted', 'pickup_scheduled'].includes(o.status));
  const inTransit = taskList.filter(o => ['picked_up', 'in_transit', 'inspection'].includes(o.status));
  const completedToday = taskList.filter(o => o.status === 'completed' || o.paymentStatus === 'paid');

  const dailyTarget = 6;
  const completedCount = completedToday.length;
  const pickupsRemaining = Math.max(0, dailyTarget - completedCount);
  const targetPercent = Math.min(100, Math.round((completedCount / dailyTarget) * 100));
  const dailyEarnings = 1800 + completedCount * 450 + (bonusClaimed ? 300 : 0);

  const nextTask = pendingPickups[0] || inTransit[0] || taskList[0];

  return (
    <div className="space-y-6 w-full">
      {/* ─── HERO EXECUTIVE OPERATIONS CARD ─────────────────────────────────── */}
      <div className="relative overflow-hidden rounded-3xl bg-gradient-to-r from-emerald-600 via-primary to-teal-700 text-white shadow-xl p-6 sm:p-8">
        <div className="absolute top-0 right-0 -mt-10 -mr-10 w-64 h-64 bg-white/10 rounded-full blur-2xl pointer-events-none" />
        <div className="absolute bottom-0 left-1/3 -mb-10 w-48 h-48 bg-emerald-400/20 rounded-full blur-xl pointer-events-none" />

        <div className="relative z-10 flex flex-col lg:flex-row lg:items-center justify-between gap-6">
          {/* Agent info */}
          <div className="flex items-center gap-4 sm:gap-5">
            <div className="relative flex-shrink-0">
              {agent?.avatar ? (
                <img 
                  src={agent.avatar} 
                  alt={agent.name} 
                  className="w-18 h-18 sm:w-20 sm:h-20 rounded-3xl object-cover border-4 border-white/20 shadow-lg" 
                />
              ) : (
                <div className="w-18 h-18 sm:w-20 sm:h-20 rounded-3xl bg-white text-emerald-700 font-black text-2xl flex items-center justify-center shadow-lg">
                  {agent?.name?.[0] || 'D'}
                </div>
              )}
              <div className="absolute -bottom-1 -right-1 w-6 h-6 rounded-full bg-emerald-400 border-3 border-white flex items-center justify-center">
                <CheckCircle2 size={13} className="text-white" />
              </div>
            </div>

            <div>
              <div className="flex items-center gap-2 flex-wrap">
                <h2 className="text-xl sm:text-2xl font-black tracking-tight">{agent?.name}</h2>
                <span className="px-2.5 py-0.5 rounded-full text-xs font-black uppercase tracking-wider bg-white/20 text-white backdrop-blur-xs">
                  {agent?.vehicle || 'Two-Wheeler'} · {agent?.vehicleNumber || 'KA-01-AB-5566'}
                </span>
              </div>
              <p className="text-emerald-100 text-xs sm:text-sm mt-0.5">
                Assigned Zone: <strong>Delhi NCR & Gurgaon South</strong> · Active Fleet Executive
              </p>

              <div className="flex items-center gap-3 mt-2 flex-wrap text-xs">
                <div className="flex items-center gap-1 bg-black/20 backdrop-blur-xs px-2.5 py-1 rounded-xl">
                  <Star size={13} className="fill-amber-300 text-amber-300" />
                  <span className="font-bold text-amber-200">{agent?.rating || '4.9'}</span>
                  <span className="text-white/60">({agent?.totalDeliveries || 840} completed)</span>
                </div>
                <div className="flex items-center gap-1 bg-black/20 backdrop-blur-xs px-2.5 py-1 rounded-xl text-emerald-200 font-bold">
                  <ShieldCheck size={13} className="text-emerald-300" />
                  <span>KYC Verified & Insured</span>
                </div>
              </div>
            </div>
          </div>

          {/* Quick Stats in Hero */}
          <div className="grid grid-cols-3 gap-2 sm:gap-3 bg-black/20 backdrop-blur-md rounded-2xl p-3 sm:p-4 border border-white/10 flex-shrink-0">
            <div className="text-center px-2 sm:px-4">
              <p className="text-xs text-emerald-200 font-bold uppercase tracking-wider">Pending</p>
              <p className="text-xl sm:text-2xl font-black mt-0.5">{pendingPickups.length}</p>
              <span className="text-[10px] text-white/70">Pickups</span>
            </div>
            <div className="text-center px-2 sm:px-4 border-x border-white/15">
              <p className="text-xs text-emerald-200 font-bold uppercase tracking-wider">In Transit</p>
              <p className="text-xl sm:text-2xl font-black mt-0.5">{inTransit.length}</p>
              <span className="text-[10px] text-white/70">Active</span>
            </div>
            <div className="text-center px-2 sm:px-4">
              <p className="text-xs text-emerald-200 font-bold uppercase tracking-wider">Earned</p>
              <p className="text-xl sm:text-2xl font-black mt-0.5 text-amber-300">₹{dailyEarnings.toLocaleString('en-IN')}</p>
              <span className="text-[10px] text-white/70">Today</span>
            </div>
          </div>
        </div>
      </div>

      {/* ─── 4 COMPREHENSIVE OPERATIONAL STAT CARDS ────────────────────────── */}
      <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
        {/* Card 1: Pending Pickups */}
        <div className="bg-white rounded-3xl p-5 border border-slate-200/80 shadow-xs hover:shadow-md transition-shadow">
          <div className="flex items-center justify-between mb-3">
            <span className="text-xs font-bold text-slate-500 uppercase tracking-wider">Assigned Pickups</span>
            <div className="w-10 h-10 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center font-bold">
              <Package size={20} />
            </div>
          </div>
          <div className="flex items-baseline gap-2">
            <p className="text-3xl font-black text-slate-900">{pendingPickups.length}</p>
            <span className="text-xs text-blue-600 font-bold">Orders waiting for collection</span>
          </div>
          <div className="mt-3 pt-3 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500">
            <span>Next pickup slot:</span>
            <span className="font-bold text-slate-800">10:00 AM - 1:00 PM</span>
          </div>
        </div>

        {/* Card 2: In-Transit / Inspection */}
        <div className="bg-white rounded-3xl p-5 border border-slate-200/80 shadow-xs hover:shadow-md transition-shadow">
          <div className="flex items-center justify-between mb-3">
            <span className="text-xs font-bold text-slate-500 uppercase tracking-wider">Devices In Transit</span>
            <div className="w-10 h-10 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center font-bold">
              <Truck size={20} />
            </div>
          </div>
          <div className="flex items-baseline gap-2">
            <p className="text-3xl font-black text-slate-900">{inTransit.length}</p>
            <span className="text-xs text-amber-600 font-bold">En route to Hub</span>
          </div>
          <div className="mt-3 pt-3 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500">
            <span>Destination:</span>
            <span className="font-bold text-slate-800">Maa Ambika Certified Hub</span>
          </div>
        </div>

        {/* Card 3: Completed Today */}
        <div className="bg-white rounded-3xl p-5 border border-slate-200/80 shadow-xs hover:shadow-md transition-shadow">
          <div className="flex items-center justify-between mb-3">
            <span className="text-xs font-bold text-slate-500 uppercase tracking-wider">Completed Today</span>
            <div className="w-10 h-10 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold">
              <CheckCircle size={20} />
            </div>
          </div>
          <div className="flex items-baseline gap-2">
            <p className="text-3xl font-black text-slate-900">{completedToday.length}</p>
            <span className="text-xs text-emerald-600 font-bold">100% verified payouts</span>
          </div>
          <div className="mt-3 pt-3 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500">
            <span>Customer Satisfaction:</span>
            <span className="font-bold text-emerald-700">100% Positive</span>
          </div>
        </div>

        {/* Card 4: Daily Settlement Earnings */}
        <div className="bg-white rounded-3xl p-5 border border-slate-200/80 shadow-xs hover:shadow-md transition-shadow">
          <div className="flex items-center justify-between mb-3">
            <span className="text-xs font-bold text-slate-500 uppercase tracking-wider">Today&apos;s Earnings</span>
            <div className="w-10 h-10 rounded-2xl bg-purple-50 text-purple-600 flex items-center justify-center font-bold">
              <Zap size={20} />
            </div>
          </div>
          <div className="flex items-baseline gap-2">
            <p className="text-3xl font-black text-slate-900">₹{dailyEarnings.toLocaleString('en-IN')}</p>
            <span className="text-xs text-emerald-600 font-bold">Live settlement sync</span>
          </div>
          <div className="mt-3 pt-3 border-t border-slate-100 flex items-center justify-between text-xs text-slate-500">
            <span>Settlement mode:</span>
            <span className="font-bold text-slate-800">Direct Bank Deposit (12 AM)</span>
          </div>
        </div>
      </div>

      {/* ─── 2-COLUMN MAIN OPERATIONS WORKFLOW ─────────────────────────────── */}
      <div className="grid grid-cols-1 xl:grid-cols-12 gap-6">
        {/* LEFT COLUMN: ACTIVE & UPCOMING TASKS (8 Cols) */}
        <div className="xl:col-span-8 space-y-6">
          {/* Priority Next Pickup Alert Banner */}
          {nextTask && (
            <div className="bg-white rounded-3xl border-2 border-primary/30 p-5 sm:p-6 shadow-sm relative overflow-hidden">
              <div className="flex items-center justify-between gap-3 mb-4">
                <div className="flex items-center gap-2">
                  <span className="w-3 h-3 rounded-full bg-emerald-500 animate-ping" />
                  <span className="text-xs font-black uppercase tracking-wider text-emerald-700 bg-emerald-100 px-2.5 py-1 rounded-lg">
                    Recommended Next Stop
                  </span>
                </div>
                <span className="font-mono text-xs font-bold text-slate-500 bg-slate-100 px-2.5 py-1 rounded-lg">
                  #{nextTask.orderNumber}
                </span>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-12 gap-4 items-center">
                <div className="md:col-span-7">
                  <h3 className="text-lg font-black text-slate-900 leading-snug">{nextTask.deviceName}</h3>
                  <p className="text-xs text-slate-600 mt-1 flex items-center gap-1.5">
                    <MapPin size={13} className="text-primary flex-shrink-0" />
                    <span>{nextTask.customerAddress || 'Connaught Place, Central Delhi'}, {nextTask.pinCode || '110001'}</span>
                  </p>
                  <p className="text-xs text-slate-500 mt-1 flex items-center gap-1.5">
                    <Clock size={13} className="text-slate-400 flex-shrink-0" />
                    <span>Customer Slot: <strong>{nextTask.pickupDate || 'Today'} · {nextTask.pickupSlot || '10:00 AM - 1:00 PM'}</strong></span>
                  </p>
                </div>

                <div className="md:col-span-5 flex flex-col sm:flex-row md:flex-col gap-2">
                  <div className="p-3 bg-slate-50 rounded-2xl border border-slate-200/80 flex items-center justify-between">
                    <span className="text-xs text-slate-500 font-medium">Spot Value:</span>
                    <span className="text-base font-black text-emerald-600">₹{(nextTask.quotedPrice || 45000).toLocaleString('en-IN')}</span>
                  </div>
                  <div className="flex gap-2">
                    <a
                      href={`https://maps.google.com/?q=${encodeURIComponent(nextTask.customerAddress || nextTask.city || 'Delhi')}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex-1 py-2.5 px-3 bg-slate-900 hover:bg-slate-800 text-white rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 transition-colors shadow-xs"
                    >
                      <Navigation size={13} />
                      <span>GPS Maps</span>
                    </a>
                    {nextTask.customerPhone && (
                      <a
                        href={`tel:${nextTask.customerPhone}`}
                        className="py-2.5 px-3 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 rounded-xl text-xs font-bold flex items-center justify-center gap-1 border border-emerald-200 transition-colors"
                      >
                        <Phone size={13} />
                        <span>Call</span>
                      </a>
                    )}
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Today's Full Task Queue */}
          <div className="bg-white rounded-3xl border border-slate-200/80 shadow-xs overflow-hidden">
            <div className="p-5 border-b border-slate-100 flex items-center justify-between flex-wrap gap-2">
              <div>
                <h3 className="font-black text-base text-slate-900">Today&apos;s Task Pipeline</h3>
                <p className="text-xs text-slate-500 mt-0.5">Assigned pickups and device transit orders</p>
              </div>
              <button
                onClick={onNavigateToTasks}
                className="text-xs font-bold text-primary hover:text-primary/80 flex items-center gap-1 hover:underline cursor-pointer"
              >
                <span>View All Tasks Queue ({taskList.length})</span>
                <ArrowRight size={13} />
              </button>
            </div>

            <div className="divide-y divide-slate-100">
              {taskList.slice(0, 5).map((task) => (
                <div key={task.id} className="p-4 sm:p-5 hover:bg-slate-50/80 transition-colors flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                  <div className="flex items-start gap-3.5 min-w-0">
                    <div className={`w-11 h-11 rounded-2xl flex items-center justify-center flex-shrink-0 mt-0.5 font-bold ${
                      task.status === 'completed' ? 'bg-emerald-100 text-emerald-700' :
                      task.status === 'picked_up' ? 'bg-blue-100 text-blue-700' : 'bg-amber-100 text-amber-700'
                    }`}>
                      {task.status === 'completed' ? <CheckCircle size={20} /> :
                       task.status === 'picked_up' ? <Truck size={20} /> : <Clock size={20} />}
                    </div>

                    <div className="min-w-0">
                      <div className="flex items-center gap-2 flex-wrap mb-0.5">
                        <span className="font-mono text-xs font-bold text-slate-500">#{task.orderNumber}</span>
                        <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${getOrderStatusColor(task.status)}`}>
                          {getOrderStatusLabel(task.status)}
                        </span>
                      </div>
                      <h4 className="text-sm font-bold text-slate-900 truncate">{task.deviceName}</h4>
                      <p className="text-xs text-slate-500 mt-0.5">
                        Customer: <strong className="text-slate-700">{task.customerName}</strong> ({task.customerPhone})
                      </p>
                      <p className="text-xs text-slate-400 mt-0.5 truncate flex items-center gap-1">
                        <MapPin size={11} className="flex-shrink-0" />
                        <span>{task.customerAddress || 'Address on file'}, {task.city} ({task.pinCode})</span>
                      </p>
                    </div>
                  </div>

                  <div className="flex sm:flex-col items-center sm:items-end justify-between gap-2 flex-shrink-0 border-t sm:border-t-0 pt-2 sm:pt-0 border-slate-100">
                    <p className="text-base font-black text-emerald-600">₹{task.quotedPrice?.toLocaleString('en-IN')}</p>
                    <span className="text-xs text-slate-400 font-medium">{task.pickupSlot || '10:00 AM - 1:00 PM'}</span>
                    <a
                      href={`tel:${task.customerPhone}`}
                      className="px-3 py-1 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg text-xs font-bold flex items-center gap-1 transition-colors"
                    >
                      <Phone size={11} /> Call
                    </a>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* RIGHT COLUMN: PERFORMANCE, GOALS & LIVE HELPLINE (4 Cols) */}
        <div className="xl:col-span-4 space-y-6">
          {/* Daily Goal & Incentive Milestone (Interactive Clickable Card) */}
          <div 
            onClick={() => setShowBonusModal(true)}
            className="bg-gradient-to-br from-amber-500 via-orange-500 to-amber-600 rounded-3xl p-6 text-white shadow-md cursor-pointer hover:shadow-xl transition-all hover:scale-[1.01]"
            title="Click to view daily ₹300 bonus incentive milestone details"
          >
            <div className="flex items-center justify-between mb-3">
              <span className="px-2.5 py-0.5 rounded-full text-[10px] font-black uppercase tracking-wider bg-black/20 text-white flex items-center gap-1">
                <span>Daily Peak Incentive</span>
                {bonusClaimed && <span className="bg-emerald-400 text-slate-900 px-1 rounded font-bold">CLAIMED</span>}
              </span>
              <Flame size={20} className="text-amber-200 animate-pulse" />
            </div>

            <h3 className="text-xl font-black">₹300 Extra Bonus Target</h3>
            <p className="text-xs text-amber-100 mt-1 leading-relaxed">
              {pickupsRemaining === 0 
                ? 'Goal Achieved! You have hit today’s speed milestone target.'
                : `Complete ${pickupsRemaining} more pickup${pickupsRemaining > 1 ? 's' : ''} before 8:00 PM today to unlock the full daily speed milestone bonus.`}
            </p>

            <div className="mt-4 bg-black/20 rounded-2xl p-3">
              <div className="flex items-center justify-between text-xs font-bold mb-1">
                <span>Progress: {completedCount} of {dailyTarget} pickups</span>
                <span>{targetPercent}%</span>
              </div>
              <div className="h-2 bg-white/20 rounded-full overflow-hidden">
                <div className="h-full bg-white rounded-full transition-all duration-500" style={{ width: `${targetPercent}%` }} />
              </div>
            </div>

            <button
              type="button"
              onClick={(e) => {
                e.stopPropagation();
                setShowBonusModal(true);
              }}
              className="mt-4 w-full py-2.5 bg-white text-orange-600 rounded-xl text-xs font-black hover:bg-amber-50 transition-colors shadow-sm cursor-pointer flex items-center justify-center gap-1.5"
            >
              <span>{pickupsRemaining === 0 && !bonusClaimed ? 'Claim ₹300 Bonus Now →' : 'View Target Details →'}</span>
            </button>
          </div>

          {/* Performance & Quality Score */}
          <div className="bg-white rounded-3xl border border-slate-200/80 p-5 shadow-xs space-y-4">
            <h3 className="font-black text-sm text-slate-900 flex items-center justify-between">
              <span>Performance Ratings</span>
              <span className="text-xs font-bold text-emerald-600">Top 5% Executive</span>
            </h3>

            <div className="space-y-3">
              <div>
                <div className="flex justify-between text-xs mb-1 font-bold">
                  <span className="text-slate-600">On-Time Arrival Rate</span>
                  <span className="text-slate-900">98%</span>
                </div>
                <div className="h-1.5 bg-slate-100 rounded-full overflow-hidden">
                  <div className="h-full bg-emerald-500 rounded-full" style={{ width: '98%' }} />
                </div>
              </div>

              <div>
                <div className="flex justify-between text-xs mb-1 font-bold">
                  <span className="text-slate-600">Customer Rating</span>
                  <span className="text-amber-600 flex items-center gap-0.5">
                    <Star size={11} className="fill-amber-400 text-amber-400" /> 4.9 / 5.0
                  </span>
                </div>
                <div className="h-1.5 bg-slate-100 rounded-full overflow-hidden">
                  <div className="h-full bg-amber-400 rounded-full" style={{ width: '98%' }} />
                </div>
              </div>

              <div>
                <div className="flex justify-between text-xs mb-1 font-bold">
                  <span className="text-slate-600">Inspection Accuracy</span>
                  <span className="text-blue-600">99.2%</span>
                </div>
                <div className="h-1.5 bg-slate-100 rounded-full overflow-hidden">
                  <div className="h-full bg-blue-500 rounded-full" style={{ width: '99%' }} />
                </div>
              </div>
            </div>
          </div>

          {/* Camsik Hub Operations Contact */}
          <div className="bg-white rounded-3xl border border-slate-200/80 p-5 shadow-xs space-y-3">
            <h3 className="font-black text-sm text-slate-900">Assigned Processing Hub</h3>
            <div className="p-3.5 rounded-2xl bg-slate-50 border border-slate-200/60">
              <p className="text-xs font-bold text-slate-900">Maa Ambika Certified Central Hub</p>
              <p className="text-[11px] text-slate-500 mt-0.5">Main Road, Maa Ambika Mobile Shop, Odisha</p>
              <p className="text-[11px] text-slate-500 mt-1">Hub Manager: <strong>Maa Ambika Operations</strong></p>
            </div>
            <div className="flex gap-2">
              <a
                href="tel:+918260120467"
                className="flex-1 py-2.5 px-3 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 border border-emerald-200 transition-colors"
              >
                <Phone size={12} />
                <span>Call Hub Manager</span>
              </a>
              <a
                href="https://maps.google.com/?q=Connaught+Place+Delhi"
                target="_blank"
                rel="noopener noreferrer"
                className="py-2.5 px-3 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold flex items-center justify-center gap-1 transition-colors"
                title="Open Hub on Maps"
              >
                <Navigation size={12} />
              </a>
            </div>
          </div>
        </div>
      </div>
      {/* ─── ₹300 EXTRA BUDGET BONUS MODAL ─── */}
      {showBonusModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-xs animate-in fade-in">
          <div className="bg-white rounded-3xl max-w-md w-full p-6 shadow-2xl border border-slate-100 relative animate-in zoom-in-95">
            <button
              type="button"
              onClick={() => setShowBonusModal(false)}
              className="absolute top-4 right-4 text-slate-400 hover:text-slate-700 p-1.5 rounded-full hover:bg-slate-100 transition-colors cursor-pointer"
            >
              <X size={18} />
            </button>

            <div className="flex items-center gap-3 mb-4">
              <div className="w-12 h-12 rounded-2xl bg-gradient-to-br from-amber-400 to-orange-500 text-white flex items-center justify-center shadow-md shadow-orange-500/20 text-2xl font-black">
                🎯
              </div>
              <div>
                <h3 className="text-lg font-black text-slate-900">₹300 Daily Peak Bonus</h3>
                <p className="text-xs text-slate-500">Fleet Executive Speed &amp; Volume Target</p>
              </div>
            </div>

            {/* Target Progress Box */}
            <div className="bg-gradient-to-br from-slate-900 to-slate-800 text-white rounded-2xl p-4 mb-4">
              <div className="flex justify-between items-center text-xs text-slate-300 mb-1">
                <span>Daily Pickups Completed</span>
                <span className="font-bold text-amber-300">{completedCount} / {dailyTarget}</span>
              </div>
              <div className="h-2.5 bg-white/20 rounded-full overflow-hidden mb-2">
                <div className="h-full bg-amber-400 rounded-full transition-all duration-500" style={{ width: `${targetPercent}%` }} />
              </div>
              <p className="text-[11px] text-slate-400">
                {pickupsRemaining === 0
                  ? '🎉 Congratulations! You have achieved all 6 pickups for today.'
                  : `${pickupsRemaining} more pickup${pickupsRemaining > 1 ? 's' : ''} needed to unlock the ₹300 incentive.`}
              </p>
            </div>

            {/* Milestone Tiers */}
            <div className="space-y-2 mb-5">
              <p className="text-xs font-bold text-slate-700 uppercase tracking-wide">Incentive Tiers Today</p>
              
              <div className="p-3 bg-emerald-50 rounded-2xl border border-emerald-200 text-xs flex items-center justify-between">
                <div>
                  <p className="font-bold text-emerald-950">Tier 1: 3 Pickups</p>
                  <p className="text-[11px] text-emerald-700">Fuel &amp; Attendance Allowance</p>
                </div>
                <span className="font-black text-emerald-700 text-sm">✓ +₹100</span>
              </div>

              <div className={`p-3 rounded-2xl border text-xs flex items-center justify-between ${
                completedCount >= 5 ? 'bg-emerald-50 border-emerald-200 text-emerald-950' : 'bg-slate-50 border-slate-200 text-slate-700'
              }`}>
                <div>
                  <p className="font-bold">Tier 2: 5 Pickups</p>
                  <p className="text-[11px] text-slate-500">Peak Shift Bonus</p>
                </div>
                <span className={`font-black text-sm ${completedCount >= 5 ? 'text-emerald-700' : 'text-slate-500'}`}>
                  {completedCount >= 5 ? '✓ +₹150' : '+₹150'}
                </span>
              </div>

              <div className={`p-3 rounded-2xl border text-xs flex items-center justify-between ${
                completedCount >= 6 ? 'bg-amber-50 border-amber-300 text-amber-950' : 'bg-slate-50 border-slate-200 text-slate-700'
              }`}>
                <div>
                  <p className="font-bold">Tier 3: 6+ Pickups Target</p>
                  <p className="text-[11px] text-slate-500">Super Volume Speed Bonus</p>
                </div>
                <span className={`font-black text-sm ${completedCount >= 6 ? 'text-amber-700' : 'text-slate-500'}`}>
                  {bonusClaimed ? '✓ CLAIMED' : '+₹300'}
                </span>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="flex gap-2">
              {completedCount >= dailyTarget && !bonusClaimed ? (
                <button
                  type="button"
                  onClick={() => {
                    setBonusClaimed(true);
                    alert('🎉 ₹300 Daily Peak Bonus credited to your account settlement!');
                  }}
                  className="flex-1 py-3 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-black shadow-md cursor-pointer transition-all"
                >
                  Claim ₹300 Bonus Now 💰
                </button>
              ) : (
                <button
                  type="button"
                  onClick={() => {
                    setShowBonusModal(false);
                    onNavigateToTasks?.();
                  }}
                  className="flex-1 py-3 bg-slate-900 hover:bg-slate-800 text-white rounded-xl text-xs font-bold transition-all shadow-sm cursor-pointer"
                >
                  {bonusClaimed ? 'Bonus Credited · Return to Tasks' : 'Open Active Tasks Queue →'}
                </button>
              )}
              <button
                type="button"
                onClick={() => setShowBonusModal(false)}
                className="px-4 py-3 border border-slate-200 text-slate-700 hover:bg-slate-50 rounded-xl text-xs font-bold transition-colors cursor-pointer"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
