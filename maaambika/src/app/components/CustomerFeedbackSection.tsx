'use client';
import React from 'react';
import { Star, MessageSquareQuote, CheckCircle2 } from 'lucide-react';

const reviews = [
  {
    initial: 'N',
    name: 'Nitin Gowda',
    city: 'BANGALORE',
    bg: 'bg-amber-600',
    stars: 5,
    text: 'Flawless experience. Instant credit. No haggling whatsoever — exactly what I expected.',
    device: 'Sold iPhone 14 Pro Max',
  },
  {
    initial: 'P',
    name: 'Pawan Mishra',
    city: 'PUNE',
    bg: 'bg-emerald-600',
    stars: 5,
    text: 'Excellent services! The pickup was too good and the security and checking purposes were professional.',
    device: 'Sold Galaxy S23 Ultra',
  },
  {
    initial: 'R',
    name: 'Ritu Sharma',
    city: 'JAIPUR',
    bg: 'bg-rose-600',
    stars: 5,
    text: 'Super easy process. Got a great price for my old Samsung. Will definitely use again!',
    device: 'Sold Galaxy Z Flip 4',
  },
  {
    initial: 'V',
    name: 'Vidyankit Official',
    city: 'HYDERABAD',
    bg: 'bg-pink-600',
    stars: 5,
    text: 'Sold my Realme GT Neo 2. Very smooth process, no negotiation unlike other platforms. Highly recommend!',
    device: 'Sold Realme GT Neo',
  },
  {
    initial: 'M',
    name: 'Mayank Doshi',
    city: 'AHMEDABAD',
    bg: 'bg-indigo-600',
    stars: 5,
    text: 'Very prompt service and got a very good price. Absolutely hassle-free. Highly recommended!',
    device: 'Sold OnePlus 11 5G',
  },
  {
    initial: 'A',
    name: 'Aakash Mehta',
    city: 'CHENNAI',
    bg: 'bg-red-600',
    stars: 5,
    text: 'Loved the transparent pricing. No last minute deductions. Payment received in under 10 minutes.',
    device: 'Sold MacBook Pro M1',
  },
  {
    initial: 'S',
    name: 'Sneha Kulkarni',
    city: 'MUMBAI',
    bg: 'bg-teal-600',
    stars: 5,
    text: 'Bought a certified refurbished MacBook Air. Condition looks brand new with 6-month warranty and genuine bill.',
    device: 'Bought MacBook Air M2',
  },
  {
    initial: 'K',
    name: 'Karan Malhotra',
    city: 'DELHI NCR',
    bg: 'bg-purple-600',
    stars: 5,
    text: 'Doorstep technician arrived on time, scanned my QR pass, tested the phone and disbursed cash right in front of me!',
    device: 'Sold iPhone 13 128GB',
  },
];

export default function CustomerFeedbackSection() {
  return (
    <section className="py-14 sm:py-20 bg-slate-50/60 border-t border-slate-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Section Header (Reference Image 4) */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-12 sm:mb-16">
          <div className="max-w-2xl">
            <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-blue-50 border border-blue-200 text-blue-700 text-xs font-black tracking-wider uppercase mb-3">
              <MessageSquareQuote size={13} className="text-blue-600" />
              <span>CUSTOMER REVIEWS</span>
            </div>

            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-slate-900 tracking-tight">
              Real Feedback From Our <span className="text-blue-600">Customers</span>
            </h2>

            <p className="text-sm sm:text-base text-slate-500 font-medium mt-3">
              Thousands of users across India trust Maa Ambika Mobile Shop to convert their old devices into instant cash with free pickup.
            </p>
          </div>

          {/* Overall Rating Badge (Reference Image 4) */}
          <div className="bg-white rounded-2xl p-4 sm:p-5 border border-slate-200/90 shadow-sm flex items-center gap-3 shrink-0">
            <div className="flex items-center gap-1 text-amber-500">
              <Star size={24} className="fill-amber-400 text-amber-400" />
              <span className="text-2xl font-black text-slate-900">4.9</span>
              <span className="text-sm font-bold text-slate-400">/5</span>
            </div>
            <div className="border-l border-slate-200 pl-3">
              <p className="text-xs font-black text-slate-900">Verified Ratings</p>
              <p className="text-[11px] font-semibold text-slate-500">Based on 25,000+ reviews</p>
            </div>
          </div>
        </div>

        {/* ── REVIEWS GRID (Reference Image 4) ── */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 sm:gap-5">
          {reviews.map((r) => (
            <div
              key={r.name}
              className="bg-white rounded-2xl p-5 border border-slate-200/90 shadow-xs hover:shadow-lg hover:border-blue-400/50 transition-all duration-300 flex flex-col justify-between group hover:-translate-y-0.5"
            >
              <div>
                {/* Author row */}
                <div className="flex items-center gap-3 mb-3">
                  <div className={`w-10 h-10 rounded-full ${r.bg} text-white font-black text-sm flex items-center justify-center shadow-xs shrink-0`}>
                    {r.initial}
                  </div>
                  <div className="min-w-0">
                    <h4 className="text-sm font-black text-slate-900 truncate">{r.name}</h4>
                    <p className="text-[10px] font-bold text-slate-400 tracking-wider uppercase">{r.city}</p>
                  </div>
                </div>

                {/* 5 Gold Stars */}
                <div className="flex items-center gap-0.5 mb-3 text-amber-400">
                  {Array.from({ length: r.stars }).map((_, i) => (
                    <Star key={i} size={14} className="fill-amber-400 text-amber-400" />
                  ))}
                </div>

                {/* Review Text */}
                <p className="text-xs text-slate-600 font-medium leading-relaxed mb-4">
                  &ldquo;{r.text}&rdquo;
                </p>
              </div>

              {/* Verified Badge & Device */}
              <div className="pt-3 border-t border-slate-100 flex items-center justify-between text-[10px] font-bold text-slate-500">
                <span className="truncate text-slate-700">{r.device}</span>
                <span className="flex items-center gap-1 text-emerald-600 shrink-0">
                  <CheckCircle2 size={12} /> Verified
                </span>
              </div>
            </div>
          ))}
        </div>

      </div>
    </section>
  );
}
