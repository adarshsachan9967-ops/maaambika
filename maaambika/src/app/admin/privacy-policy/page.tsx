import React from 'react';
import Link from 'next/link';
import { ShieldAlert, ShieldCheck, Lock, Database, FileCheck, ArrowLeft, Key, UserCheck, Phone, Mail, MapPin } from 'lucide-react';

export const metadata = {
  title: 'Admin Governance & Privacy Policy | Maa Ambika Admin Portal',
  description: 'Enterprise data governance, compliance safeguards, and administrative confidentiality policy governing platform operators on Maa Ambika.',
};

export default function AdminPrivacyPolicyPage() {
  const lastUpdated = 'October 9, 2026';

  return (
    <div className="min-h-screen bg-slate-50 text-slate-900 font-sans">
      {/* Top Bar */}
      <header className="bg-white border-b border-slate-200 sticky top-0 z-40">
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <Link href="/admin" className="flex items-center gap-3 group">
            <div className="w-9 h-9 rounded-xl bg-amber-500/15 border border-amber-500/30 p-1 flex items-center justify-center">
              <img src="/assets/images/app_logo.png" alt="Maa Ambika" className="w-full h-full object-contain" />
            </div>
            <div>
              <span className="font-black text-slate-900 text-sm tracking-tight">Maa Ambika</span>
              <span className="ml-1.5 px-1.5 py-0.5 rounded text-[10px] font-black uppercase tracking-wider bg-rose-100 text-rose-800">Admin</span>
            </div>
          </Link>
          <div className="flex items-center gap-3">
            <Link
              href="/admin"
              className="inline-flex items-center gap-1.5 text-xs font-bold px-3 py-1.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 transition-colors"
            >
              <ArrowLeft size={14} /> Back to Admin Console
            </Link>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        {/* Hero Card */}
        <div className="bg-gradient-to-br from-slate-950 via-slate-900 to-rose-950 text-white rounded-3xl p-8 sm:p-12 mb-8 shadow-xl relative overflow-hidden">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-lg bg-rose-500/20 text-rose-300 text-xs font-bold uppercase tracking-wider mb-4 border border-rose-500/30">
            <ShieldAlert size={14} /> Platform Data Governance &amp; Security Protocol
          </div>
          <h1 className="text-3xl sm:text-4xl font-black tracking-tight leading-tight">
            Admin Privacy &amp; Data Governance Policy
          </h1>
          <p className="mt-3 text-slate-300 text-sm sm:text-base leading-relaxed">
            This internal and platform governance charter defines the security baselines, access control policies, audit logging standards, and customer PII handling protocols binding all system administrators, managers, and operational operators across the Maa Ambika ecosystem.
          </p>
          <div className="mt-6 pt-4 border-t border-white/10 flex items-center gap-4 text-xs text-slate-400">
            <span>Last Audit: {lastUpdated}</span>
            <span>·</span>
            <span>Classification: Internal Operations &amp; Statutory Compliance</span>
          </div>
        </div>

        {/* Content Box */}
        <div className="bg-white rounded-3xl border border-slate-200 shadow-xs p-8 sm:p-12 space-y-8 text-slate-700 text-sm leading-relaxed">
          {/* Section 1 */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-rose-600 text-white flex items-center justify-center text-xs font-black">1</span>
              Administrative Access &amp; Role-Based Access Control (RBAC)
            </h2>
            <p>
              Administrative privileges to the Maa Ambika backend database, production orders, payout ledgers, and KYC document stores are strictly segregated by role:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-xs text-slate-600">
              <li><strong>Super Administrator:</strong> Full root privileges, access audit logs, API key rotation, payout batch approvals.</li>
              <li><strong>Operations Manager:</strong> Order assignment, partner dispatch, rider route coordination, support resolution. PII is masked where possible.</li>
              <li><strong>Finance Executive:</strong> Settlement approval, GST invoices, merchant commissions, bank reconciliation. No access to device inspection logs or personal photos.</li>
              <li><strong>Quality Inspection Lead:</strong> Device test reports, IMEI blacklist verification, DoD sanitization certificates.</li>
            </ul>
          </section>

          {/* Section 2 */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-rose-600 text-white flex items-center justify-center text-xs font-black">2</span>
              Customer PII &amp; KYC Safeguards
            </h2>
            <div className="p-4 rounded-2xl bg-rose-50/70 border border-rose-200 text-xs text-rose-950 space-y-2">
              <p className="font-bold flex items-center gap-1.5 text-rose-900">
                <Lock size={15} /> Strict Privacy Rules for Platform Admins:
              </p>
              <ul className="list-disc pl-4 space-y-1">
                <li>Aadhaar numbers must remain masked (first 8 digits hidden: `XXXX-XXXX-1234`) in compliance with UIDAI guidelines.</li>
                <li>Customer phone numbers and physical addresses are only accessible during active order fulfillment.</li>
                <li>Exporting customer database lists, bulk phone dumps, or transaction records to unauthorized local disks is strictly prohibited and logged.</li>
              </ul>
            </div>
          </section>

          {/* Section 3 */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-rose-600 text-white flex items-center justify-center text-xs font-black">3</span>
              Audit Trails &amp; Tamper-Proof Logging
            </h2>
            <p>
              Every administrative action—including order price overrides, coupon creation, partner wallet adjustments, payout dispatches, and user role updates—is recorded with timestamp, authenticated user email, IP address, and changed payload.
            </p>
            <p className="text-xs text-slate-600">
              Audit logs are immutable, retained for a minimum of 36 months, and subject to regular quarterly security reviews.
            </p>
          </section>

          {/* Section 4 */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-rose-600 text-white flex items-center justify-center text-xs font-black">4</span>
              Database Encryption &amp; Infrastructure Security
            </h2>
            <p>
              The platform infrastructure enforces the following technical baselines:
            </p>
            <ul className="list-disc pl-5 space-y-1 text-xs text-slate-600">
              <li><strong>Encryption at Rest:</strong> MongoDB Atlas and Supabase database volumes encrypted with AES-256.</li>
              <li><strong>Encryption in Transit:</strong> Strict HTTPS/TLS 1.3 encryption across all client-to-server and inter-service communications.</li>
              <li><strong>Session Expiry:</strong> Idle admin sessions automatically timeout after 60 minutes of inactivity.</li>
              <li><strong>API Token Governance:</strong> Secrets and private keys (ImageKit, MongoDB, Supabase service roles) are stored exclusively in environment variables and never checked into source control.</li>
            </ul>
          </section>

          {/* Section 5 */}
          <section className="space-y-3">
            <h2 className="text-lg font-bold text-slate-900 flex items-center gap-2">
              <span className="w-6 h-6 rounded-md bg-rose-600 text-white flex items-center justify-center text-xs font-black">5</span>
              Statutory Law Enforcement Requests
            </h2>
            <p>
              Maa Ambika cooperates with verified Indian law enforcement agencies and cyber crime cells regarding stolen electronics (IMEI tracking, CEIR portal synchronization, and police recovery requests). Such information is released strictly upon receipt of formal section 91/102 CrPC notices or official cyber police communications.
            </p>
          </section>

          {/* Contact */}
          <div className="pt-6 border-t border-slate-100 bg-slate-50 p-6 rounded-2xl text-xs space-y-2">
            <h3 className="font-bold text-slate-900 text-sm">Security &amp; Data Protection Officer (DPO)</h3>
            <p className="text-slate-600 flex items-center gap-2"><Mail size={14} className="text-amber-600" /> dpo@maaambika.in / security@maaambika.in</p>
            <p className="text-slate-600 flex items-center gap-2"><Phone size={14} className="text-amber-600" /> Admin Helpdesk: +91 8260120467</p>
            <p className="text-slate-600 flex items-center gap-2"><MapPin size={14} className="text-amber-600" /> Central Security Cell, Maa Ambika Shop, Mumbai, Maharashtra 400001</p>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-slate-200 py-6 text-center text-xs text-slate-500">
        <p>© 2026 Maa Ambika Admin Governance. All rights reserved. GSTIN: 21ELDPS6270L1ZS</p>
      </footer>
    </div>
  );
}
