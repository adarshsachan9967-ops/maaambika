import React from 'react';
import Link from 'next/link';
import { Shield, Truck, MapPin, Navigation, Camera, Lock, ArrowLeft, Phone, Mail, AlertTriangle, CheckCircle2 } from 'lucide-react';

export const metadata = {
  title: 'Delivery Fleet Privacy Policy | Maa Ambika Fleet Portal',
  description: 'Privacy Policy governing delivery riders, field inspection executives, and logistics partners operating under the Maa Ambika Fleet network.',
};

export default function DeliveryPrivacyPolicyPage() {
  const lastUpdated = 'October 9, 2026';

  return (
    <div className="min-h-screen bg-slate-50 text-slate-900 font-sans">
      {/* Top Bar */}
      <header className="bg-white border-b border-slate-200 sticky top-0 z-40">
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <Link href="/delivery" className="flex items-center gap-3 group">
            <div className="w-9 h-9 rounded-xl bg-amber-500/15 border border-amber-500/30 p-1 flex items-center justify-center">
              <img src="/assets/images/app_logo.png" alt="Maa Ambika" className="w-full h-full object-contain" />
            </div>
            <div>
              <span className="font-black text-slate-900 text-sm tracking-tight">Maa Ambika</span>
              <span className="ml-1.5 px-1.5 py-0.5 rounded text-[10px] font-black uppercase tracking-wider bg-amber-100 text-amber-800">Fleet</span>
            </div>
          </Link>
          <div className="flex items-center gap-3">
            <Link
              href="/delivery"
              className="inline-flex items-center gap-1.5 text-xs font-bold px-3 py-1.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 transition-colors"
            >
              <ArrowLeft size={14} /> Back to Fleet Portal
            </Link>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        {/* Hero Card */}
        <div className="bg-gradient-to-br from-slate-900 via-amber-950 to-slate-950 text-white rounded-3xl p-8 sm:p-12 mb-8 shadow-xl relative overflow-hidden">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-lg bg-amber-500/20 text-amber-300 text-xs font-bold uppercase tracking-wider mb-4 border border-amber-500/30">
            <Truck size={14} /> Fleet Executive &amp; Rider Privacy Charter
          </div>
          <h1 className="text-3xl sm:text-4xl font-black tracking-tight leading-tight">
            Delivery Fleet Privacy Policy
          </h1>
          <p className="mt-3 text-slate-300 text-sm sm:text-base leading-relaxed">
            This policy transparently explains what data is collected from field executives, delivery riders, and doorstep verification technicians, with particular focus on real-time GPS location tracking, device camera access, background services, and payout processing.
          </p>
          <div className="mt-6 pt-4 border-t border-white/10 flex items-center gap-4 text-xs text-slate-400">
            <span>Effective Date: {lastUpdated}</span>
            <span>·</span>
            <span>Version: 2.1 (Google Play Location Policy &amp; DPDP Compliant)</span>
          </div>
        </div>

        {/* Content Box */}
        <div className="bg-white rounded-3xl border border-slate-200 shadow-xs p-8 sm:p-12 space-y-8 text-slate-700 text-sm leading-relaxed">
          {/* Section 1 - Location Disclosure (Google Play Mandated) */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-amber-500 text-white flex items-center justify-center text-xs font-black">1</span>
              Location Data Collection &amp; Use (Foreground &amp; Background)
            </h2>
            <div className="p-4 rounded-2xl bg-amber-50/80 border border-amber-200 text-xs text-amber-950 space-y-2">
              <p className="font-bold flex items-center gap-1.5 text-amber-900">
                <Navigation size={15} /> Prominent Disclosure: Real-Time Location Access
              </p>
              <p>
                The Maa Ambika Delivery Application collects real-time location data (including in the background when the app is closed or minimized) strictly while your duty status is set to <strong>&quot;Active Online&quot;</strong>.
              </p>
              <ul className="list-disc pl-4 space-y-1">
                <li><strong>Purpose:</strong> To assign nearby pickup and delivery tasks, display live transit location to the waiting customer, calculate shortest delivery routes, and accurately calculate per-kilometer fuel reimbursement incentives.</li>
                <li><strong>Duty Control:</strong> Location collection automatically ceases immediately when you toggle your duty switch to <strong>&quot;Offline&quot;</strong> or sign out of your session.</li>
                <li><strong>No Advertising:</strong> Location telemetry is never shared with third-party advertising networks.</li>
              </ul>
            </div>
          </section>

          {/* Section 2 - Information Collected */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-amber-500 text-white flex items-center justify-center text-xs font-black">2</span>
              Executive Information We Collect
            </h2>
            <ul className="list-disc pl-5 space-y-1.5 text-xs text-slate-600">
              <li><strong>Identity &amp; Background Verification:</strong> Full name, verified mobile number, emergency contact, Driving License number, Vehicle Registration (RC), PAN card, and masked Aadhaar KYC.</li>
              <li><strong>Device &amp; App Permissions:</strong> Camera access (to capture device physical condition proofs, IMEI barcode scans, and customer handover receipts), File/Storage access (to save verification reports), and Phone State (for VoIP customer coordination).</li>
              <li><strong>Payout Records:</strong> Bank account number, IFSC code, and UPI ID to disburse daily run incentives and per-order pickup fees.</li>
              <li><strong>Performance Telemetry:</strong> On-time arrival rate, customer feedback score, and verified order completion rate.</li>
            </ul>
          </section>

          {/* Section 3 - Doorstep Customer Privacy Rules */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-amber-500 text-white flex items-center justify-center text-xs font-black">3</span>
              Customer Privacy Protocol at Doorstep
            </h2>
            <p>
              As a Maa Ambika delivery executive, you represent our highest standard of trust. During customer device evaluations:
            </p>
            <ul className="list-disc pl-5 space-y-1 text-xs text-slate-600">
              <li>You may only inspect hardware components as guided by the diagnostic test checklist.</li>
              <li>Under no circumstances are you permitted to browse or copy customer gallery photos, WhatsApp chats, files, or login credentials.</li>
              <li>You must witness and verify that the customer device is factory reset and cloud accounts (Apple ID / Google Account) are removed before handover.</li>
              <li>Customer contact numbers and addresses displayed for delivery navigation must not be retained, noted down, or contacted outside of active order delivery windows.</li>
            </ul>
          </section>

          {/* Section 4 - Data Security & Storage */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-amber-500 text-white flex items-center justify-center text-xs font-black">4</span>
              Security &amp; Battery Optimization
            </h2>
            <p>
              Location beacons and task logs are transmitted via encrypted HTTPS TLS 1.3 channels. Our application utilizes adaptive GPS geofencing algorithms designed to conserve rider battery life while maintaining reliable navigation accuracy.
            </p>
          </section>

          {/* Section 5 - Retention & Rider Account Management */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-amber-500 text-white flex items-center justify-center text-xs font-black">5</span>
              Account Closure &amp; Data Deletion
            </h2>
            <p>
              Riders may request account deactivation at any time through the Fleet Manager. Historical payout ledgers and completed order delivery logs are archived for 7 years to comply with statutory audit standards, while live location history older than 30 days is purged automatically.
            </p>
          </section>

          {/* Contact */}
          <div className="pt-6 border-t border-slate-100 bg-slate-50 p-6 rounded-2xl text-xs space-y-2">
            <h3 className="font-bold text-slate-900 text-sm">Fleet Operations &amp; Grievance Contact</h3>
            <p className="text-slate-600 flex items-center gap-2"><Mail size={14} className="text-amber-600" /> fleet@maaambika.in / support@maaambika.in</p>
            <p className="text-slate-600 flex items-center gap-2"><Phone size={14} className="text-amber-600" /> Rider Helpline: +91 8260120467 (24/7)</p>
            <p className="text-slate-600 flex items-center gap-2"><MapPin size={14} className="text-amber-600" /> Logistics Hub, Main Market, Mumbai, Maharashtra 400001</p>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-slate-200 py-6 text-center text-xs text-slate-500">
        <p>© 2026 Maa Ambika Fleet Logistics. All rights reserved. GSTIN: 21ELDPS6270L1ZS</p>
      </footer>
    </div>
  );
}
