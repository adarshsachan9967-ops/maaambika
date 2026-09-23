'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import { 
  MapPin, 
  Phone, 
  Mail, 
  Send, 
  CheckCircle2, 
  Clock, 
  MessageCircle, 
  ChevronRight,
  ShieldCheck,
  Building2,
  Sparkles,
  Navigation,
  Copy,
  Check,
  ExternalLink,
  Car,
  HelpCircle,
  ArrowRight,
  Headphones,
  Zap,
  Award,
  Smartphone,
  Wrench,
  RefreshCw,
  Coins
} from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';

const INQUIRY_TYPES = [
  { id: 'sales', label: '📱 Buy New 5G Smartphone', desc: 'Latest iPhones, Samsung, OnePlus & brand sealed phones' },
  { id: 'repair', label: '🔧 30-Min Mobile Screen & Repair', desc: 'Certified display, battery, port & board repair' },
  { id: 'accessories', label: '🎧 Original Accessories & Chargers', desc: 'AirPods, smartwatches, covers & fast chargers' },
  { id: 'recharge', label: '⚡ Recharge & 5G SIM Activation', desc: 'Instant prepaid/postpaid recharges (Jio, Airtel, Vi, BSNL)' },
  { id: 'sell', label: '💰 Sell Used Phone for Instant Cash', desc: 'Instant AI valuation & doorstep spot cash transfer' },
  { id: 'exchange', label: '🔄 1-Step Phone Exchange', desc: 'Trade old phone with up to ₹5,000 extra exchange bonus' },
];

const FAQS = [
  {
    q: 'Do I need an appointment before visiting Maa Ambika Mobile Shop?',
    a: 'Walk-ins are always warmly welcomed 7 days a week from 9:00 AM to 9:30 PM IST. If you want instant screen replacement or priority phone inspection, messaging us on WhatsApp (+91 8260120467) in advance ensures zero waiting time.'
  },
  {
    q: 'What mobile repair services do you offer in store?',
    a: 'We specialize in 30-to-45 minute certified repairs: Original OLED/LCD screen replacement, battery health restoration, charging jack fix, speaker/mic replacement, camera repair, and chip-level motherboard diagnostics with up to 6 months store warranty.'
  },
  {
    q: 'Can I sell my old phone or exchange it for a new smartphone?',
    a: 'Yes! We offer on-the-spot cash buyback for used smartphones, laptops, and tablets. We also provide 1-step device exchange where you trade in your old gadget, receive an extra exchange bonus (up to ₹5,000), and pay only the difference for a brand new phone.'
  },
  {
    q: 'What payment modes are accepted for sales, repairs, and buybacks?',
    a: 'We accept UPI (PhonePe, Google Pay, Paytm), IMPS/NEFT Bank Transfers, Credit/Debit Cards, Zero-Cost EMI, and Cash. When you sell an old device, funds are transferred instantly into your bank account before device handover.'
  }
];

export default function UserContactUsPage() {
  const [selectedInquiry, setSelectedInquiry] = useState('sales');
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    deviceModel: '',
    preferredContact: 'whatsapp',
    message: '',
  });
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [copiedAddress, setCopiedAddress] = useState(false);
  const [copiedGST, setCopiedGST] = useState(false);
  const [openFaq, setOpenFaq] = useState<number | null>(null);

  const addressText = "Main Road, Maa Ambika Mobile Shop, Odisha, India";
  const gstinText = "21ELDPS6270L1ZS";
  const mapDirectionsUrl = "https://www.google.com/maps/search/?api=1&query=Maa+Ambika+Mobile+Shop+Odisha+India";
  const googleMapEmbedSrc = "https://maps.google.com/maps?q=Odisha,%20India&t=&z=14&ie=UTF8&iwloc=&output=embed";

  const handleCopyAddress = () => {
    if (typeof window !== 'undefined' && navigator.clipboard) {
      navigator.clipboard.writeText(addressText);
      setCopiedAddress(true);
      setTimeout(() => setCopiedAddress(false), 2500);
    }
  };

  const handleCopyGST = () => {
    if (typeof window !== 'undefined' && navigator.clipboard) {
      navigator.clipboard.writeText(gstinText);
      setCopiedGST(true);
      setTimeout(() => setCopiedGST(false), 2500);
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setSubmitted(true);
    }, 800);
  };

  return (
    <main className="min-h-screen bg-[#F8FAFC] flex flex-col justify-between">
      <CustomerHeader />

      {/* Main Content Area */}
      <section className="flex-1 py-6 sm:py-8 lg:py-12">
        <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10 space-y-10 sm:space-y-12">
          
          {/* Breadcrumbs */}
          <nav className="flex items-center gap-2 text-xs font-semibold text-muted-foreground">
            <Link href="/user" className="hover:text-primary transition-colors">
              User Home
            </Link>
            <ChevronRight size={13} />
            <span className="text-foreground font-bold">Contact Us</span>
          </nav>

          {/* Hero Header Banner */}
          <div className="relative rounded-3xl bg-gradient-to-br from-slate-950 via-[#1a0f02] to-slate-950 text-white p-6 sm:p-10 lg:p-12 overflow-hidden shadow-2xl border border-amber-500/30">
            {/* Ambient golden glow */}
            <div className="absolute top-0 right-0 w-96 h-96 bg-amber-500/15 rounded-full blur-3xl pointer-events-none -mr-20 -mt-20" />
            <div className="absolute bottom-0 left-1/3 w-80 h-80 bg-yellow-500/10 rounded-full blur-3xl pointer-events-none -mb-20" />

            <div className="relative z-10 max-w-3xl">
              <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-amber-500/20 border border-amber-400/40 text-amber-300 text-xs font-black uppercase tracking-wider mb-4 backdrop-blur-md">
                <Sparkles size={14} className="text-amber-400" />
                OFFICIAL SHOWROOM • GSTIN: 21ELDPS6270L1ZS
              </div>
              <h1 className="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight leading-tight sm:leading-tight">
                Connect with <span className="bg-gradient-to-r from-amber-400 via-yellow-300 to-amber-500 bg-clip-text text-transparent">Maa Ambika Mobile Shop</span>
              </h1>
              <p className="mt-3 sm:mt-4 text-slate-300 text-sm sm:text-base lg:text-lg leading-relaxed max-w-2xl font-medium">
                Your Digital Life Partner — Best Products • Best Price • Best Service. Looking to buy the latest 5G smartphones, book a 30-minute certified screen repair, buy original accessories, or sell your old phone for instant spot cash? We are open 7 days a week.
              </p>
            </div>

            {/* Quick Value Metrics Bar */}
            <div className="relative z-10 grid grid-cols-2 sm:grid-cols-4 gap-3 sm:gap-4 mt-8 pt-6 border-t border-white/10 text-xs sm:text-sm">
              <div className="flex items-center gap-3 bg-white/5 backdrop-blur-md rounded-2xl p-3 border border-white/10">
                <div className="w-9 h-9 rounded-xl bg-amber-500/20 text-amber-300 flex items-center justify-center shrink-0">
                  <Zap size={18} />
                </div>
                <div>
                  <p className="font-bold text-white">&lt; 15 Min Response</p>
                  <p className="text-slate-400 text-xs">Direct call &amp; WhatsApp</p>
                </div>
              </div>

              <div className="flex items-center gap-3 bg-white/5 backdrop-blur-md rounded-2xl p-3 border border-white/10">
                <div className="w-9 h-9 rounded-xl bg-emerald-500/20 text-emerald-300 flex items-center justify-center shrink-0">
                  <ShieldCheck size={18} />
                </div>
                <div>
                  <p className="font-bold text-white">GST Registered</p>
                  <p className="text-slate-400 text-xs">21ELDPS6270L1ZS</p>
                </div>
              </div>

              <div className="flex items-center gap-3 bg-white/5 backdrop-blur-md rounded-2xl p-3 border border-white/10">
                <div className="w-9 h-9 rounded-xl bg-yellow-500/20 text-yellow-300 flex items-center justify-center shrink-0">
                  <Building2 size={18} />
                </div>
                <div>
                  <p className="font-bold text-white">Main Road Showroom</p>
                  <p className="text-slate-400 text-xs">Odisha, India</p>
                </div>
              </div>

              <div className="flex items-center gap-3 bg-white/5 backdrop-blur-md rounded-2xl p-3 border border-white/10">
                <div className="w-9 h-9 rounded-xl bg-purple-500/20 text-purple-300 flex items-center justify-center shrink-0">
                  <Navigation size={18} />
                </div>
                <div>
                  <p className="font-bold text-white">Doorstep Service</p>
                  <p className="text-slate-400 text-xs">Free pickup &amp; exchange</p>
                </div>
              </div>
            </div>
          </div>

          {/* Primary Two-Column Grid: Contact Info + Message Form */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-10 items-start">
            
            {/* Left Column: Official Contact Channels */}
            <div className="lg:col-span-5 bg-white rounded-3xl border border-slate-200/80 p-6 sm:p-8 lg:p-9 shadow-sm flex flex-col justify-between space-y-6">
              <div>
                <div className="flex items-center justify-between mb-4">
                  <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-50 text-amber-800 text-xs font-bold uppercase tracking-wider border border-amber-200">
                    <Sparkles size={13} className="text-amber-600" />
                    Official Showroom &amp; Service Desk
                  </div>
                  <span className="inline-flex items-center gap-1.5 text-xs font-bold text-emerald-600 bg-emerald-50 px-2.5 py-1 rounded-full border border-emerald-200/60">
                    <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
                    Open Today
                  </span>
                </div>

                <h2 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight mb-2">
                  Store Contact Details
                </h2>
                <p className="text-slate-500 text-xs sm:text-sm mb-6">
                  Direct channels for new phone stock inquiries, fast repairs, exchange quotes, and mobile recharges.
                </p>

                <div className="space-y-4">
                  {/* Address Card */}
                  <div className="p-4 sm:p-5 rounded-2xl bg-amber-50/40 border border-amber-200/70 hover:border-amber-400 transition-colors group">
                    <div className="flex items-start gap-3.5">
                      <div className="w-11 h-11 rounded-2xl bg-amber-500/15 text-amber-700 flex items-center justify-center shrink-0 shadow-xs group-hover:bg-amber-600 group-hover:text-white transition-all">
                        <MapPin size={22} />
                      </div>
                      <div className="flex-1">
                        <div className="flex items-center justify-between gap-2 mb-1">
                          <h3 className="text-xs font-extrabold uppercase tracking-wider text-slate-500">
                            Flagship Store Location
                          </h3>
                          <button
                            type="button"
                            onClick={handleCopyAddress}
                            className="text-xs font-semibold text-slate-600 hover:text-amber-700 flex items-center gap-1 bg-white px-2 py-0.5 rounded-md border border-slate-200 shadow-xs"
                            title="Copy full address"
                          >
                            {copiedAddress ? (
                              <>
                                <Check size={12} className="text-emerald-600" />
                                <span className="text-emerald-600 font-bold">Copied</span>
                              </>
                            ) : (
                              <>
                                <Copy size={12} />
                                <span>Copy</span>
                              </>
                            )}
                          </button>
                        </div>
                        <p className="text-sm sm:text-base font-black text-slate-900 leading-snug">
                          Main Road, Maa Ambika Mobile Shop
                        </p>
                        <p className="text-xs sm:text-sm font-semibold text-slate-600 mt-1">
                          Odisha, India
                        </p>
                        <div className="mt-3 flex flex-wrap items-center gap-2 text-xs">
                          <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg bg-amber-100/70 text-amber-900 font-bold border border-amber-300/60">
                            <Building2 size={12} /> Landmark: Main Road Showroom
                          </span>
                          <a
                            href={mapDirectionsUrl}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg bg-slate-200/80 text-slate-800 font-bold hover:bg-slate-300 transition-colors"
                          >
                            <ExternalLink size={12} /> Map Directions
                          </a>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Phone Hotline */}
                  <div className="p-4 sm:p-5 rounded-2xl bg-slate-50/80 border border-slate-200/70 hover:border-blue-300 transition-colors group">
                    <div className="flex items-start gap-3.5">
                      <div className="w-11 h-11 rounded-2xl bg-blue-500/10 text-blue-600 flex items-center justify-center shrink-0 shadow-xs group-hover:bg-blue-600 group-hover:text-white transition-all">
                        <Phone size={22} />
                      </div>
                      <div className="flex-1">
                        <div className="flex items-center justify-between gap-2 mb-1">
                          <h3 className="text-xs font-extrabold uppercase tracking-wider text-slate-500">
                            Store Helpline &amp; WhatsApp
                          </h3>
                        </div>
                        <a
                          href="tel:+918260120467"
                          className="text-lg sm:text-xl font-black text-slate-900 hover:text-blue-600 transition-colors block tracking-wide"
                        >
                          +91 8260120467
                        </a>
                        <p className="text-xs text-slate-500 mt-1 flex items-center gap-1.5">
                          <Clock size={12} className="text-slate-400" />
                          <span>Monday – Sunday: <strong>9:00 AM – 9:30 PM IST (Open 7 Days)</strong></span>
                        </p>
                      </div>
                    </div>
                  </div>

                  {/* GSTIN & Legal */}
                  <div className="p-4 sm:p-5 rounded-2xl bg-slate-50/80 border border-slate-200/70 hover:border-emerald-300 transition-colors group">
                    <div className="flex items-start gap-3.5">
                      <div className="w-11 h-11 rounded-2xl bg-emerald-500/10 text-emerald-600 flex items-center justify-center shrink-0 shadow-xs group-hover:bg-emerald-600 group-hover:text-white transition-all">
                        <ShieldCheck size={22} />
                      </div>
                      <div className="flex-1">
                        <div className="flex items-center justify-between gap-2 mb-1">
                          <h3 className="text-xs font-extrabold uppercase tracking-wider text-slate-500">
                            GST Registered Business
                          </h3>
                          <button
                            type="button"
                            onClick={handleCopyGST}
                            className="text-xs font-semibold text-slate-600 hover:text-emerald-600 flex items-center gap-1 bg-white px-2 py-0.5 rounded-md border border-slate-200 shadow-xs"
                          >
                            {copiedGST ? (
                              <>
                                <Check size={12} className="text-emerald-600" />
                                <span className="text-emerald-600 font-bold">Copied</span>
                              </>
                            ) : (
                              <>
                                <Copy size={12} />
                                <span>Copy</span>
                              </>
                            )}
                          </button>
                        </div>
                        <p className="text-base sm:text-lg font-mono font-black text-slate-900">
                          {gstinText}
                        </p>
                        <p className="text-xs text-slate-500 mt-0.5">
                          Official Store Invoicing with Valid Tax Deductions
                        </p>
                      </div>
                    </div>
                  </div>

                  {/* Email Support */}
                  <div className="p-4 sm:p-5 rounded-2xl bg-slate-50/80 border border-slate-200/70 hover:border-purple-300 transition-colors group">
                    <div className="flex items-start gap-3.5">
                      <div className="w-11 h-11 rounded-2xl bg-purple-500/10 text-purple-600 flex items-center justify-center shrink-0 shadow-xs group-hover:bg-purple-600 group-hover:text-white transition-all">
                        <Mail size={22} />
                      </div>
                      <div className="flex-1">
                        <div className="flex items-center justify-between gap-2 mb-1">
                          <h3 className="text-xs font-extrabold uppercase tracking-wider text-slate-500">
                            Digital Helpdesk Email
                          </h3>
                        </div>
                        <a
                          href="mailto:support@maaambikamobile.com"
                          className="text-sm sm:text-base font-black text-slate-900 hover:text-purple-600 transition-colors block break-all"
                        >
                          support@maaambikamobile.com
                        </a>
                        <p className="text-xs text-slate-500 mt-1 flex items-center gap-1">
                          <Zap size={12} className="text-amber-500" />
                          <span>Quick response within 15–30 minutes</span>
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              {/* Action Buttons: WhatsApp & Call */}
              <div className="pt-4 border-t border-slate-200/80 space-y-3">
                <a
                  href="https://wa.me/918260120467?text=Hi%20Maa%20Ambika%20Mobile%20Shop,%20I%20have%20an%20inquiry%20regarding%20phones/service"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-full py-3.5 px-5 rounded-2xl bg-emerald-600 hover:bg-emerald-500 text-white font-extrabold text-sm shadow-md hover:shadow-lg transition-all flex items-center justify-center gap-2.5 btn-press"
                >
                  <MessageCircle size={20} />
                  Chat on WhatsApp (+91 8260120467)
                </a>

                <div className="grid grid-cols-2 gap-3 text-xs">
                  <a
                    href="tel:+918260120467"
                    className="py-2.5 px-3 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-800 font-bold text-center flex items-center justify-center gap-1.5 transition-colors"
                  >
                    <Phone size={14} /> Call Showroom
                  </a>
                  <a
                    href={mapDirectionsUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="py-2.5 px-3 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-800 font-bold text-center flex items-center justify-center gap-1.5 transition-colors"
                  >
                    <Navigation size={14} /> View On Map
                  </a>
                </div>
              </div>
            </div>

            {/* Right Column: Send Message & Inquiry Form */}
            <div className="lg:col-span-7 bg-white rounded-3xl border border-slate-200/80 p-6 sm:p-8 lg:p-9 shadow-sm">
              <div className="mb-6">
                <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-50 text-amber-800 text-xs font-bold uppercase tracking-wider border border-amber-200 mb-3">
                  <Headphones size={13} className="text-amber-600" />
                  Fast Service &amp; Inquiry Form
                </div>
                <h2 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
                  Send Your Inquiry
                </h2>
                <p className="text-xs sm:text-sm text-slate-500 mt-1">
                  Fill in your details and device requirement. Our store executive will assist you immediately with pricing, quotes, or repair booking.
                </p>
              </div>

              {/* Inquiry Reason Pills */}
              <div className="mb-6">
                <label className="block text-xs font-extrabold text-slate-700 uppercase tracking-wider mb-2.5">
                  Select Service / Inquiry Type
                </label>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                  {INQUIRY_TYPES.map((type) => (
                    <button
                      key={type.id}
                      type="button"
                      onClick={() => setSelectedInquiry(type.id)}
                      className={`p-3 rounded-xl text-left transition-all border text-xs ${
                        selectedInquiry === type.id
                          ? 'bg-amber-500/10 border-amber-500 text-amber-950 font-bold shadow-xs'
                          : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'
                      }`}
                    >
                      <p className="font-extrabold">{type.label}</p>
                      <p className="text-[11px] text-slate-500 mt-0.5">{type.desc}</p>
                    </button>
                  ))}
                </div>
              </div>

              {submitted ? (
                <div className="p-8 rounded-3xl bg-amber-50/80 border border-amber-300 text-center animate-fade-in my-6">
                  <div className="w-16 h-16 rounded-full bg-amber-100 text-amber-700 flex items-center justify-center mx-auto mb-4 shadow-sm">
                    <CheckCircle2 size={36} />
                  </div>
                  <h3 className="text-xl sm:text-2xl font-black text-slate-950 mb-2">
                    Inquiry Submitted Successfully!
                  </h3>
                  <p className="text-sm text-slate-700 max-w-md mx-auto mb-6 leading-relaxed">
                    Thank you, <strong>{formData.name}</strong>. Your inquiry regarding <strong>{INQUIRY_TYPES.find(t => t.id === selectedInquiry)?.label}</strong> has been received by Maa Ambika Mobile Shop. Our specialist will contact you on <strong>{formData.phone}</strong> right away.
                  </p>
                  <div className="flex flex-wrap justify-center gap-3">
                    <button
                      onClick={() => {
                        setSubmitted(false);
                        setFormData({ name: '', email: '', phone: '', deviceModel: '', preferredContact: 'whatsapp', message: '' });
                      }}
                      className="px-6 py-2.5 rounded-xl bg-white text-slate-800 font-extrabold text-xs uppercase tracking-wider border border-slate-300 hover:bg-slate-100 transition-colors"
                    >
                      Send Another Inquiry
                    </button>
                    <a
                      href={`https://wa.me/918260120467?text=Hi%20Maa%20Ambika%20Mobile%20Shop,%20I%20just%20submitted%20an%20inquiry%20for%20${encodeURIComponent(formData.name)}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="px-6 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-extrabold text-xs uppercase tracking-wider shadow-sm flex items-center gap-1.5 transition-colors"
                    >
                      <MessageCircle size={14} /> Open in WhatsApp
                    </a>
                  </div>
                </div>
              ) : (
                <form onSubmit={handleSubmit} className="space-y-4 sm:space-y-5">
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    {/* Name */}
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1.5 uppercase tracking-wider">
                        Your Full Name <span className="text-rose-500">*</span>
                      </label>
                      <input
                        type="text"
                        required
                        placeholder="e.g. Rahul Sharma"
                        value={formData.name}
                        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                        className="w-full px-4 py-3 rounded-2xl bg-slate-50 border border-slate-200 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-amber-500/20 focus:border-amber-500 focus:bg-white transition-all"
                      />
                    </div>

                    {/* Phone */}
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1.5 uppercase tracking-wider">
                        Phone / WhatsApp <span className="text-rose-500">*</span>
                      </label>
                      <div className="relative">
                        <span className="absolute left-4 top-1/2 -translate-y-1/2 text-xs font-bold text-slate-500">
                          +91
                        </span>
                        <input
                          type="tel"
                          required
                          placeholder="8260120467"
                          value={formData.phone}
                          onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                          className="w-full pl-12 pr-4 py-3 rounded-2xl bg-slate-50 border border-slate-200 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-amber-500/20 focus:border-amber-500 focus:bg-white transition-all"
                        />
                      </div>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    {/* Email */}
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1.5 uppercase tracking-wider">
                        Email Address
                      </label>
                      <input
                        type="email"
                        placeholder="rahul@example.com"
                        value={formData.email}
                        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                        className="w-full px-4 py-3 rounded-2xl bg-slate-50 border border-slate-200 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-amber-500/20 focus:border-amber-500 focus:bg-white transition-all"
                      />
                    </div>

                    {/* Device Model */}
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1.5 uppercase tracking-wider">
                        Device Name / Model
                      </label>
                      <input
                        type="text"
                        placeholder="e.g. iPhone 15 Pro / Galaxy S24 / Screen Fix"
                        value={formData.deviceModel}
                        onChange={(e) => setFormData({ ...formData, deviceModel: e.target.value })}
                        className="w-full px-4 py-3 rounded-2xl bg-slate-50 border border-slate-200 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-amber-500/20 focus:border-amber-500 focus:bg-white transition-all"
                      />
                    </div>
                  </div>

                  {/* Message */}
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1.5 uppercase tracking-wider">
                      Message / Issue Description
                    </label>
                    <textarea
                      rows={3}
                      placeholder="Tell us what you need (e.g. want to buy new iPhone 16 Pro, need display repair for OnePlus, or want sell quote)..."
                      value={formData.message}
                      onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                      className="w-full px-4 py-3 rounded-2xl bg-slate-50 border border-slate-200 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-amber-500/20 focus:border-amber-500 focus:bg-white transition-all resize-none"
                    />
                  </div>

                  {/* Submit Button */}
                  <button
                    type="submit"
                    disabled={loading}
                    className="w-full py-4 rounded-2xl bg-gradient-to-r from-amber-500 via-amber-600 to-yellow-500 hover:from-amber-600 hover:to-yellow-600 text-slate-950 font-black text-sm uppercase tracking-wider shadow-lg shadow-amber-500/25 flex items-center justify-center gap-2 transition-all disabled:opacity-50"
                  >
                    {loading ? (
                      <span>Sending Inquiry...</span>
                    ) : (
                      <>
                        <Send size={16} />
                        <span>Send Message to Maa Ambika Team</span>
                      </>
                    )}
                  </button>
                </form>
              )}
            </div>
          </div>

          {/* Showroom Map & Walk-In Section */}
          <div className="bg-white rounded-3xl border border-slate-200/80 p-6 sm:p-8 lg:p-10 shadow-sm">
            <div className="flex flex-col sm:flex-row sm:items-end justify-between mb-6 gap-4">
              <div>
                <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-50 text-amber-800 text-xs font-bold uppercase tracking-wider border border-amber-200 mb-2">
                  <MapPin size={13} className="text-amber-600" />
                  Showroom Location &amp; Directions
                </div>
                <h2 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
                  Visit Maa Ambika Mobile Shop Showroom
                </h2>
                <p className="text-xs sm:text-sm text-slate-500 mt-1 max-w-2xl">
                  Drop by our store on Main Road, Odisha for instant sales, hands-on device testing, 30-minute certified repairs, and spot cash buybacks.
                </p>
              </div>

              <div className="flex items-center gap-3">
                <a
                  href={mapDirectionsUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-slate-950 hover:bg-slate-800 text-amber-400 text-xs font-bold transition-all shadow-sm"
                >
                  <Navigation size={14} className="text-amber-400" />
                  Open in Google Maps
                </a>
              </div>
            </div>

            {/* Map Canvas with Floating Info Overlay */}
            <div className="relative rounded-2xl sm:rounded-3xl overflow-hidden border border-slate-200 bg-slate-100 shadow-inner">
              <div className="w-full h-[360px] sm:h-[440px] lg:h-[480px]">
                <iframe
                  title="Maa Ambika Mobile Shop Location"
                  src={googleMapEmbedSrc}
                  width="100%"
                  height="100%"
                  style={{ border: 0 }}
                  allowFullScreen
                  loading="lazy"
                  referrerPolicy="no-referrer-when-downgrade"
                  className="w-full h-full grayscale-[15%] contrast-[105%]"
                />
              </div>

              {/* Floating Overlay Badge on Map */}
              <div className="hidden sm:block absolute top-4 left-4 max-w-sm bg-slate-950/95 backdrop-blur-md rounded-2xl p-4 shadow-xl border border-amber-500/40 z-10 text-xs text-white">
                <div className="flex items-center gap-2 mb-2">
                  <span className="w-2.5 h-2.5 rounded-full bg-amber-400 animate-pulse" />
                  <span className="font-extrabold text-amber-300 uppercase tracking-wider text-[11px]">
                    MAA AMBIKA MOBILE SHOP
                  </span>
                </div>
                <p className="font-bold text-white leading-snug">
                  Main Road, Maa Ambika Mobile Shop
                </p>
                <p className="text-slate-400 text-[11px] mt-0.5">
                  Odisha, India &bull; GSTIN: 21ELDPS6270L1ZS
                </p>
                <div className="mt-3 pt-2.5 border-t border-slate-800 flex items-center justify-between text-slate-300 font-semibold">
                  <span className="flex items-center gap-1">
                    <Clock size={12} className="text-amber-400" /> 9:00 AM – 9:30 PM (7 Days)
                  </span>
                  <a
                    href={mapDirectionsUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-amber-400 hover:text-amber-300 font-bold flex items-center gap-1"
                  >
                    Directions <ChevronRight size={12} />
                  </a>
                </div>
              </div>
            </div>

            {/* Travel Highlights */}
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mt-6">
              <div className="p-4 rounded-2xl bg-amber-50/50 border border-amber-200/80 flex items-start gap-3">
                <div className="w-9 h-9 rounded-xl bg-amber-500/20 text-amber-800 flex items-center justify-center shrink-0">
                  <Building2 size={18} />
                </div>
                <div>
                  <h4 className="text-xs font-black uppercase tracking-wider text-slate-900">
                    Prime Main Road Location
                  </h4>
                  <p className="text-xs text-slate-600 mt-1 leading-relaxed">
                    Easy accessibility right on the main commercial strip with clear signage and prominent storefront.
                  </p>
                </div>
              </div>

              <div className="p-4 rounded-2xl bg-emerald-50/50 border border-emerald-200/80 flex items-start gap-3">
                <div className="w-9 h-9 rounded-xl bg-emerald-500/20 text-emerald-800 flex items-center justify-center shrink-0">
                  <Car size={18} />
                </div>
                <div>
                  <h4 className="text-xs font-black uppercase tracking-wider text-slate-900">
                    Dedicated Parking Space
                  </h4>
                  <p className="text-xs text-slate-600 mt-1 leading-relaxed">
                    Hassle-free 2-wheeler and 4-wheeler customer parking right in front of the showroom.
                  </p>
                </div>
              </div>

              <div className="p-4 rounded-2xl bg-blue-50/50 border border-blue-200/80 flex items-start gap-3">
                <div className="w-9 h-9 rounded-xl bg-blue-500/20 text-blue-800 flex items-center justify-center shrink-0">
                  <Wrench size={18} />
                </div>
                <div>
                  <h4 className="text-xs font-black uppercase tracking-wider text-slate-900">
                    Live Diagnostics Lab
                  </h4>
                  <p className="text-xs text-slate-600 mt-1 leading-relaxed">
                    Watch our certified technicians repair your phone live behind transparent diagnostic stations.
                  </p>
                </div>
              </div>
            </div>
          </div>

          {/* 3-Step Store Experience */}
          <div className="bg-gradient-to-br from-slate-950 via-[#1a0f02] to-slate-900 rounded-3xl p-6 sm:p-8 lg:p-10 text-white shadow-xl border border-amber-500/30">
            <div className="max-w-2xl mb-8">
              <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-500/20 text-amber-300 text-xs font-bold uppercase tracking-wider mb-2 border border-amber-500/40">
                <Award size={13} />
                Store Experience
              </div>
              <h2 className="text-2xl sm:text-3xl font-black tracking-tight">
                How Maa Ambika Store Service Works
              </h2>
              <p className="text-slate-300 text-xs sm:text-sm mt-1">
                Fast, honest, and transparent experience from inquiry to delivery.
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="p-6 rounded-2xl bg-white/5 border border-white/10 relative">
                <div className="w-10 h-10 rounded-xl bg-amber-500/20 text-amber-400 font-black text-lg flex items-center justify-center mb-4">
                  1
                </div>
                <h3 className="text-base font-black text-white mb-2">
                  Choose Phone or Bring Device
                </h3>
                <p className="text-xs text-slate-300 leading-relaxed">
                  Browse latest 5G smartphones or bring your existing device for screen repair, battery fix, or instant buyback quote.
                </p>
              </div>

              <div className="p-6 rounded-2xl bg-white/5 border border-white/10 relative">
                <div className="w-10 h-10 rounded-xl bg-yellow-500/20 text-yellow-400 font-black text-lg flex items-center justify-center mb-4">
                  2
                </div>
                <h3 className="text-base font-black text-white mb-2">
                  15-Min Live Check &amp; Repair
                </h3>
                <p className="text-xs text-slate-300 leading-relaxed">
                  Our certified technicians test display, battery, and hardware right in front of your eyes using genuine OEM grade components.
                </p>
              </div>

              <div className="p-6 rounded-2xl bg-white/5 border border-white/10 relative">
                <div className="w-10 h-10 rounded-xl bg-emerald-500/20 text-emerald-400 font-black text-lg flex items-center justify-center mb-4">
                  3
                </div>
                <h3 className="text-base font-black text-white mb-2">
                  Official Bill &amp; Instant Transfer
                </h3>
                <p className="text-xs text-slate-300 leading-relaxed">
                  Receive official GST bill with up to 6 months store repair warranty, or receive immediate cash/UPI payment for sold devices.
                </p>
              </div>
            </div>
          </div>

          {/* Frequently Asked Questions */}
          <div className="bg-white rounded-3xl border border-slate-200/80 p-6 sm:p-8 lg:p-10 shadow-sm">
            <div className="mb-6">
              <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-slate-100 text-slate-700 text-xs font-bold uppercase tracking-wider border border-slate-200 mb-2">
                <HelpCircle size={13} className="text-slate-600" />
                Frequently Asked Questions
              </div>
              <h2 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
                Visiting &amp; Support Questions
              </h2>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-6">
              {FAQS.map((faq, index) => {
                const isOpen = openFaq === index;
                return (
                  <div
                    key={index}
                    onClick={() => setOpenFaq(isOpen ? null : index)}
                    className={`p-5 rounded-2xl border transition-all cursor-pointer ${
                      isOpen
                        ? 'bg-amber-50/70 border-amber-400 shadow-sm'
                        : 'bg-white border-slate-200/80 hover:border-slate-300 hover:bg-slate-50/40'
                    }`}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <h3 className="text-sm font-bold text-slate-900">
                        {faq.q}
                      </h3>
                      <ChevronRight
                        size={16}
                        className={`text-slate-400 shrink-0 mt-0.5 transition-transform duration-200 ${
                          isOpen ? 'rotate-90 text-amber-600' : ''
                        }`}
                      />
                    </div>
                    {isOpen && (
                      <p className="text-xs sm:text-sm text-slate-600 mt-3 pt-3 border-t border-amber-200/60 leading-relaxed">
                        {faq.a}
                      </p>
                    )}
                  </div>
                );
              })}
            </div>
          </div>

        </div>
      </section>

      <CustomerFooter />
    </main>
  );
}
