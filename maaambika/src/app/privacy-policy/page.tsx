import React from 'react';
import Link from 'next/link';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import { Shield, Lock, Eye, FileText, CheckCircle2, Phone, Mail, MapPin, ArrowLeft, ExternalLink } from 'lucide-react';

export const metadata = {
  title: 'Privacy Policy | Maa Ambika Mobile Shop',
  description: 'Learn how Maa Ambika protects your personal data, ensures certified military-grade device data wipe, and maintains privacy standards across our recommerce ecosystem.',
};

export default function GlobalPrivacyPolicyPage() {
  const lastUpdated = 'October 9, 2026';

  return (
    <div className="min-h-screen bg-slate-50 text-slate-900 font-sans flex flex-col">
      <CustomerHeader />

      <main className="flex-1 max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10 w-full">
        {/* Breadcrumb & Back */}
        <div className="mb-6 flex items-center justify-between">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-sm font-semibold text-slate-600 hover:text-amber-600 transition-colors"
          >
            <ArrowLeft size={16} /> Back to Home
          </Link>
          <span className="text-xs font-semibold px-3 py-1 bg-amber-50 text-amber-700 rounded-full border border-amber-200">
            Last Updated: {lastUpdated}
          </span>
        </div>

        {/* Hero Header */}
        <div className="bg-gradient-to-br from-slate-900 via-slate-800 to-amber-950 text-white rounded-3xl p-8 sm:p-12 mb-10 shadow-xl relative overflow-hidden">
          <div className="absolute -right-10 -bottom-10 w-72 h-72 bg-amber-500/10 rounded-full blur-3xl pointer-events-none" />
          <div className="relative z-10 max-w-3xl">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-lg bg-amber-500/20 text-amber-300 text-xs font-bold uppercase tracking-wider mb-4 border border-amber-500/30">
              <Shield size={14} /> Official Privacy Charter
            </div>
            <h1 className="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight leading-tight">
              Privacy Policy &amp; Data Safeguards
            </h1>
            <p className="mt-4 text-slate-300 text-sm sm:text-base leading-relaxed">
              At Maa Ambika (M.A.M SHOP), your privacy is our supreme commitment. Whether you are selling a used device, purchasing a certified refurbished smartphone, or booking a repair, this charter outlines how we collect, store, sanitize, and protect your information under the Digital Personal Data Protection (DPDP) Act, 2023.
            </p>

            {/* Quick Links to Panel Policies */}
            <div className="mt-6 pt-6 border-t border-white/10 flex flex-wrap gap-3">
              <span className="text-xs text-slate-400 font-medium py-1">Role-Specific Policies:</span>
              <Link
                href="/partner/privacy-policy"
                className="text-xs font-bold px-3 py-1 rounded-lg bg-white/10 hover:bg-white/20 text-white transition-colors flex items-center gap-1.5"
              >
                Partner Store Policy <ExternalLink size={12} />
              </Link>
              <Link
                href="/delivery/privacy-policy"
                className="text-xs font-bold px-3 py-1 rounded-lg bg-white/10 hover:bg-white/20 text-white transition-colors flex items-center gap-1.5"
              >
                Delivery Fleet Policy <ExternalLink size={12} />
              </Link>
              <Link
                href="/admin/privacy-policy"
                className="text-xs font-bold px-3 py-1 rounded-lg bg-white/10 hover:bg-white/20 text-white transition-colors flex items-center gap-1.5"
              >
                Admin Governance Policy <ExternalLink size={12} />
              </Link>
            </div>
          </div>
        </div>

        {/* Core Pillars */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
          <div className="bg-white p-6 rounded-2xl border border-slate-200/80 shadow-xs">
            <div className="w-10 h-10 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center mb-4">
              <Lock size={20} />
            </div>
            <h3 className="text-base font-bold text-slate-900 mb-1">Zero Data Retention on Devices</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Every device traded in undergoes strict DoD 5220.22-M military-grade data erasure before refurbishment or resale.
            </p>
          </div>
          <div className="bg-white p-6 rounded-2xl border border-slate-200/80 shadow-xs">
            <div className="w-10 h-10 rounded-xl bg-emerald-100 text-emerald-700 flex items-center justify-center mb-4">
              <Shield size={20} />
            </div>
            <h3 className="text-base font-bold text-slate-900 mb-1">256-bit Encryption</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              Customer identity records, bank accounts, UPI IDs, and order logs are encrypted in transit and at rest.
            </p>
          </div>
          <div className="bg-white p-6 rounded-2xl border border-slate-200/80 shadow-xs">
            <div className="w-10 h-10 rounded-xl bg-blue-100 text-blue-700 flex items-center justify-center mb-4">
              <Eye size={20} />
            </div>
            <h3 className="text-base font-bold text-slate-900 mb-1">No Third-Party Data Selling</h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              We never sell, rent, or trade your phone numbers, browsing habits, or transaction histories to advertisers.
            </p>
          </div>
        </div>

        {/* Policy Content Sections */}
        <div className="bg-white rounded-3xl border border-slate-200/80 shadow-xs p-8 sm:p-12 space-y-10 text-slate-700 leading-relaxed text-sm">
          {/* Section 1 */}
          <section className="space-y-3">
            <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2.5">
              <span className="w-7 h-7 rounded-lg bg-amber-500 text-white flex items-center justify-center text-xs font-black">1</span>
              Information We Collect
            </h2>
            <p>
              When you interact with our website, mobile applications, or doorstep pickup services, we collect only the information necessary to fulfill our recommerce and repair transactions:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-xs text-slate-600">
              <li><strong>Contact Details:</strong> Full Name, mobile phone number, email address, and doorstep pickup address.</li>
              <li><strong>Device Telemetry:</strong> Brand, model name, storage capacity, physical condition grade, and IMEI/Serial Number (to verify non-blacklist status via CEIR/GSMA).</li>
              <li><strong>Financial Information:</strong> Bank account number and IFSC code or UPI Virtual Payment Address (VPA) solely to execute spot payment upon device pickup.</li>
              <li><strong>Statutory Verification:</strong> Govt ID proof (Aadhaar/PAN/Voter ID) as mandated by Indian law for electronic second-hand goods trade-ins.</li>
            </ul>
          </section>

          {/* Section 2 */}
          <section className="space-y-3">
            <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2.5">
              <span className="w-7 h-7 rounded-lg bg-amber-500 text-white flex items-center justify-center text-xs font-black">2</span>
              Certified Device Data Wipe (Military-Grade Sanitization)
            </h2>
            <p>
              We guarantee that no personal data (photos, contacts, emails, logged-in accounts, browser history, or application tokens) remains on any traded device.
            </p>
            <div className="p-4 rounded-xl bg-amber-50/70 border border-amber-200 text-xs text-amber-950 space-y-1">
              <p className="font-bold">Our 3-Step Sanitization Guarantee:</p>
              <p>1. Hardware Factory Data Reset performed in the presence of customer whenever feasible.</p>
              <p>2. Cryptographic internal storage overwrite conforming to NIST SP 800-88 &amp; DoD sanitization standards.</p>
              <p>3. Digital Certificate of Erasure generated upon successful verification.</p>
            </div>
          </section>

          {/* Section 3 */}
          <section className="space-y-3">
            <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2.5">
              <span className="w-7 h-7 rounded-lg bg-amber-500 text-white flex items-center justify-center text-xs font-black">3</span>
              How We Use Your Information
            </h2>
            <p>Your data is used strictly for legitimate business operations:</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
              <div className="p-3 rounded-xl bg-slate-50 border border-slate-200">
                <p className="font-bold text-slate-900">Order Fulfillment</p>
                <p className="text-slate-600 mt-0.5">Scheduling doorstep pickups, dispatching delivery riders, and processing instant payouts.</p>
              </div>
              <div className="p-3 rounded-xl bg-slate-50 border border-slate-200">
                <p className="font-bold text-slate-900">Legal &amp; Police Compliance</p>
                <p className="text-slate-600 mt-0.5">Maintaining trade-in register records as mandated by Indian electronics resell regulations.</p>
              </div>
              <div className="p-3 rounded-xl bg-slate-50 border border-slate-200">
                <p className="font-bold text-slate-900">Warranty Management</p>
                <p className="text-slate-600 mt-0.5">Honoring 6-month to 1-year refurbished warranties and repair guarantee terms.</p>
              </div>
              <div className="p-3 rounded-xl bg-slate-50 border border-slate-200">
                <p className="font-bold text-slate-900">Transaction Notifications</p>
                <p className="text-slate-600 mt-0.5">Sending SMS, WhatsApp, and email alerts regarding order statuses and payment receipts.</p>
              </div>
            </div>
          </section>

          {/* Section 4 */}
          <section className="space-y-3">
            <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2.5">
              <span className="w-7 h-7 rounded-lg bg-amber-500 text-white flex items-center justify-center text-xs font-black">4</span>
              Data Protection &amp; Security Standards
            </h2>
            <p>
              We implement industry-leading technical and organizational security controls:
            </p>
            <ul className="list-disc pl-5 space-y-1.5 text-xs text-slate-600">
              <li>TLS 1.3 encryption across all website and mobile application API requests.</li>
              <li>Aadhaar numbers are masked where required by UIDAI guidelines.</li>
              <li>Database records are secured within encrypted MongoDB Atlas &amp; Supabase clusters with Role-Based Access Control (RBAC).</li>
              <li>Employees and partners sign binding Non-Disclosure Agreements (NDAs).</li>
            </ul>
          </section>

          {/* Section 5 */}
          <section className="space-y-3">
            <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2.5">
              <span className="w-7 h-7 rounded-lg bg-amber-500 text-white flex items-center justify-center text-xs font-black">5</span>
              Your Rights Under DPDP Act 2023
            </h2>
            <p>
              As a data principal, you have the right to request access to the personal data we hold about you, request corrections, or request deletion of account records (subject to mandatory statutory tax and trade-in retention laws).
            </p>
            <p className="text-xs text-slate-500">
              To exercise any of these rights, email us at <a href="mailto:support@maaambika.in" className="text-amber-600 underline font-bold">support@maaambika.in</a> with subject line &quot;Data Privacy Request&quot;.
            </p>
          </section>

          {/* Section 6 - Grievance Officer */}
          <section className="pt-6 border-t border-slate-100">
            <h2 className="text-lg font-bold text-slate-900 mb-3">Grievance Officer &amp; Nodal Contact</h2>
            <div className="bg-slate-50 p-6 rounded-2xl border border-slate-200 text-xs space-y-2">
              <p className="font-bold text-slate-900 text-sm">Maa Ambika Mobile Shop (M.A.M SHOP)</p>
              <p className="text-slate-600 flex items-center gap-2"><MapPin size={14} className="text-amber-600" /> Plot No. 14, Main Market, Mumbai, Maharashtra 400001, India</p>
              <p className="text-slate-600 flex items-center gap-2"><Phone size={14} className="text-amber-600" /> +91 8260120467 (Mon-Sat, 10:00 AM - 7:00 PM IST)</p>
              <p className="text-slate-600 flex items-center gap-2"><Mail size={14} className="text-amber-600" /> grievance@maaambika.in / support@maaambika.in</p>
              <p className="text-slate-500 pt-2 border-t border-slate-200">GSTIN: 21ELDPS6270L1ZS · Registered Entity in Maharashtra, India</p>
            </div>
          </section>
        </div>
      </main>

      <CustomerFooter />
    </div>
  );
}
