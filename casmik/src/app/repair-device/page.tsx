'use client';
import React, { useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Camera, ArrowRight, ShieldCheck, Sparkles } from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';

export default function RepairRedirectPage() {
  const router = useRouter();

  useEffect(() => {
    const timer = setTimeout(() => {
      router.push('/user/repair');
    }, 1500);
    return () => clearTimeout(timer);
  }, [router]);

  return (
    <main className="min-h-screen bg-background flex flex-col justify-between">
      <CustomerHeader />

      <section className="flex-1 flex items-center justify-center py-10 sm:py-14 px-4">
        <div className="max-w-xl w-full bg-white rounded-3xl border border-border/80 p-8 sm:p-12 text-center shadow-xl relative overflow-hidden">
          <div className="w-20 h-20 rounded-3xl bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-amber-600 mx-auto mb-6 shadow-md">
            <img src="/assets/images/app_logo.png" alt="Maa Ambika" className="w-14 h-14 object-contain" />
          </div>

          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-500/10 text-amber-800 text-xs font-bold uppercase tracking-wider mb-3">
            <Sparkles size={13} />
            Maa Ambika Mobile Repair &amp; Service
          </div>

          <h1 className="text-2xl sm:text-3xl font-black text-foreground mb-3">
            Certified Doorstep Device Repair
          </h1>

          <p className="text-sm sm:text-base text-muted-foreground mb-8 leading-relaxed">
            Welcome to Maa Ambika Mobile Shop Repair Center. Genuine OEM screens, batteries, charging ports, camera lenses, and chip-level repairs with up to 6 months store warranty.
          </p>

          <div className="p-4 rounded-2xl bg-amber-50 border border-amber-200/60 mb-8 text-xs text-amber-800 flex items-center justify-center gap-2">
            <ShieldCheck size={16} className="text-amber-600" />
            <span>Redirecting to Maa Ambika Repair Booking Portal...</span>
          </div>

          <div className="flex flex-col sm:flex-row gap-3 justify-center">
            <Link
              href="/user/repair"
              className="px-6 py-3.5 rounded-xl bg-amber-500 hover:bg-amber-600 text-white font-bold text-sm shadow-md transition-all flex items-center justify-center gap-2"
            >
              Book Repair Now <ArrowRight size={16} />
            </Link>
            <Link
              href="/"
              className="px-6 py-3.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-foreground font-bold text-sm transition-all"
            >
              Back to Storefront
            </Link>
          </div>
        </div>
      </section>

      <CustomerFooter />
    </main>
  );
}
