'use client';
import React, { useState, useEffect, useRef } from 'react';
import Link from 'next/link';
import {
  ChevronLeft,
  ChevronRight,
  Sparkles,
  ShieldCheck,
  Zap,
  Truck,
  Camera,
  ArrowRight,
  Search,
  CheckCircle,
  TrendingUp,
} from 'lucide-react';
import { deviceModels, brands } from '@/lib/casmikData';

interface HeroSlide {
  id: string;
  badge: string;
  titlePrefix: string;
  titleHighlight: string;
  titleSuffix?: string;
  description: string;
  ctaText: string;
  ctaLink: string;
  categoryFilter: string;
  bgGradient: string;
  accentColor: string;
  image: string;
  imageAlt: string;
  stats: { label: string; value: string }[];
}

const slides: HeroSlide[] = [
  {
    id: 'slide-maa-ambika-flagship',
    badge: '👑 OFFICIAL SHOWROOM • GSTIN: 21ELDPS6270L1ZS',
    titlePrefix: 'Maa Ambika ',
    titleHighlight: 'Mobile Shop',
    titleSuffix: ' — Your Digital Life Partner',
    description:
      'Best Products • Best Price • Best Service. Explore brand new 5G smartphones, certified mobile screen repairs, original accessories, instant all-network recharges, and top cash for old devices. Helpline: +91 8260120467.',
    ctaText: 'Explore Mobile Store',
    ctaLink: '/user',
    categoryFilter: 'cat-smartphone',
    bgGradient: 'from-[#1a0f02] via-[#2d1b04] to-[#120a02]',
    accentColor: '#f59e0b',
    image: '/assets/images/app_logo.png',
    imageAlt: 'Maa Ambika Mobile Shop - Official Golden Logo & Showroom',
    stats: [
      { label: 'GSTIN Registered', value: '21ELDPS6270L1ZS' },
      { label: 'Store Helpline', value: '+91 8260120467' },
      { label: 'Core Services', value: 'Sales • Service • Recharge' },
    ],
  },
  {
    id: 'slide-sales-smartphones',
    badge: '📱 SALES: 100% BRAND NEW 5G SMARTPHONES',
    titlePrefix: 'Buy Latest ',
    titleHighlight: 'iPhones & 5G Smartphones',
    titleSuffix: ' at Best Price',
    description:
      'Guaranteed best market price on Apple iPhone 16 / 15 series, Samsung Galaxy S24, OnePlus 12, Vivo, Oppo, Realme & Xiaomi. Official brand sealed boxes with manufacturer warranty and GST retail invoice.',
    ctaText: 'Browse New Phones',
    ctaLink: '/user',
    categoryFilter: 'cat-smartphone',
    bgGradient: 'from-blue-950 via-slate-900 to-indigo-950',
    accentColor: '#3b82f6',
    image: '/assets/images/categories/smartphone-banner.png',
    imageAlt: 'New 5G Smartphones and iPhones at Maa Ambika Mobile Shop',
    stats: [
      { label: 'Top Brands', value: 'Apple • Samsung • OnePlus' },
      { label: 'Official Warranty', value: '100% Brand Sealed' },
      { label: 'GST Invoice', value: 'Instant Tax Bill' },
    ],
  },
  {
    id: 'slide-service-repairs',
    badge: '🔧 SERVICE: 30-MIN DOORSTEP & STORE REPAIR',
    titlePrefix: 'Certified ',
    titleHighlight: 'Mobile Screen & Battery',
    titleSuffix: ' Repairs',
    description:
      'Cracked display, battery draining fast, charging port loose, or water damage? Certified technicians repair your phone right in front of your eyes using 100% genuine OEM parts with up to 6 months store warranty.',
    ctaText: 'Book Fast Repair',
    ctaLink: '/user/repair',
    categoryFilter: 'cat-smartphone',
    bgGradient: 'from-emerald-950 via-slate-900 to-teal-950',
    accentColor: '#10b981',
    image: '/assets/images/categories/smartphone.png',
    imageAlt: 'Certified Mobile Repair & Screen Replacement at Maa Ambika Mobile Shop',
    stats: [
      { label: 'Repair Speed', value: '30-45 Minutes' },
      { label: 'Service Warranty', value: 'Up to 6 Months' },
      { label: 'Doorstep Check', value: 'Free Diagnostic' },
    ],
  },
  {
    id: 'slide-accessories',
    badge: '🎧 ACCESSORIES: 100% ORIGINAL GEAR',
    titlePrefix: 'AirPods, Smartwatches & ',
    titleHighlight: 'Fast Chargers',
    titleSuffix: ' in Stock',
    description:
      'Upgrade your lifestyle with original Apple AirPods, boAt/Noise smartwatches, 33W-120W GaN Super Fast Chargers, tough braided Type-C cables, shatterproof tempered glass and premium shockproof covers.',
    ctaText: 'Shop Accessories',
    ctaLink: '/user',
    categoryFilter: 'cat-smartphone',
    bgGradient: 'from-violet-950 via-slate-900 to-purple-950',
    accentColor: '#8b5cf6',
    image: '/assets/images/app_logo.png',
    imageAlt: 'Original Mobile Accessories at Maa Ambika Mobile Shop',
    stats: [
      { label: 'Accessories Range', value: 'AirPods • Watches • Chargers' },
      { label: 'Quality Check', value: '100% Tested' },
      { label: 'Fast GaN Chargers', value: '33W to 120W' },
    ],
  },
  {
    id: 'slide-instant-sell',
    badge: '💰 RECOMMERCE: INSTANT CASH FOR OLD PHONES',
    titlePrefix: 'Sell Used Phones for ',
    titleHighlight: 'Highest Spot Cash',
    titleSuffix: ' at Doorstep',
    description:
      'Get instant AI valuation for your old smartphone. Free doorstep pickup, on-the-spot physical testing, DoD military data wipe, and immediate UPI or cash transfer before device handover.',
    ctaText: 'Get Phone Valuation',
    ctaLink: '/sell-device-get-quote?cat=cat-smartphone',
    categoryFilter: 'cat-smartphone',
    bgGradient: 'from-amber-950 via-slate-900 to-yellow-950',
    accentColor: '#f59e0b',
    image: '/assets/images/categories/smartphone-banner.png',
    imageAlt: 'Sell Used Mobile Phones for Instant Cash at Maa Ambika Mobile Shop',
    stats: [
      { label: 'Payment Speed', value: 'Instant UPI / Cash' },
      { label: 'Data Security', value: '100% Military Wipe' },
      { label: 'Doorstep Pickup', value: 'Zero Charges (₹0)' },
    ],
  },
  {
    id: 'slide-exchange-recharge',
    badge: '⚡ RECHARGE & 1-STEP PHONE EXCHANGE',
    titlePrefix: 'Instant Mobile Recharge & ',
    titleHighlight: '+₹5,000 Exchange Bonus',
    titleSuffix: '',
    description:
      'All-network mobile prepaid/postpaid recharges (Jio, Airtel, Vi, BSNL) with zero convenience fee. Plus, exchange your old phone for any brand new 5G smartphone with up to ₹5,000 extra exchange bonus!',
    ctaText: '1-Step Phone Exchange',
    ctaLink: '/user/exchange',
    categoryFilter: 'cat-smartphone',
    bgGradient: 'from-cyan-950 via-slate-900 to-emerald-950',
    accentColor: '#06b6d4',
    image: '/assets/images/app_logo.png',
    imageAlt: '1-Step Device Exchange & Mobile Recharge at Maa Ambika Mobile Shop',
    stats: [
      { label: 'Exchange Bonus', value: 'Up to +₹5,000' },
      { label: 'Mobile Networks', value: 'Jio • Airtel • Vi • BSNL' },
      { label: 'SIM Services', value: '5G SIM & Porting' },
    ],
  },
];

export default function HeroBannerCarousel() {
  const [current, setCurrent] = useState(0);
  const [isPaused, setIsPaused] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [searchDropdown, setSearchDropdown] = useState(false);
  const timerRef = useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    if (isPaused) return;
    timerRef.current = setInterval(() => {
      setCurrent((prev) => (prev + 1) % slides.length);
    }, 4500);
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [isPaused]);

  const nextSlide = () => setCurrent((prev) => (prev + 1) % slides.length);
  const prevSlide = () => setCurrent((prev) => (prev - 1 + slides.length) % slides.length);

  const activeSlide = slides[current];

  // Quick suggestions for search
  const filteredModels = searchQuery.trim()
    ? deviceModels.filter((m) => m.name.toLowerCase().includes(searchQuery.toLowerCase())).slice(0, 5)
    : [];

  return (
    <section
      className="relative overflow-hidden pt-2 sm:pt-4 select-none w-full max-w-full"
      onMouseEnter={() => setIsPaused(true)}
      onMouseLeave={() => setIsPaused(false)}
    >
      {/* Slide Canvas */}
      <div className={`relative min-h-[520px] sm:min-h-[520px] lg:min-h-[580px] bg-gradient-to-br ${activeSlide.bgGradient} transition-all duration-700 flex items-center overflow-hidden`}>
        {/* Subtle Decorative Glows */}
        <div className="absolute -top-24 -left-24 w-96 h-96 bg-purple-500/10 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute -bottom-24 -right-24 w-96 h-96 bg-indigo-500/10 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute inset-0 bg-[radial-gradient(#ffffff0a_1px,transparent_1px)] [background-size:24px_24px] pointer-events-none" />

        <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 lg:px-8 xl:px-10 py-8 sm:py-12 lg:py-16 w-full relative z-10">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-center">
            {/* Left Content Column */}
            <div className="lg:col-span-7 xl:col-span-7 space-y-6 animate-in fade-in slide-in-from-left-4 duration-500 key={activeSlide.id}">
              {/* Badge */}
              <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white/10 backdrop-blur-md border border-white/15 text-xs font-bold tracking-wide text-purple-200">
                <Sparkles size={13} className="text-yellow-400" />
                <span>{activeSlide.badge}</span>
              </div>

              {/* Title */}
              <h1 className="text-2xl sm:text-4xl lg:text-5xl xl:text-6xl font-black text-white leading-tight tracking-tight text-balance">
                {activeSlide.titlePrefix}
                <span className="bg-gradient-to-r from-purple-400 via-pink-400 to-indigo-300 bg-clip-text text-transparent">
                  {activeSlide.titleHighlight}
                </span>
                {activeSlide.titleSuffix}
              </h1>

              {/* Description */}
              <p className="text-xs sm:text-base lg:text-lg text-slate-300 max-w-xl leading-relaxed">
                {activeSlide.description}
              </p>

              {/* Search & Instant CTA Row */}
              <div className="space-y-4 pt-2 max-w-xl">
                {/* Search Bar on Hero */}
                <div className="relative">
                  <div className="flex flex-col sm:flex-row sm:items-center bg-white/10 backdrop-blur-md border border-white/20 rounded-2xl p-1.5 shadow-2xl focus-within:bg-white/20 focus-within:border-purple-400 transition-all gap-1.5 sm:gap-0">
                    <div className="flex items-center flex-1 min-w-0">
                      <Search className="w-5 h-5 text-purple-300 ml-2.5 sm:ml-3 flex-shrink-0" />
                      <input
                        type="text"
                        value={searchQuery}
                        onChange={(e) => {
                          setSearchQuery(e.target.value);
                          setSearchDropdown(true);
                        }}
                        onFocus={() => {
                          if (searchQuery) setSearchDropdown(true);
                        }}
                        placeholder="Search smartphones, accessories, repairs (e.g. iPhone 16 Pro, Galaxy S24, Screen Fix...)"
                        className="w-full min-w-0 bg-transparent px-2.5 sm:px-3 py-2 text-sm text-white placeholder:text-slate-300 focus:outline-none"
                      />
                    </div>
                    <Link
                      href={activeSlide.ctaLink}
                      className="w-full sm:w-auto justify-center px-4 sm:px-5 py-2.5 sm:py-3 rounded-xl bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500 text-white text-xs sm:text-sm font-bold shadow-lg shadow-purple-600/30 whitespace-nowrap transition-all flex items-center gap-1.5 hover:gap-2.5"
                    >
                      <span>{activeSlide.ctaText}</span>
                      <ArrowRight size={15} />
                    </Link>
                  </div>

                  {/* Autocomplete Dropdown in Hero */}
                  {searchDropdown && filteredModels.length > 0 && (
                    <div className="absolute top-full left-0 right-0 mt-2 bg-slate-900/95 backdrop-blur-xl border border-white/20 rounded-2xl shadow-2xl overflow-hidden z-50 divide-y divide-white/10">
                      {filteredModels.map((m) => (
                        <Link
                          key={m.id}
                          href={`/sell-device-get-quote?model=${m.slug}`}
                          onClick={() => setSearchDropdown(false)}
                          className="flex items-center justify-between p-3 hover:bg-purple-600/20 transition-colors group"
                        >
                          <div className="flex items-center gap-3">
                            <div className="w-10 h-10 rounded-lg bg-white/10 p-1 flex items-center justify-center">
                              <img src={m.image} alt={m.name} className="w-full h-full object-contain" />
                            </div>
                            <div>
                              <p className="text-sm font-bold text-white group-hover:text-purple-300">{m.name}</p>
                              <p className="text-xs text-slate-400">Get up to ₹{m.basePrice.toLocaleString('en-IN')}</p>
                            </div>
                          </div>
                          <span className="text-xs font-semibold text-purple-400 group-hover:translate-x-1 transition-transform">
                            Sell Now →
                          </span>
                        </Link>
                      ))}
                    </div>
                  )}
                </div>

                {/* Popular Search Badges */}
                <div className="flex items-center gap-2 flex-wrap text-xs text-slate-300">
                  <span className="font-semibold text-slate-400">Popular:</span>
                  {['iPhone 16 Pro', 'Galaxy S24 Ultra', 'OnePlus 12', 'Vivo V40', 'Screen Repair', 'AirPods Pro', 'Fast Charger'].map((item) => (
                    <button
                      key={item}
                      type="button"
                      onClick={() => {
                        setSearchQuery(item);
                        setSearchDropdown(true);
                      }}
                      className="px-2.5 py-1 rounded-lg bg-white/10 hover:bg-white/20 text-slate-200 border border-white/10 transition-colors"
                    >
                      {item}
                    </button>
                  ))}
                </div>
              </div>

              {/* Stats Counters on Slide */}
              <div className="grid grid-cols-3 gap-2 sm:gap-4 pt-4 border-t border-white/10 max-w-xl">
                {activeSlide.stats.map((st) => (
                  <div key={st.label} className="min-w-0">
                    <p className="text-base sm:text-xl lg:text-2xl font-black text-white truncate">{st.value}</p>
                    <p className="text-[10px] sm:text-xs text-slate-400 mt-0.5 truncate">{st.label}</p>
                  </div>
                ))}
              </div>
            </div>

            {/* Right Visual / Camera Showcase */}
            <div className="lg:col-span-5 xl:col-span-5 flex justify-center items-center relative animate-in fade-in zoom-in-95 duration-500">
              <div
                className={`relative w-full ${
                  activeSlide.id === 'slide-smartphone'
                    ? 'max-w-[340px] sm:max-w-[480px] lg:max-w-[560px]'
                    : 'max-w-[280px] sm:max-w-[420px]'
                } aspect-[4/3] sm:aspect-square flex items-center justify-center mx-auto`}
              >
                {/* Glowing Orbit Rings */}
                <div className={`absolute inset-0 rounded-full border ${activeSlide.id === 'slide-maa-ambika-flagship' ? 'border-amber-400/30' : 'border-purple-500/20'} animate-spin [animation-duration:30s] pointer-events-none`} />
                <div className={`absolute inset-6 rounded-full border border-dashed ${activeSlide.id === 'slide-maa-ambika-flagship' ? 'border-yellow-400/40' : 'border-indigo-500/30'} animate-spin [animation-duration:20s] [animation-direction:reverse] pointer-events-none`} />
                <div className={`absolute inset-16 rounded-full ${activeSlide.id === 'slide-maa-ambika-flagship' ? 'bg-gradient-to-tr from-amber-500/30 to-yellow-600/20' : 'bg-gradient-to-tr from-purple-600/20 to-indigo-600/10'} blur-2xl pointer-events-none`} />

                {/* Main Hero Product Image */}
                <div
                  className={`relative z-10 ${
                    activeSlide.id === 'slide-smartphone' || activeSlide.id === 'slide-maa-ambika-flagship' ? 'w-full h-full' : 'w-4/5 h-4/5'
                  } flex items-center justify-center p-2 sm:p-4`}
                >
                  <img
                    src={activeSlide.image}
                    alt={activeSlide.imageAlt}
                    className="max-w-full max-h-full object-contain filter drop-shadow-[0_20px_45px_rgba(245,158,11,0.35)] transform hover:scale-105 transition-transform duration-500"
                  />
                </div>

                {/* Floating Benefit Cards */}
                {activeSlide.id === 'slide-maa-ambika-flagship' ? (
                  <>
                    <div className="hidden sm:flex absolute -top-2 left-0 bg-slate-950/95 backdrop-blur-md border border-amber-500/40 rounded-2xl p-3 shadow-2xl items-center gap-3 animate-bounce [animation-duration:3s]">
                      <div className="w-9 h-9 rounded-xl bg-amber-500/20 border border-amber-500/40 flex items-center justify-center text-amber-400">
                        <ShieldCheck size={18} />
                      </div>
                      <div>
                        <p className="text-xs font-black text-amber-300">GSTIN Registered</p>
                        <p className="text-[10px] text-slate-300 font-mono">21ELDPS6270L1ZS</p>
                      </div>
                    </div>

                    <div className="hidden sm:flex absolute -bottom-2 right-0 bg-slate-950/95 backdrop-blur-md border border-amber-500/40 rounded-2xl p-3 shadow-2xl items-center gap-3 animate-bounce [animation-duration:4s]">
                      <div className="w-9 h-9 rounded-xl bg-emerald-500/20 border border-emerald-500/40 flex items-center justify-center text-emerald-400">
                        <Zap size={18} />
                      </div>
                      <div>
                        <p className="text-xs font-black text-white">Call Helpline</p>
                        <p className="text-[10px] text-emerald-400 font-bold">+91 8260120467</p>
                      </div>
                    </div>
                  </>
                ) : activeSlide.id !== 'slide-smartphone' && (
                  <>
                    <div className="hidden sm:flex absolute top-4 left-0 bg-slate-900/90 backdrop-blur-md border border-white/15 rounded-2xl p-3 shadow-2xl items-center gap-3 animate-bounce [animation-duration:3s]">
                      <div className="w-9 h-9 rounded-xl bg-emerald-500/20 border border-emerald-500/30 flex items-center justify-center text-emerald-400">
                        <Zap size={18} />
                      </div>
                      <div>
                        <p className="text-xs font-bold text-white">Instant Payment</p>
                        <p className="text-[10px] text-slate-400">UPI / Bank at Pickup</p>
                      </div>
                    </div>

                    <div className="hidden sm:flex absolute bottom-4 right-0 bg-slate-900/90 backdrop-blur-md border border-white/15 rounded-2xl p-3 shadow-2xl items-center gap-3 animate-bounce [animation-duration:4s]">
                      <div className="w-9 h-9 rounded-xl bg-purple-500/20 border border-purple-500/30 flex items-center justify-center text-purple-400">
                        <Truck size={18} />
                      </div>
                      <div>
                        <p className="text-xs font-bold text-white">Free Doorstep Pickup</p>
                        <p className="text-[10px] text-slate-400">200+ Cities in India</p>
                      </div>
                    </div>
                  </>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* Carousel Navigation Arrows - desktop only to prevent mobile overflow */}
        <button
          onClick={prevSlide}
          className="hidden sm:flex absolute left-4 top-1/2 -translate-y-1/2 w-11 h-11 rounded-full bg-white/10 hover:bg-white/20 border border-white/20 backdrop-blur-md text-white items-center justify-center transition-all z-20 hover:scale-110"
          aria-label="Previous Slide"
        >
          <ChevronLeft size={22} />
        </button>
        <button
          onClick={nextSlide}
          className="hidden sm:flex absolute right-4 top-1/2 -translate-y-1/2 w-11 h-11 rounded-full bg-white/10 hover:bg-white/20 border border-white/20 backdrop-blur-md text-white items-center justify-center transition-all z-20 hover:scale-110"
          aria-label="Next Slide"
        >
          <ChevronRight size={22} />
        </button>

        {/* Carousel Indicators / Slide Bar */}
        <div className="absolute bottom-4 left-0 right-0 flex items-center justify-center gap-2 z-20">
          {slides.map((s, index) => (
            <button
              key={s.id}
              onClick={() => setCurrent(index)}
              className={`h-2 rounded-full transition-all duration-300 ${
                index === current ? 'w-8 bg-purple-500' : 'w-2.5 bg-white/30 hover:bg-white/50'
              }`}
              aria-label={`Go to slide ${index + 1}`}
            />
          ))}
        </div>
      </div>
    </section>
  );
}
