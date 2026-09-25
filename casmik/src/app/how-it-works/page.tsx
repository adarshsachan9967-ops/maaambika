import React from 'react';
import Link from 'next/link';
import { ChevronRight, Sparkles, ArrowRight, ShieldCheck } from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import HowBuybackWorksSection from '@/app/components/HowBuybackWorksSection';
import CustomerFeedbackSection from '@/app/components/CustomerFeedbackSection';
import SafeAndReliableSection from '@/app/components/SafeAndReliableSection';
import CamsikTrustScore from '@/app/components/CamsikTrustScore';
import FloatingWhatsAppCTA from '@/components/FloatingWhatsAppCTA';

export const metadata = {
  title: 'How It Works — Maa Ambika Mobile Shop Device Buyback, Sales & Exchange Process',
  description: 'Learn how to sell, trade-in, or buy certified smartphones, laptops, MacBooks, tablets, and mobile devices at Maa Ambika Mobile Shop with instant online quote, free doorstep pickup, and instant bank transfer.',
};

export default function HowItWorksPage() {
  return (
    <main className="min-h-screen bg-white flex flex-col justify-between">
      <CustomerHeader />

      {/* Hero Header */}
      <section className="bg-gradient-to-b from-blue-950 via-slate-900 to-slate-950 text-white py-12 sm:py-16 border-b border-blue-900/30">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <nav className="flex items-center gap-2 text-xs font-semibold text-slate-400 mb-6">
            <Link href="/" className="hover:text-white transition-colors">
              Home
            </Link>
            <ChevronRight size={13} />
            <span className="text-blue-400 font-bold">How It Works</span>
          </nav>

          <div className="max-w-3xl space-y-3">
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-blue-500/20 text-blue-300 text-xs font-bold border border-blue-500/30">
              <Sparkles size={13} />
              <span>FAST, FAIR &amp; TRANSPARENT • MAA AMBIKA</span>
            </div>
            <h1 className="text-3xl sm:text-5xl font-black tracking-tight text-white">
              How Buyback &amp; Upgrades Work
            </h1>
            <p className="text-sm sm:text-base text-slate-300 leading-relaxed font-medium">
              Selling, exchanging, buying, or repairing phones in India used to mean haggling with local shops or dealing with unverified online buyers. Maa Ambika Mobile Shop makes it effortless, transparent, and completely risk-free with free doorstep pickup &amp; spot UPI payout.
            </p>
          </div>
        </div>
      </section>

      {/* 6-Step Interactive Buyback Workflow (Reference Image 3) */}
      <HowBuybackWorksSection />

      {/* Trust & Safe Guarantees */}
      <SafeAndReliableSection />

      {/* Live Platform Stats */}
      <CamsikTrustScore />

      {/* Real Customer Feedback (Reference Image 4) */}
      <CustomerFeedbackSection />

      {/* Bottom CTA Banner */}
      <section className="py-12 sm:py-16 bg-blue-50/60 border-t border-blue-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-2xl sm:text-3xl font-black text-slate-900 mb-3">
            Ready to Check Your Device&apos;s Resale Value?
          </h2>
          <p className="text-sm text-slate-600 max-w-xl mx-auto mb-8 font-medium">
            Get an instant valuation based on real hardware diagnostics, battery health, and market liquidity in under 60 seconds.
          </p>
          <div className="flex flex-wrap items-center justify-center gap-3">
            <Link
              href="/sell-device-get-quote"
              className="px-7 py-3.5 rounded-full bg-blue-600 hover:bg-blue-700 text-white font-black text-sm shadow-lg shadow-blue-600/25 flex items-center gap-2 transition-all hover:scale-105"
            >
              <span>Get Instant Valuation</span>
              <ArrowRight size={16} />
            </Link>
            <Link
              href="/buy-refurbished"
              className="px-7 py-3.5 rounded-full bg-white hover:bg-slate-50 border-2 border-slate-200 text-slate-800 font-bold text-sm transition-all"
            >
              <span>Explore Refurbished Store</span>
            </Link>
            <Link
              href="/repair-device"
              className="px-7 py-3.5 rounded-full bg-purple-600 hover:bg-purple-700 text-white font-bold text-sm shadow-md shadow-purple-600/25 flex items-center gap-2 transition-all hover:scale-105"
            >
              <span>Book a Repair</span>
              <ArrowRight size={16} />
            </Link>
          </div>
        </div>
      </section>

      <CustomerFooter />
      <FloatingWhatsAppCTA />
    </main>
  );
}
