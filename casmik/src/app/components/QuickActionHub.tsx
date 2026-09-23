'use client';
import React from 'react';
import Link from 'next/link';
import {
  Zap,
  ShieldCheck,
  ArrowLeftRight,
  ArrowRight,
  CheckCircle2,
  Sparkles,
  Smartphone,
  Wrench,
  Headphones,
  ShoppingBag,
  Coins,
  Truck,
  PhoneCall,
  Clock,
  Battery,
} from 'lucide-react';

export default function QuickActionHub() {
  return (
    <section className="relative z-20 -mt-6 sm:-mt-8 lg:-mt-10 mb-8 sm:mb-12 px-4 sm:px-6 lg:px-8 xl:px-10 max-w-screen-2xl mx-auto">
      {/* 4 Core Pillars Grid from Maa Ambika Mobile Shop */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
        
        {/* ── CARD 1: SALES (NEW & CERTIFIED PHONES) ── */}
        <div className="group relative rounded-3xl bg-white border border-slate-200/90 hover:border-amber-500/70 p-6 shadow-lg hover:shadow-2xl hover:shadow-amber-500/15 transition-all duration-300 flex flex-col justify-between overflow-hidden hover:-translate-y-1.5">
          <div className="absolute -top-16 -right-16 w-44 h-44 bg-gradient-to-br from-amber-400/20 via-yellow-400/10 to-transparent rounded-full blur-2xl pointer-events-none group-hover:scale-125 transition-transform duration-500" />
          <div>
            <div className="flex items-center justify-between gap-2 mb-4">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-50 border border-amber-200 text-[11px] font-black uppercase tracking-wider text-amber-800">
                <Sparkles size={12} className="text-amber-600 fill-amber-500" />
                Sales &amp; Store
              </span>
              <div className="flex items-center gap-1.5 text-amber-500">
                <Smartphone size={16} />
                <ShoppingBag size={16} />
              </div>
            </div>

            <h3 className="text-xl font-black text-slate-900 tracking-tight mb-2 group-hover:text-amber-700 transition-colors">
              New &amp; Certified Phones
            </h3>
            <p className="text-xs text-slate-600 leading-relaxed mb-4">
              Best price guaranteed on iPhone 16/15 Pro, Samsung Galaxy S24, OnePlus 12 &amp; certified refurbished with 1-year warranty.
            </p>

            <div className="space-y-2 mb-5 pt-3 border-t border-slate-100 text-xs font-semibold text-slate-700">
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-amber-600 shrink-0" />
                <span>100% Genuine brand sealed &amp; certified</span>
              </div>
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-amber-600 shrink-0" />
                <span>GST Tax Invoice: 21ELDPS6270L1ZS</span>
              </div>
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-amber-600 shrink-0" />
                <span>Zero-cost EMI &amp; spot delivery</span>
              </div>
            </div>

            <div className="flex flex-wrap gap-1.5 mb-5">
              {['iPhones', 'Samsung S24', 'OnePlus', 'Tablets'].map((item) => (
                <span
                  key={item}
                  className="px-2 py-0.5 rounded-lg bg-amber-50/80 text-[10px] font-bold text-amber-800 border border-amber-200/50"
                >
                  {item}
                </span>
              ))}
            </div>
          </div>

          <Link
            href="/buy-refurbished"
            className="w-full py-3 px-4 rounded-xl bg-gradient-to-r from-amber-500 via-amber-600 to-yellow-500 hover:from-amber-600 hover:to-yellow-600 text-slate-950 font-black text-xs shadow-md shadow-amber-500/25 flex items-center justify-center gap-2 transition-all duration-200 group-hover:scale-[1.02]"
          >
            <span>Explore Mobile Store</span>
            <ArrowRight size={14} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </div>

        {/* ── CARD 2: INSTANT SELL (DOORSTEP CASH) ── */}
        <div className="group relative rounded-3xl bg-white border border-slate-200/90 hover:border-emerald-500/70 p-6 shadow-lg hover:shadow-2xl hover:shadow-emerald-500/15 transition-all duration-300 flex flex-col justify-between overflow-hidden hover:-translate-y-1.5">
          <div className="absolute -top-16 -right-16 w-44 h-44 bg-gradient-to-br from-emerald-400/20 via-teal-400/10 to-transparent rounded-full blur-2xl pointer-events-none group-hover:scale-125 transition-transform duration-500" />
          <div>
            <div className="flex items-center justify-between gap-2 mb-4">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 border border-emerald-200 text-[11px] font-black uppercase tracking-wider text-emerald-800">
                <Zap size={12} className="text-emerald-600 fill-emerald-500" />
                Spot Cash Payout
              </span>
              <div className="flex items-center gap-1.5 text-emerald-500">
                <Coins size={16} />
                <Truck size={16} />
              </div>
            </div>

            <h3 className="text-xl font-black text-slate-900 tracking-tight mb-2 group-hover:text-emerald-700 transition-colors">
              Sell Old Phones &amp; Tech
            </h3>
            <p className="text-xs text-slate-600 leading-relaxed mb-4">
              Get maximum market resale value for your old smartphone, laptop, or tablet with instant AI evaluation and doorstep cash.
            </p>

            <div className="space-y-2 mb-5 pt-3 border-t border-slate-100 text-xs font-semibold text-slate-700">
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-emerald-600 shrink-0" />
                <span>Instant UPI transfer before device handover</span>
              </div>
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-emerald-600 shrink-0" />
                <span>Free doorstep pickup &amp; instant testing</span>
              </div>
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-emerald-600 shrink-0" />
                <span>Certified 100% military data wipe</span>
              </div>
            </div>

            <div className="flex flex-wrap gap-1.5 mb-5">
              {['Smartphones', 'Laptops', 'iPads', 'Cameras'].map((item) => (
                <span
                  key={item}
                  className="px-2 py-0.5 rounded-lg bg-emerald-50/80 text-[10px] font-bold text-emerald-800 border border-emerald-200/50"
                >
                  {item}
                </span>
              ))}
            </div>
          </div>

          <Link
            href="/sell-device-get-quote"
            className="w-full py-3 px-4 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-700 hover:to-teal-700 text-white font-black text-xs shadow-md shadow-emerald-600/25 flex items-center justify-center gap-2 transition-all duration-200 group-hover:scale-[1.02]"
          >
            <span>Get Instant Phone Quote</span>
            <ArrowRight size={14} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </div>

        {/* ── CARD 3: 1-STEP EXCHANGE ── */}
        <div className="group relative rounded-3xl bg-white border border-slate-200/90 hover:border-purple-500/70 p-6 shadow-lg hover:shadow-2xl hover:shadow-purple-500/15 transition-all duration-300 flex flex-col justify-between overflow-hidden hover:-translate-y-1.5">
          <div className="absolute -top-16 -right-16 w-44 h-44 bg-gradient-to-br from-purple-400/20 via-indigo-400/10 to-transparent rounded-full blur-2xl pointer-events-none group-hover:scale-125 transition-transform duration-500" />
          <div>
            <div className="flex items-center justify-between gap-2 mb-4">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-purple-50 border border-purple-200 text-[11px] font-black uppercase tracking-wider text-purple-800">
                <ArrowLeftRight size={12} className="text-purple-600" />
                +₹5,000 Exchange Bonus
              </span>
              <div className="flex items-center gap-1.5 text-purple-500">
                <ArrowLeftRight size={16} />
              </div>
            </div>

            <h3 className="text-xl font-black text-slate-900 tracking-tight mb-2 group-hover:text-purple-700 transition-colors">
              1-Step Device Exchange
            </h3>
            <p className="text-xs text-slate-600 leading-relaxed mb-4">
              Exchange your old mobile phone towards the latest model with zero downtime. Handover old phone, get upgraded phone immediately.
            </p>

            <div className="space-y-2 mb-5 pt-3 border-t border-slate-100 text-xs font-semibold text-slate-700">
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-purple-600 shrink-0" />
                <span>Special exchange top-up bonus included</span>
              </div>
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-purple-600 shrink-0" />
                <span>Doorstep data transfer assistance</span>
              </div>
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-purple-600 shrink-0" />
                <span>Pay only net difference on delivery</span>
              </div>
            </div>

            <div className="flex flex-wrap gap-1.5 mb-5">
              {['Android to iPhone', 'Old to New', 'Brand to Brand'].map((item) => (
                <span
                  key={item}
                  className="px-2 py-0.5 rounded-lg bg-purple-50/80 text-[10px] font-bold text-purple-800 border border-purple-200/50"
                >
                  {item}
                </span>
              ))}
            </div>
          </div>

          <Link
            href="/exchange-device"
            className="w-full py-3 px-4 rounded-xl bg-gradient-to-r from-purple-600 via-indigo-600 to-purple-700 hover:from-purple-700 hover:to-indigo-700 text-white font-black text-xs shadow-md shadow-purple-600/25 flex items-center justify-center gap-2 transition-all duration-200 group-hover:scale-[1.02]"
          >
            <span>Start Device Exchange</span>
            <ArrowRight size={14} className="group-hover:translate-x-1 transition-transform" />
          </Link>
        </div>

        {/* ── CARD 4: SERVICE, REPAIR & ACCESSORIES ── */}
        <div className="group relative rounded-3xl bg-white border border-slate-200/90 hover:border-blue-500/70 p-6 shadow-lg hover:shadow-2xl hover:shadow-blue-500/15 transition-all duration-300 flex flex-col justify-between overflow-hidden hover:-translate-y-1.5">
          <div className="absolute -top-16 -right-16 w-44 h-44 bg-gradient-to-br from-blue-400/20 via-cyan-400/10 to-transparent rounded-full blur-2xl pointer-events-none group-hover:scale-125 transition-transform duration-500" />
          <div>
            <div className="flex items-center justify-between gap-2 mb-4">
              <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-blue-50 border border-blue-200 text-[11px] font-black uppercase tracking-wider text-blue-800">
                <Wrench size={12} className="text-blue-600" />
                Service &amp; Accessories
              </span>
              <div className="flex items-center gap-1.5 text-blue-500">
                <Wrench size={16} />
                <Headphones size={16} />
              </div>
            </div>

            <h3 className="text-xl font-black text-slate-900 tracking-tight mb-2 group-hover:text-blue-700 transition-colors">
              Mobile Repair &amp; Add-ons
            </h3>
            <p className="text-xs text-slate-600 leading-relaxed mb-4">
              Certified screen, battery, camera &amp; board repair. Original chargers, earbuds, smartwatches, covers &amp; recharges.
            </p>

            <div className="space-y-2 mb-5 pt-3 border-t border-slate-100 text-xs font-semibold text-slate-700">
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-blue-600 shrink-0" />
                <span>Original screens, batteries &amp; parts</span>
              </div>
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-blue-600 shrink-0" />
                <span>Up to 6-month repair service warranty</span>
              </div>
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-blue-600 shrink-0" />
                <span>Call support: +91 8260120467</span>
              </div>
            </div>

            <div className="flex flex-wrap gap-1.5 mb-5">
              {['Display Fix', 'Battery Health', 'Chargers', 'Recharge'].map((item) => (
                <span
                  key={item}
                  className="px-2 py-0.5 rounded-lg bg-blue-50/80 text-[10px] font-bold text-blue-800 border border-blue-200/50"
                >
                  {item}
                </span>
              ))}
            </div>
          </div>

          <a
            href="tel:+918260120467"
            className="w-full py-3 px-4 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-black text-xs shadow-md shadow-blue-600/25 flex items-center justify-center gap-2 transition-all duration-200 group-hover:scale-[1.02]"
          >
            <PhoneCall size={14} />
            <span>Book Repair: 8260120467</span>
          </a>
        </div>

      </div>
    </section>
  );
}
