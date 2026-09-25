'use client';
import React, { useState, useRef, useEffect } from 'react';
import Link from 'next/link';
import {
  Search,
  ArrowRight,
  ShieldCheck,
  Zap,
  TrendingUp,
  Users,
  CheckCircle2,
  Sparkles,
  ShoppingBag,
  ChevronRight,
  X,
  Camera,
} from 'lucide-react';
import { deviceModels, brands } from '@/lib/casmikData';

interface SearchResult {
  id: string;
  type: 'model' | 'brand';
  name: string;
  brandName?: string;
  image?: string;
  slug?: string;
}

const popularSearches = [
  { label: 'iPhone 15', query: 'iphone-15-pro', cat: 'cat-smartphone' },
  { label: 'Samsung S24', query: 'samsung-s24-ultra', cat: 'cat-smartphone' },
  { label: 'OnePlus 12', query: 'oneplus-12', cat: 'cat-smartphone' },
  { label: 'MacBook Air', query: 'macbook-air-m2', cat: 'cat-laptop' },
  { label: 'iPad Pro', query: 'ipad-pro-m2', cat: 'cat-tablet' },
  { label: 'Canon R6', query: 'canon-eos-rp', cat: 'cat-dslr' },
];

export default function ModernHeroSection() {
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<SearchResult[]>([]);
  const [showResults, setShowResults] = useState(false);
  const searchRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (searchRef.current && !searchRef.current.contains(e.target as Node)) {
        setShowResults(false);
      }
    };
    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, []);

  const handleSearch = (q: string) => {
    setSearchQuery(q);
    if (!q || q.trim().length < 1) {
      setSearchResults([]);
      setShowResults(false);
      return;
    }
    const lower = q.toLowerCase();
    const results: SearchResult[] = [];

    // Search brands
    brands
      .filter((b) => b.name.toLowerCase().includes(lower))
      .slice(0, 3)
      .forEach((b) => {
        results.push({
          id: `b-${b.id}`,
          type: 'brand',
          name: b.name,
          image: b.logo,
          slug: b.slug,
        });
      });

    // Search device models
    deviceModels
      .filter((m) => m.name.toLowerCase().includes(lower))
      .slice(0, 5)
      .forEach((m) => {
        const brand = brands.find((b) => b.id === m.brandId);
        results.push({
          id: `m-${m.id}`,
          type: 'model',
          name: m.name,
          brandName: brand?.name,
          image: m.image,
          slug: m.slug,
        });
      });

    setSearchResults(results);
    setShowResults(true);
  };

  return (
    <section className="relative overflow-hidden bg-gradient-to-b from-blue-50/40 via-white to-slate-50/60 pt-6 sm:pt-10 lg:pt-14 pb-12 sm:pb-16 lg:pb-20 border-b border-slate-100">
      {/* Background Decorative Tech Dots */}
      <div className="absolute inset-0 bg-[radial-gradient(#3b82f6_0.75px,transparent_0.75px)] [background-size:24px_24px] opacity-[0.18] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12 items-center">
          
          {/* ── LEFT COLUMN: HERO CONTENT & SEARCH ── */}
          <div className="lg:col-span-7 flex flex-col items-start text-left">
            {/* Trust Pill Badge */}
            <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-blue-50/90 border border-blue-200/80 text-blue-700 text-xs sm:text-sm font-bold tracking-wide mb-5 sm:mb-6 shadow-xs">
              <ShieldCheck className="w-4 h-4 text-blue-600" />
              <span>INDIA&apos;S TRUSTED DEVICE MARKETPLACE</span>
            </div>

            {/* Main Headline */}
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black text-slate-900 tracking-tight leading-[1.08] mb-4 sm:mb-5">
              Sell Old.{' '}
              <br className="hidden sm:inline" />
              <span className="bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 bg-clip-text text-transparent">
                Upgrade Smart.
              </span>
            </h1>

            {/* Subtitle */}
            <p className="text-base sm:text-lg text-slate-600 font-medium max-w-xl mb-6 sm:mb-8 leading-relaxed">
              Get the best value for your old devices, buy certified refurbished devices and expert repair — all in one place with free doorstep pickup &amp; instant payment.
            </p>

            {/* Live Device Search Box (Reference Image 2 Style) */}
            <div ref={searchRef} className="w-full max-w-xl relative mb-4">
              <div className="flex items-center bg-white border-2 border-slate-200/90 hover:border-blue-500 focus-within:border-blue-600 rounded-full px-4 sm:px-5 py-2 sm:py-2.5 shadow-lg shadow-blue-900/5 focus-within:shadow-blue-500/10 focus-within:ring-4 focus-within:ring-blue-500/15 transition-all">
                <Search className="w-5 h-5 text-slate-400 mr-3 flex-shrink-0" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => handleSearch(e.target.value)}
                  onFocus={() => {
                    if (searchQuery.trim().length > 0) setShowResults(true);
                  }}
                  placeholder="Search device (e.g. iPhone 15, S24 Ultra, MacBook...)"
                  className="w-full text-sm sm:text-base bg-transparent text-slate-900 placeholder:text-slate-400 focus:outline-none"
                />
                {searchQuery ? (
                  <button
                    onClick={() => {
                      setSearchQuery('');
                      setSearchResults([]);
                      setShowResults(false);
                    }}
                    className="p-1.5 text-slate-400 hover:text-slate-600 rounded-full"
                  >
                    <X size={16} />
                  </button>
                ) : (
                  <Link
                    href={`/sell-device-get-quote${searchQuery ? `?search=${encodeURIComponent(searchQuery)}` : ''}`}
                    className="w-9 h-9 sm:w-10 sm:h-10 rounded-full bg-blue-600 hover:bg-blue-700 text-white flex items-center justify-center flex-shrink-0 shadow-md shadow-blue-600/30 transition-all hover:scale-105"
                  >
                    <Search className="w-4 h-4" />
                  </Link>
                )}
              </div>

              {/* Autocomplete Dropdown */}
              {showResults && (
                <div className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl border border-slate-200 shadow-2xl overflow-hidden z-50 animate-in fade-in-50 slide-in-from-top-2 duration-200">
                  {searchResults.length > 0 ? (
                    <div className="p-2 max-h-80 overflow-y-auto divide-y divide-slate-100">
                      <div className="px-3 py-1.5 text-[11px] font-bold uppercase tracking-wider text-slate-400">
                        Matching Devices
                      </div>
                      {searchResults.map((res) => (
                        <Link
                          key={res.id}
                          href={
                            res.type === 'model'
                              ? `/sell-device-get-quote?model=${res.slug}`
                              : `/sell-device-get-quote?brand=${res.slug}`
                          }
                          onClick={() => setShowResults(false)}
                          className="flex items-center gap-3.5 p-2.5 rounded-xl hover:bg-blue-50/70 transition-colors group"
                        >
                          <div className="w-11 h-11 rounded-xl bg-slate-50 p-1 flex items-center justify-center flex-shrink-0 overflow-hidden border border-slate-200">
                            {res.image ? (
                              <img
                                src={res.image}
                                alt={res.name}
                                className="w-full h-full object-contain group-hover:scale-105 transition-transform"
                                onError={(e) => {
                                  e.currentTarget.src = '/assets/images/categories/smartphone.png';
                                }}
                              />
                            ) : (
                              <Camera className="w-5 h-5 text-slate-400" />
                            )}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-sm font-bold text-slate-900 group-hover:text-blue-600 truncate">
                              {res.name}
                            </p>
                            <p className="text-xs text-slate-500">
                              {res.type === 'model' ? `${res.brandName || ''} · Get Instant Quote` : 'Brand Category'}
                            </p>
                          </div>
                          <ChevronRight className="w-4 h-4 text-slate-400 group-hover:text-blue-600 transition-colors" />
                        </Link>
                      ))}
                    </div>
                  ) : (
                    <div className="p-6 text-center text-sm text-slate-500">
                      No devices found matching &ldquo;{searchQuery}&rdquo;.
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Popular Search Pills */}
            <div className="flex flex-wrap items-center gap-1.5 sm:gap-2 mb-7 sm:mb-8 text-xs text-slate-500">
              <span className="font-semibold text-slate-400 mr-1">Popular searches:</span>
              {popularSearches.map((s) => (
                <Link
                  key={s.label}
                  href={`/sell-device-get-quote?model=${s.query}&cat=${s.cat}`}
                  className="px-2.5 sm:px-3 py-1 rounded-full bg-slate-100/90 hover:bg-blue-50 hover:text-blue-700 text-slate-600 font-semibold border border-slate-200/80 transition-colors"
                >
                  {s.label}
                </Link>
              ))}
            </div>

            {/* Hero Action Buttons (Reference Image 2 Style) */}
            <div className="flex flex-wrap items-center gap-3 sm:gap-4 mb-6 sm:mb-7">
              <Link
                href="/sell-device-get-quote"
                className="inline-flex items-center gap-2.5 px-6 sm:px-8 py-3.5 rounded-full bg-blue-600 hover:bg-blue-700 text-white font-black text-sm sm:text-base shadow-lg shadow-blue-600/30 hover:shadow-blue-600/40 hover:-translate-y-0.5 transition-all duration-200"
              >
                <Sparkles className="w-4 h-4 sm:w-5 sm:h-5" />
                <span>Get Device Value</span>
                <ChevronRight className="w-4 h-4" />
              </Link>

              <Link
                href="/buy-refurbished"
                className="inline-flex items-center gap-2 px-6 sm:px-8 py-3.5 rounded-full bg-white hover:bg-slate-50 text-slate-800 font-bold text-sm sm:text-base border-2 border-slate-200 hover:border-slate-300 shadow-sm transition-all duration-200 hover:-translate-y-0.5"
              >
                <ShoppingBag className="w-4 h-4 sm:w-5 sm:h-5 text-blue-600" />
                <span>Buy Refurbished</span>
                <ChevronRight className="w-4 h-4 text-slate-400" />
              </Link>
            </div>

            {/* Bottom Trust Indicators */}
            <div className="flex flex-wrap items-center gap-4 sm:gap-6 text-xs sm:text-sm font-semibold text-slate-600">
              <div className="flex items-center gap-1.5">
                <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                <span>Free Pickup</span>
              </div>
              <div className="flex items-center gap-1.5">
                <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                <span>Instant Payment</span>
              </div>
              <div className="flex items-center gap-1.5">
                <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                <span>Secure &amp; Hassle-free</span>
              </div>
            </div>
          </div>

          {/* ── RIGHT COLUMN: 3D DEVICE SHOWCASE & FLOATING BADGES ── */}
          <div className="lg:col-span-5 relative flex items-center justify-center mt-6 lg:mt-0">
            {/* Glowing Tech Podium Ring */}
            <div className="relative w-full max-w-[420px] aspect-square flex items-center justify-center">
              {/* Radial Glow */}
              <div className="absolute inset-0 bg-gradient-to-tr from-blue-400/30 via-indigo-500/20 to-purple-500/20 rounded-full blur-3xl pointer-events-none" />

              {/* 3D Circular Pedestal */}
              <div className="absolute bottom-6 w-72 sm:w-80 h-28 sm:h-32 rounded-[100%] bg-gradient-to-b from-blue-100/90 to-blue-200/40 border-2 border-blue-400/40 shadow-2xl shadow-blue-500/20 transform rotate-[-2deg]" />
              <div className="absolute bottom-8 w-60 sm:w-68 h-20 rounded-[100%] bg-gradient-to-b from-white to-blue-50/70 border border-blue-200/50" />

              {/* Floating Devices Composition */}
              <div className="relative z-10 w-full h-full flex items-center justify-center">
                {/* Main Hero Phone: iPhone 15 Pro Purple / Natural Titanium */}
                <div className="relative z-20 w-52 sm:w-60 hover:scale-105 transition-transform duration-500 filter drop-shadow-[0_25px_35px_rgba(37,99,235,0.25)]">
                  <img
                    src="/assets/images/refurbished/iphone-15-pro.png"
                    alt="Latest iPhone 15 Pro Showcase"
                    className="w-full h-auto object-contain"
                    onError={(e) => {
                      e.currentTarget.src = '/assets/images/categories/smartphone.png';
                    }}
                  />
                </div>

                {/* Angled Laptop: MacBook Pro */}
                <div className="absolute -right-4 sm:-right-6 bottom-10 z-10 w-48 sm:w-56 opacity-90 hover:opacity-100 transition-opacity filter drop-shadow-xl">
                  <img
                    src="/assets/images/refurbished/macbook-air-m2.png"
                    alt="MacBook Air M2 Showcase"
                    className="w-full h-auto object-contain"
                    onError={(e) => {
                      e.currentTarget.src = '/assets/images/categories/laptop.png';
                    }}
                  />
                </div>

                {/* Smartwatch Accent */}
                <div className="absolute -left-2 sm:-left-4 bottom-8 z-30 w-28 sm:w-32 rounded-2xl p-1.5 bg-white/90 backdrop-blur-md border border-slate-200/80 shadow-xl hover:scale-105 transition-transform">
                  <img
                    src="/assets/images/refurbished/apple-watch-ultra.jpg"
                    alt="Apple Watch Ultra"
                    className="w-full h-auto rounded-xl object-contain"
                    onError={(e) => {
                      e.currentTarget.src = '/assets/images/categories/action.png';
                    }}
                  />
                </div>
              </div>

              {/* ── FLOATING GLASSMORPHISM MICRO-CARDS (Reference Image 2) ── */}
              
              {/* Badge 1: Best Price (Top Right) */}
              <div className="absolute top-2 -right-2 sm:right-2 z-30 bg-white/95 backdrop-blur-md rounded-2xl p-3 sm:p-3.5 shadow-xl border border-slate-100/90 flex items-center gap-3 animate-in fade-in zoom-in-95 duration-500 max-w-[210px]">
                <div className="w-9 h-9 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center shrink-0 border border-emerald-200">
                  <TrendingUp size={18} />
                </div>
                <div>
                  <h4 className="text-xs font-black text-slate-900 leading-tight">Best Price</h4>
                  <p className="text-[10px] text-slate-500 font-semibold leading-tight mt-0.5">
                    Guaranteed better value
                  </p>
                </div>
              </div>

              {/* Badge 2: Instant Payment (Left Middle) */}
              <div className="absolute top-28 -left-3 sm:-left-6 z-30 bg-white/95 backdrop-blur-md rounded-2xl p-3 sm:p-3.5 shadow-xl border border-slate-100/90 flex items-center gap-3 animate-in fade-in zoom-in-95 duration-500 max-w-[220px]">
                <div className="w-9 h-9 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center shrink-0 border border-amber-200">
                  <Zap size={18} className="fill-amber-500" />
                </div>
                <div>
                  <h4 className="text-xs font-black text-slate-900 leading-tight">Instant Payment</h4>
                  <p className="text-[10px] text-slate-500 font-semibold leading-tight mt-0.5">
                    Get paid instantly in your account
                  </p>
                </div>
              </div>

              {/* Badge 3: Trusted by Thousands (Bottom Right) */}
              <div className="absolute -bottom-2 right-2 sm:right-4 z-30 bg-white/95 backdrop-blur-md rounded-2xl p-3 sm:p-3.5 shadow-xl border border-slate-100/90 flex items-center gap-3 animate-in fade-in zoom-in-95 duration-500 max-w-[220px]">
                <div className="w-9 h-9 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center shrink-0 border border-blue-200">
                  <Users size={18} />
                </div>
                <div>
                  <h4 className="text-xs font-black text-slate-900 leading-tight">Trusted by Thousands</h4>
                  <p className="text-[10px] text-slate-500 font-semibold leading-tight mt-0.5">
                    50,000+ happy customers
                  </p>
                </div>
              </div>

            </div>
          </div>

        </div>
      </div>
    </section>
  );
}
