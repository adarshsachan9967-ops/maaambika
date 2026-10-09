import React from 'react';
import Link from 'next/link';
import { ShieldCheck, Store, Lock, FileText, ArrowLeft, Building2, CheckCircle2, Phone, Mail, MapPin, AlertCircle } from 'lucide-react';

export const metadata = {
  title: 'Partner Privacy Policy | Maa Ambika Partner Portal',
  description: 'Privacy Policy and Data Protection Terms governing merchant stores, franchise partners, and trade-in inspection partners on Maa Ambika.',
};

export default function PartnerPrivacyPolicyPage() {
  const lastUpdated = 'October 9, 2026';

  return (
    <div className="min-h-screen bg-slate-50 text-slate-900 font-sans">
      {/* Top Bar */}
      <header className="bg-white border-b border-slate-200 sticky top-0 z-40">
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <Link href="/partner" className="flex items-center gap-3 group">
            <div className="w-9 h-9 rounded-xl bg-amber-500/15 border border-amber-500/30 p-1 flex items-center justify-center">
              <img src="/assets/images/app_logo.png" alt="Maa Ambika" className="w-full h-full object-contain" />
            </div>
            <div>
              <span className="font-black text-slate-900 text-sm tracking-tight">Maa Ambika</span>
              <span className="ml-1.5 px-1.5 py-0.5 rounded text-[10px] font-black uppercase tracking-wider bg-amber-100 text-amber-800">Partner</span>
            </div>
          </Link>
          <div className="flex items-center gap-3">
            <Link
              href="/partner"
              className="inline-flex items-center gap-1.5 text-xs font-bold px-3 py-1.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 transition-colors"
            >
              <ArrowLeft size={14} /> Back to Partner Portal
            </Link>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        {/* Hero Card */}
        <div className="bg-gradient-to-br from-amber-950 via-slate-900 to-slate-950 text-white rounded-3xl p-8 sm:p-12 mb-8 shadow-xl relative overflow-hidden">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-lg bg-amber-500/20 text-amber-300 text-xs font-bold uppercase tracking-wider mb-4 border border-amber-500/30">
            <Store size={14} /> Partner Merchant Agreement &amp; Privacy Charter
          </div>
          <h1 className="text-3xl sm:text-4xl font-black tracking-tight leading-tight">
            Partner Privacy Policy
          </h1>
          <p className="mt-3 text-slate-300 text-sm sm:text-base leading-relaxed">
            This Privacy Policy governs the collection, processing, and safeguarding of commercial and personal data for registered retail store partners, franchisee centers, and offline inspection technicians participating in the Maa Ambika Recommerce Network.
          </p>
          <div className="mt-6 pt-4 border-t border-white/10 flex items-center gap-4 text-xs text-slate-400">
            <span>Effective Date: {lastUpdated}</span>
            <span>·</span>
            <span>Version: 2.1 (DPDP Act 2023 Compliant)</span>
          </div>
        </div>

        {/* Content Box */}
        <div className="bg-white rounded-3xl border border-slate-200 shadow-xs p-8 sm:p-12 space-y-8 text-slate-700 text-sm leading-relaxed">
          {/* Section 1 */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-amber-500 text-white flex items-center justify-center text-xs font-black">1</span>
              Partner Information Collected
            </h2>
            <p>
              To onboard your store, assign customer trade-in leads, process commission payouts, and fulfill statutory tax compliance, Maa Ambika collects:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-xs text-slate-600">
              <li><strong>Business KYC:</strong> Trade name, Registered Business Entity Name, Shop Act License / Udyam Certificate, GSTIN, and Business PAN.</li>
              <li><strong>Authorized Signatory Data:</strong> Name, mobile number, official email, Aadhaar KYC (masked), and store photographic proofs.</li>
              <li><strong>Financial &amp; Settlement Details:</strong> Bank account number, IFSC code, cancelled cheque images, and UPI VPA used for instant wallet deductions and commission settlements.</li>
              <li><strong>Store Operational Data:</strong> Geo-coordinates of store location, working hours, inspection capacity, and hardware diagnostic equipment available.</li>
            </ul>
          </section>

          {/* Section 2 */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-amber-500 text-white flex items-center justify-center text-xs font-black">2</span>
              Customer Data Handling Responsibilities
            </h2>
            <div className="p-4 rounded-2xl bg-amber-50/80 border border-amber-200 text-xs text-amber-950 space-y-2">
              <p className="font-bold flex items-center gap-1.5 text-amber-900">
                <AlertCircle size={15} /> Strict Fiduciary Obligations for Partner Stores:
              </p>
              <p>
                When a customer visits your store for device trade-in or repair, you act as a Data Processor on behalf of Maa Ambika. You explicitly agree:
              </p>
              <ul className="list-disc pl-4 space-y-1">
                <li>Never to copy, export, access, browse, or store customer personal files (photos, videos, messages, contacts, apps) from inspected devices.</li>
                <li>To perform complete hardware data wipe in front of the customer using certified factory reset protocols prior to device acceptance.</li>
                <li>Never to use customer phone numbers or addresses for external sales calls or non-Maa Ambika solicitations.</li>
              </ul>
            </div>
          </section>

          {/* Section 3 */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-amber-500 text-white flex items-center justify-center text-xs font-black">3</span>
              Purpose of Data Utilization
            </h2>
            <p>Your partner store data is strictly utilized for:</p>
            <ul className="list-disc pl-5 space-y-1 text-xs text-slate-600">
              <li>Geo-routing nearby customer trade-in and repair bookings to your store.</li>
              <li>Real-time automated wallet balance calculations, commission crediting, and spot payout transfers via IMPS/NEFT/UPI.</li>
              <li>Fraud prevention, device blacklist verification via IMEI, and anti-theft database reporting.</li>
              <li>Statutory reporting under the Goods and Services Tax (GST) Act and Income Tax Act, 1961.</li>
            </ul>
          </section>

          {/* Section 4 */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-amber-500 text-white flex items-center justify-center text-xs font-black">4</span>
              Data Security &amp; Access Controls
            </h2>
            <p>
              All partner ledger records, commission receipts, and inspection reports are stored in secure, encrypted cloud environments with role-based access restrictions. Session tokens are invalidated upon inactivity, and two-factor authentication is enforced for financial payout modifications.
            </p>
          </section>

          {/* Section 5 */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-amber-500 text-white flex items-center justify-center text-xs font-black">5</span>
              Termination &amp; Data Retention
            </h2>
            <p>
              Upon termination of your merchant agreement with Maa Ambika, commercial transaction ledgers and device trade-in registers will be retained for 7 years as required by Indian commercial tax laws. Live store access tokens, active geo-listings, and marketing credentials will be deactivated immediately.
            </p>
          </section>

          {/* Contact & Support */}
          <div className="pt-6 border-t border-slate-100 bg-slate-50 p-6 rounded-2xl text-xs space-y-2">
            <h3 className="font-bold text-slate-900 text-sm">Partner Grievance &amp; Onboarding Helpdesk</h3>
            <p className="text-slate-600 flex items-center gap-2"><Mail size={14} className="text-amber-600" /> partners@maaambika.in / support@maaambika.in</p>
            <p className="text-slate-600 flex items-center gap-2"><Phone size={14} className="text-amber-600" /> Partner Desk: +91 8260120467</p>
            <p className="text-slate-600 flex items-center gap-2"><MapPin size={14} className="text-amber-600" /> Maa Ambika Partner Relations, Main Market, Mumbai, Maharashtra 400001</p>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-slate-200 py-6 text-center text-xs text-slate-500">
        <p>© 2026 Maa Ambika Partner Portal. All rights reserved. GSTIN: 21ELDPS6270L1ZS</p>
      </footer>
    </div>
  );
}
