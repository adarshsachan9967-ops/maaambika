import React from 'react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import ModernHeroSection from '@/app/components/ModernHeroSection';
import ThreeServiceCards from '@/app/components/ThreeServiceCards';
import CameraCategoryBar from '@/app/components/CameraCategoryBar';
import TopDealsShowcase from '@/app/components/TopDealsShowcase';
import HowBuybackWorksSection from '@/app/components/HowBuybackWorksSection';
import CustomerFeedbackSection from '@/app/components/CustomerFeedbackSection';
import CompetitiveComparisonTable from '@/app/components/CompetitiveComparisonTable';
import CamsikFaqSection from '@/app/components/CamsikFaqSection';
import AppDownloadCTA from '@/app/components/AppDownloadCTA';
import FloatingWhatsAppCTA from '@/components/FloatingWhatsAppCTA';

import Link from 'next/link';
import { ShieldCheck, Building, Truck, User } from 'lucide-react';

export default function CustomerHomePage() {
  return (
    <main className="min-h-screen bg-white flex flex-col overflow-x-hidden w-full max-w-full">
      {/* Top Multi-Panel Navigation Banner */}
      <div className="bg-slate-950 text-white text-xs py-2 px-4 border-b border-amber-500/20">
        <div className="max-w-7xl mx-auto flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-2">
            <span className="inline-block w-2 h-2 rounded-full bg-amber-400 animate-pulse" />
            <span className="font-bold text-amber-300 tracking-wide">MAA AMBIKA MOBILE SHOP</span>
            <span className="hidden sm:inline text-slate-600">|</span>
            <span className="hidden sm:inline text-amber-100/70 font-medium">Your Digital Life Partner</span>
            <span className="hidden md:inline text-slate-600">|</span>
            <a href="tel:+918260120467" className="hidden md:inline-flex text-amber-400 font-bold hover:underline">
              Helpline: +91 8260120467
            </a>
          </div>
          <div className="flex items-center gap-3 font-semibold text-slate-300">
            <span className="text-slate-400">Panels:</span>
            <Link href="/user" className="text-emerald-400 hover:text-emerald-300 hover:underline flex items-center gap-1">
              <User size={12} /> Customer Store
            </Link>
            <Link href="/partner" className="text-blue-400 hover:text-blue-300 hover:underline flex items-center gap-1">
              <Building size={12} /> Merchant Portal
            </Link>
            <Link href="/delivery" className="text-amber-400 hover:text-amber-300 hover:underline flex items-center gap-1">
              <Truck size={12} /> Logistics Fleet
            </Link>
            <Link href="/super-admin-dashboard" className="text-yellow-400 hover:text-yellow-300 hover:underline flex items-center gap-1">
              <ShieldCheck size={12} /> Super Admin
            </Link>
          </div>
        </div>
      </div>

      {/* Main Navigation Header with Sell/Buy Dropdowns, Search, City, Account */}
      <CustomerHeader />
      
      {/* 1. Hero Section matching Reference Image 2 (Sell Old. Upgrade Smart., Search Box, 3D Podium, Floating Badges) */}
      <ModernHeroSection />

      {/* 2. Three Core Action Cards matching Reference Image 1 (Sell, Buy Refurbished, Repair with Checklists & Floating Devices) */}
      <ThreeServiceCards />

      {/* 3. Device Categories Bar (Smartphones, Laptops, Tablets, Cameras, Lenses) */}
      <CameraCategoryBar />

      {/* 4. Top Deals & Certified Marketplace Showcase */}
      <TopDealsShowcase />

      {/* 5. How Buyback Works matching Reference Image 3 (6 Steps: Quote, Schedule, Inspection, Best Offer, Wipe, Payment) */}
      <HowBuybackWorksSection />

      {/* 6. Real Customer Feedback matching Reference Image 4 (4.9/5 Rating Badge & Authentic Review Grid) */}
      <CustomerFeedbackSection />

      {/* 7. Competitive Comparison Table: Maa Ambika vs Offline Shops vs Classifieds */}
      <CompetitiveComparisonTable />

      {/* 8. Comprehensive FAQs on Selling, Warranties & Doorstep Inspection */}
      <CamsikFaqSection />

      {/* 9. Official Mobile App Download Banner */}
      <AppDownloadCTA />

      {/* Footer */}
      <CustomerFooter />

      {/* Floating WhatsApp Chat Assistant (as seen in references) */}
      <FloatingWhatsAppCTA />
    </main>
  );
}