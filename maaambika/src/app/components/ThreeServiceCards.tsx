'use client';
import React from 'react';
import Link from 'next/link';
import {
  Tag,
  ShoppingBag,
  Wrench,
  ShieldCheck,
  CheckCircle2,
  ArrowRight,
  Truck,
  Zap,
  Lock,
  Star,
  Headphones,
} from 'lucide-react';

export default function ThreeServiceCards() {
  return (
    <section className="py-12 sm:py-16 bg-slate-50/50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Section Heading */}
        <div className="text-center max-w-2xl mx-auto mb-10 sm:mb-12">
          <p className="text-xs sm:text-sm font-extrabold uppercase tracking-wider text-blue-600 mb-2">
            Complete Device Lifecycle
          </p>
          <h2 className="text-2xl sm:text-3xl lg:text-4xl font-black text-slate-900 tracking-tight">
            Sell, Buy &amp; Repair — All in One Trusted Place
          </h2>
          <p className="text-sm text-slate-500 font-medium mt-2">
            Transparent pricing, 100% verified genuine parts, and door-to-door convenience with zero hassle.
          </p>
        </div>

        {/* ── 3 PROMINENT SERVICE CARDS (Reference Image 1) ── */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 lg:gap-8 mb-12">
          
          {/* ── CARD 1: SELL YOUR DEVICE (GREEN THEME) ── */}
          <div className="bg-white rounded-3xl p-6 sm:p-7 border border-slate-200/90 shadow-lg hover:shadow-2xl hover:shadow-emerald-500/10 transition-all duration-300 flex flex-col justify-between group hover:-translate-y-1 relative overflow-hidden">
            {/* Top Pill Icon */}
            <div className="flex items-center justify-between mb-5">
              <div className="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center border border-emerald-100 shadow-xs">
                <Tag className="w-6 h-6" />
              </div>
            </div>

            {/* Content & Floating Device Layout */}
            <div className="relative mb-6">
              <div className="pr-24 sm:pr-28">
                <h3 className="text-2xl font-black text-slate-900 tracking-tight mb-2">
                  Sell <span className="text-emerald-600">Your Device</span>
                </h3>
                <p className="text-xs text-slate-500 leading-relaxed font-medium mb-5">
                  Get the best value for your old devices in 60 seconds with instant doorstep cash.
                </p>

                {/* 4 Feature Checklist */}
                <div className="space-y-2.5">
                  {[
                    'Best Price Guaranteed',
                    'Free Doorstep Pickup',
                    'Instant Payment',
                    '100% Safe & Secure',
                  ].map((feat) => (
                    <div key={feat} className="flex items-center gap-2 text-xs font-bold text-slate-700">
                      <CheckCircle2 className="w-4 h-4 text-emerald-500 shrink-0" />
                      <span>{feat}</span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Floating Device Visual on Right */}
              <div className="absolute -right-2 top-0 w-28 sm:w-32 h-44 flex items-center justify-center pointer-events-none group-hover:scale-105 transition-transform duration-300">
                <img
                  src="/assets/images/categories/smartphone.png"
                  alt="Sell Smartphone"
                  className="max-h-full object-contain filter drop-shadow-lg"
                  onError={(e) => {
                    e.currentTarget.src = '/assets/images/refurbished/iphone-15-pro.png';
                  }}
                />
              </div>
            </div>

            {/* CTA Button */}
            <div>
              <Link
                href="/sell-device-get-quote"
                className="w-full py-3.5 px-5 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-black text-xs sm:text-sm shadow-md shadow-emerald-600/25 flex items-center justify-center gap-2 transition-all duration-200 group-hover:scale-[1.02]"
              >
                <span>Get Device Value</span>
                <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
              </Link>

              {/* Social Proof Footer */}
              <div className="mt-4 pt-4 border-t border-slate-100 flex items-center gap-2 text-[11px] font-bold text-slate-500">
                <div className="flex -space-x-1.5">
                  <div className="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-[9px] font-black border border-white">A</div>
                  <div className="w-5 h-5 rounded-full bg-emerald-600 text-white flex items-center justify-center text-[9px] font-black border border-white">R</div>
                  <div className="w-5 h-5 rounded-full bg-purple-600 text-white flex items-center justify-center text-[9px] font-black border border-white">S</div>
                </div>
                <span>50,000+ devices sold last month</span>
              </div>
            </div>
          </div>

          {/* ── CARD 2: BUY REFURBISHED (BLUE THEME) ── */}
          <div className="bg-white rounded-3xl p-6 sm:p-7 border border-slate-200/90 shadow-lg hover:shadow-2xl hover:shadow-blue-500/10 transition-all duration-300 flex flex-col justify-between group hover:-translate-y-1 relative overflow-hidden">
            {/* Top Pill Icon */}
            <div className="flex items-center justify-between mb-5">
              <div className="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center border border-blue-100 shadow-xs">
                <ShoppingBag className="w-6 h-6" />
              </div>
            </div>

            {/* Content & Floating Device Layout */}
            <div className="relative mb-6">
              <div className="pr-24 sm:pr-28">
                <h3 className="text-2xl font-black text-slate-900 tracking-tight mb-2">
                  Buy <span className="text-blue-600">Refurbished</span>
                </h3>
                <p className="text-xs text-slate-500 leading-relaxed font-medium mb-5">
                  Certified, tested and reliable devices at the best prices with manufacturer warranty.
                </p>

                {/* 4 Feature Checklist */}
                <div className="space-y-2.5">
                  {[
                    '32 Point Quality Check',
                    '6 Months Warranty',
                    'Easy Returns',
                    'Best Market Prices',
                  ].map((feat) => (
                    <div key={feat} className="flex items-center gap-2 text-xs font-bold text-slate-700">
                      <CheckCircle2 className="w-4 h-4 text-blue-500 shrink-0" />
                      <span>{feat}</span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Floating Device Visual on Right */}
              <div className="absolute -right-2 top-0 w-28 sm:w-32 h-44 flex items-center justify-center pointer-events-none group-hover:scale-105 transition-transform duration-300">
                <img
                  src="/assets/images/refurbished/galaxy-s24-ultra.png"
                  alt="Certified Refurbished Device"
                  className="max-h-full object-contain filter drop-shadow-lg"
                  onError={(e) => {
                    e.currentTarget.src = '/assets/images/categories/smartphone.png';
                  }}
                />
              </div>
            </div>

            {/* CTA Button */}
            <div>
              <Link
                href="/buy-refurbished"
                className="w-full py-3.5 px-5 rounded-2xl bg-blue-600 hover:bg-blue-700 text-white font-black text-xs sm:text-sm shadow-md shadow-blue-600/25 flex items-center justify-center gap-2 transition-all duration-200 group-hover:scale-[1.02]"
              >
                <span>Explore Devices</span>
                <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
              </Link>

              {/* Social Proof Footer */}
              <div className="mt-4 pt-4 border-t border-slate-100 flex items-center gap-2 text-[11px] font-bold text-slate-500">
                <div className="flex -space-x-1.5">
                  <div className="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-[9px] font-black border border-white">A</div>
                  <div className="w-5 h-5 rounded-full bg-indigo-600 text-white flex items-center justify-center text-[9px] font-black border border-white">R</div>
                  <div className="w-5 h-5 rounded-full bg-teal-600 text-white flex items-center justify-center text-[9px] font-black border border-white">S</div>
                </div>
                <span>10,000+ happy buyers</span>
              </div>
            </div>
          </div>

          {/* ── CARD 3: REPAIR YOUR DEVICE (PURPLE THEME) ── */}
          <div className="bg-white rounded-3xl p-6 sm:p-7 border border-slate-200/90 shadow-lg hover:shadow-2xl hover:shadow-purple-500/10 transition-all duration-300 flex flex-col justify-between group hover:-translate-y-1 relative overflow-hidden">
            {/* Top Pill Icon */}
            <div className="flex items-center justify-between mb-5">
              <div className="w-12 h-12 rounded-2xl bg-purple-50 text-purple-600 flex items-center justify-center border border-purple-100 shadow-xs">
                <Wrench className="w-6 h-6" />
              </div>
              <div className="w-7 h-7 rounded-full bg-purple-50 text-purple-600 flex items-center justify-center border border-purple-200">
                <ShieldCheck size={16} />
              </div>
            </div>

            {/* Content & Floating Device Layout */}
            <div className="relative mb-6">
              <div className="pr-24 sm:pr-28">
                <h3 className="text-2xl font-black text-slate-900 tracking-tight mb-2">
                  Repair <span className="text-purple-600">Your Device</span>
                </h3>
                <p className="text-xs text-slate-500 leading-relaxed font-medium mb-5">
                  Expert repair services with original parts, certified technicians &amp; warranty.
                </p>

                {/* 4 Feature Checklist */}
                <div className="space-y-2.5">
                  {[
                    'Screen & Battery Repair',
                    'Original Parts Used',
                    'Expert Technicians',
                    'Warranty on Repair',
                  ].map((feat) => (
                    <div key={feat} className="flex items-center gap-2 text-xs font-bold text-slate-700">
                      <CheckCircle2 className="w-4 h-4 text-purple-500 shrink-0" />
                      <span>{feat}</span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Floating Device Visual on Right */}
              <div className="absolute -right-2 top-0 w-28 sm:w-32 h-44 flex items-center justify-center pointer-events-none group-hover:scale-105 transition-transform duration-300">
                <img
                  src="/assets/images/categories/laptop.png"
                  alt="Expert Device Repair"
                  className="max-h-full object-contain filter drop-shadow-lg"
                  onError={(e) => {
                    e.currentTarget.src = '/assets/images/categories/smartphone.png';
                  }}
                />
              </div>
            </div>

            {/* CTA Button */}
            <div>
              <Link
                href="/repair-device"
                className="w-full py-3.5 px-5 rounded-2xl bg-purple-600 hover:bg-purple-700 text-white font-black text-xs sm:text-sm shadow-md shadow-purple-600/25 flex items-center justify-center gap-2 transition-all duration-200 group-hover:scale-[1.02]"
              >
                <span>Book a Repair</span>
                <ArrowRight size={16} className="group-hover:translate-x-1 transition-transform" />
              </Link>

              {/* Social Proof Footer */}
              <div className="mt-4 pt-4 border-t border-slate-100 flex items-center gap-2 text-[11px] font-bold text-slate-500">
                <div className="flex -space-x-1.5">
                  <div className="w-5 h-5 rounded-full bg-purple-600 text-white flex items-center justify-center text-[9px] font-black border border-white">A</div>
                  <div className="w-5 h-5 rounded-full bg-indigo-600 text-white flex items-center justify-center text-[9px] font-black border border-white">R</div>
                  <div className="w-5 h-5 rounded-full bg-violet-600 text-white flex items-center justify-center text-[9px] font-black border border-white">S</div>
                </div>
                <span>25,000+ repairs completed</span>
              </div>
            </div>
          </div>

        </div>

        {/* ── SUBTLE TRUST STRIP BELOW CARDS (Reference Image 1) ── */}
        <div className="bg-white rounded-2xl p-4 sm:p-5 border border-slate-200/90 shadow-sm flex flex-wrap items-center justify-between gap-4 text-xs sm:text-sm font-bold text-slate-700">
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center border border-emerald-100">
              <Truck size={18} />
            </div>
            <span>Free Doorstep Pickup</span>
          </div>

          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center border border-amber-100">
              <Zap size={18} />
            </div>
            <span>Instant Payment</span>
          </div>

          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center border border-blue-100">
              <Lock size={18} />
            </div>
            <span>Secure &amp; Safe</span>
          </div>

          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center border border-purple-100">
              <Star size={18} />
            </div>
            <span>Trusted by 50K+</span>
          </div>

          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-xl bg-rose-50 text-rose-600 flex items-center justify-center border border-rose-100">
              <Headphones size={18} />
            </div>
            <span>24/7 Helpline Support</span>
          </div>
        </div>

      </div>
    </section>
  );
}
