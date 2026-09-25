'use client';
import React from 'react';
import {
  Smartphone,
  Calendar,
  UserCheck,
  CheckCircle,
  ShieldCheck,
  CreditCard,
  ArrowRight,
  Sparkles,
  Award,
  Truck,
  Zap,
  Lock,
  Headphones,
} from 'lucide-react';

const steps = [
  {
    step: '01',
    title: 'Get Instant Quote',
    desc: 'Search your device and answer a few simple diagnostic questions to get the best valuation.',
    color: 'from-blue-600 to-indigo-600',
    iconBg: 'bg-blue-50 text-blue-600',
    mockup: {
      type: 'quote',
      deviceName: 'iPhone 15 Pro',
      quote: '₹ ****',
      badge: 'Best Value',
    },
  },
  {
    step: '02',
    title: 'Schedule Pickup',
    desc: "Choose a convenient date and time. We'll come to your doorstep and pick up your device for free.",
    color: 'from-indigo-600 to-purple-600',
    iconBg: 'bg-indigo-50 text-indigo-600',
    mockup: {
      type: 'calendar',
      date: 'Tomorrow, 11 AM - 1 PM',
      badge: 'Free Doorstep',
    },
  },
  {
    step: '03',
    title: 'Device Inspection',
    desc: 'Our certified executive arrives with QR scan verification and inspects the device condition on the spot.',
    color: 'from-purple-600 to-pink-600',
    iconBg: 'bg-purple-50 text-purple-600',
    mockup: {
      type: 'inspection',
      status: 'Verified Executive',
      check: 'QR Code Pass Scanned',
    },
  },
  {
    step: '04',
    title: 'Get Best Offer',
    desc: 'Get the final fair price based on inspection with zero hidden deductions. Accept the offer and proceed.',
    color: 'from-blue-600 to-cyan-600',
    iconBg: 'bg-cyan-50 text-cyan-600',
    mockup: {
      type: 'offer',
      finalPrice: 'Guaranteed Payout',
      btn: 'Customer Agreed',
    },
  },
  {
    step: '05',
    title: 'Secure Data Wipe',
    desc: 'Your data is 100% securely wiped using certified military-grade DoD sanitization to protect your privacy.',
    color: 'from-emerald-600 to-teal-600',
    iconBg: 'bg-emerald-50 text-emerald-600',
    mockup: {
      type: 'wipe',
      status: 'DoD 5220.22-M Wipe',
      result: '100% Privacy Safe',
    },
  },
  {
    step: '06',
    title: 'Instant Payment',
    desc: 'Receive immediate payment disbursed directly to your bank account via UPI, IMPS, or Spot Cash.',
    color: 'from-emerald-500 to-green-600',
    iconBg: 'bg-green-50 text-green-600',
    mockup: {
      type: 'payment',
      amount: 'Paid to Bank / UPI',
      status: 'Instant Transfer Done',
    },
  },
];

export default function HowBuybackWorksSection() {
  return (
    <section className="py-14 sm:py-20 bg-white border-t border-slate-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Section Header (Reference Image 3) */}
        <div className="text-center max-w-2xl mx-auto mb-12 sm:mb-16">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-blue-50 border border-blue-200 text-blue-700 text-xs font-black tracking-wider uppercase mb-3">
            <Zap size={13} className="fill-blue-600 text-blue-600" />
            <span>SIMPLE. FAST. SECURE.</span>
          </div>

          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-slate-900 tracking-tight">
            How <span className="text-blue-600">Maa Ambika</span> Buyback Works
          </h2>

          <p className="text-sm sm:text-base text-slate-500 font-medium mt-3">
            Selling your old device is simple, secure and rewarding. Follow these easy steps.
          </p>
        </div>

        {/* ── 6 STEP CARDS GRID (Reference Image 3) ── */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-6 gap-4 sm:gap-5 mb-14">
          {steps.map((item, idx) => (
            <div
              key={item.step}
              className="bg-white rounded-2xl p-4 sm:p-5 border border-slate-200/90 shadow-sm hover:shadow-xl hover:border-blue-500/50 transition-all duration-300 flex flex-col justify-between group hover:-translate-y-1 relative"
            >
              <div>
                {/* Step Number Badge */}
                <div className="flex items-center justify-between mb-4">
                  <div className="w-8 h-8 rounded-full bg-blue-600 text-white font-black text-xs flex items-center justify-center shadow-md shadow-blue-600/30">
                    {item.step}
                  </div>
                  {idx < steps.length - 1 && (
                    <ArrowRight size={14} className="hidden lg:block text-slate-300 group-hover:text-blue-500 transition-colors" />
                  )}
                </div>

                {/* Mockup Mini Card */}
                <div className="h-28 bg-slate-50 rounded-xl p-3 border border-slate-100 mb-4 flex flex-col items-center justify-center text-center shadow-inner group-hover:bg-blue-50/40 transition-colors">
                  {item.mockup.type === 'quote' && (
                    <div className="space-y-1">
                      <Smartphone size={20} className="mx-auto text-blue-600 mb-1" />
                      <p className="text-[10px] font-bold text-slate-500">{item.mockup.deviceName}</p>
                      <p className="text-xs font-black text-slate-900 bg-white px-2 py-0.5 rounded border border-slate-200">{item.mockup.quote}</p>
                    </div>
                  )}

                  {item.mockup.type === 'calendar' && (
                    <div className="space-y-1">
                      <Calendar size={20} className="mx-auto text-indigo-600 mb-1" />
                      <p className="text-[10px] font-black text-slate-800 leading-tight">{item.mockup.date}</p>
                      <span className="inline-block text-[9px] font-bold text-indigo-700 bg-indigo-50 px-1.5 py-0.5 rounded">
                        {item.mockup.badge}
                      </span>
                    </div>
                  )}

                  {item.mockup.type === 'inspection' && (
                    <div className="space-y-1">
                      <UserCheck size={20} className="mx-auto text-purple-600 mb-1" />
                      <p className="text-[10px] font-black text-slate-800">{item.mockup.status}</p>
                      <span className="inline-block text-[9px] font-bold text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded">
                        {item.mockup.check}
                      </span>
                    </div>
                  )}

                  {item.mockup.type === 'offer' && (
                    <div className="space-y-1">
                      <Award size={20} className="mx-auto text-cyan-600 mb-1" />
                      <p className="text-[10px] font-black text-slate-900">{item.mockup.finalPrice}</p>
                      <span className="inline-block text-[9px] font-bold text-blue-700 bg-blue-100/70 px-2 py-0.5 rounded">
                        {item.mockup.btn}
                      </span>
                    </div>
                  )}

                  {item.mockup.type === 'wipe' && (
                    <div className="space-y-1">
                      <ShieldCheck size={22} className="mx-auto text-emerald-600 mb-1" />
                      <p className="text-[10px] font-black text-slate-800">{item.mockup.status}</p>
                      <span className="inline-block text-[9px] font-bold text-emerald-700 bg-emerald-50 px-1.5 py-0.5 rounded">
                        {item.mockup.result}
                      </span>
                    </div>
                  )}

                  {item.mockup.type === 'payment' && (
                    <div className="space-y-1">
                      <CreditCard size={20} className="mx-auto text-green-600 mb-1" />
                      <p className="text-[10px] font-black text-emerald-700">{item.mockup.amount}</p>
                      <span className="inline-block text-[9px] font-bold text-emerald-800 bg-emerald-100 px-1.5 py-0.5 rounded">
                        {item.mockup.status}
                      </span>
                    </div>
                  )}
                </div>

                {/* Title & Desc */}
                <h3 className="text-sm font-black text-slate-900 mb-1.5 group-hover:text-blue-600 transition-colors">
                  {item.title}
                </h3>
                <p className="text-[11px] text-slate-500 font-medium leading-relaxed">
                  {item.desc}
                </p>
              </div>
            </div>
          ))}
        </div>

        {/* ── BOTTOM HORIZONTAL TRUST STRIP (Reference Image 3) ── */}
        <div className="bg-slate-50 rounded-2xl p-5 border border-slate-200/80 shadow-xs grid grid-cols-2 md:grid-cols-5 gap-4 text-center">
          <div className="flex flex-col items-center gap-1.5">
            <div className="w-9 h-9 rounded-xl bg-blue-100/70 text-blue-700 flex items-center justify-center">
              <Award size={18} />
            </div>
            <p className="text-xs font-black text-slate-800">Best Price Guaranteed</p>
            <p className="text-[10px] text-slate-400 font-medium">Top market valuation</p>
          </div>

          <div className="flex flex-col items-center gap-1.5">
            <div className="w-9 h-9 rounded-xl bg-emerald-100/70 text-emerald-700 flex items-center justify-center">
              <Truck size={18} />
            </div>
            <p className="text-xs font-black text-slate-800">Free Doorstep Pickup</p>
            <p className="text-[10px] text-slate-400 font-medium">Zero pickup fees</p>
          </div>

          <div className="flex flex-col items-center gap-1.5">
            <div className="w-9 h-9 rounded-xl bg-amber-100/70 text-amber-700 flex items-center justify-center">
              <Zap size={18} />
            </div>
            <p className="text-xs font-black text-slate-800">Instant Payment</p>
            <p className="text-[10px] text-slate-400 font-medium">Spot UPI / Bank / Cash</p>
          </div>

          <div className="flex flex-col items-center gap-1.5">
            <div className="w-9 h-9 rounded-xl bg-purple-100/70 text-purple-700 flex items-center justify-center">
              <Lock size={18} />
            </div>
            <p className="text-xs font-black text-slate-800">100% Safe &amp; Secure</p>
            <p className="text-[10px] text-slate-400 font-medium">DoD military data wipe</p>
          </div>

          <div className="flex flex-col items-center gap-1.5 col-span-2 md:col-span-1">
            <div className="w-9 h-9 rounded-xl bg-rose-100/70 text-rose-700 flex items-center justify-center">
              <Headphones size={18} />
            </div>
            <p className="text-xs font-black text-slate-800">24x7 Customer Support</p>
            <p className="text-[10px] text-slate-400 font-medium">+91 8260120467</p>
          </div>
        </div>

      </div>
    </section>
  );
}
