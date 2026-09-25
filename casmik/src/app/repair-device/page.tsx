'use client';
import React, { useState } from 'react';
import Link from 'next/link';
import {
  Wrench,
  ShieldCheck,
  Clock,
  CheckCircle2,
  Smartphone,
  Laptop,
  Camera,
  ChevronRight,
  Zap,
  Phone,
  Calendar,
  AlertCircle,
  Sparkles,
  MapPin,
  ArrowRight,
  Star,
} from 'lucide-react';
import CustomerHeader from '@/components/CustomerHeader';
import CustomerFooter from '@/components/CustomerFooter';
import FloatingWhatsAppCTA from '@/components/FloatingWhatsAppCTA';

const REPAIR_ISSUES = [
  {
    id: 'screen',
    title: 'Cracked / Broken Display',
    subtitle: 'Original OLED/Super AMOLED replacement',
    icon: '📱',
    estPrice: '₹1,999 - ₹8,499',
    duration: '45 mins',
    features: ['Original Color & Refresh Rate', '6 Months Screen Warranty', 'Oleophobic Coating'],
  },
  {
    id: 'battery',
    title: 'Battery Degradation / Fast Drain',
    subtitle: '100% capacity OEM replacement battery',
    icon: '🔋',
    estPrice: '₹1,299 - ₹3,499',
    duration: '30 mins',
    features: ['100% Health Guaranteed', 'Zero Overheating Cells', '3-Month Replacement Guarantee'],
  },
  {
    id: 'port',
    title: 'Charging Port & Audio Jack',
    subtitle: 'Fix loose cables, slow charging & mic',
    icon: '⚡',
    estPrice: '₹899 - ₹1,899',
    duration: '30 mins',
    features: ['Fast Charging Restored', 'Original Flex Cable', 'Dust Mesh Cleaning'],
  },
  {
    id: 'camera',
    title: 'Camera Lens & Sensor Blurriness',
    subtitle: 'Restore crystal clear focus and OIS',
    icon: '📷',
    estPrice: '₹1,499 - ₹4,999',
    duration: '60 mins',
    features: ['Sapphire Glass Cover', 'Optical Stabilization Fix', 'Dust-Free Clean Room Fit'],
  },
  {
    id: 'speaker',
    title: 'Earpiece & Loudspeaker Muffled',
    subtitle: 'Fix low calling volume and crackling',
    icon: '🔊',
    estPrice: '₹799 - ₹1,499',
    duration: '30 mins',
    features: ['Original Stereo Sound', 'Acoustic Mesh Replacement', 'On-spot Call Test'],
  },
  {
    id: 'motherboard',
    title: 'Water Damage & Dead Phone',
    subtitle: 'Chip-level ultrasonic motherboard diagnosis',
    icon: '🔬',
    estPrice: '₹2,499 - ₹9,999',
    duration: '24-48 hrs',
    features: ['Ultrasonic Chemical Clean', 'Short-Circuit Tracing', 'No Fix, No Fee Policy'],
  },
];

export default function RepairDevicePage() {
  const [selectedIssue, setSelectedIssue] = useState<string>('screen');
  const [deviceName, setDeviceName] = useState('');
  const [contactName, setContactName] = useState('');
  const [contactPhone, setContactPhone] = useState('');
  const [address, setAddress] = useState('');
  const [preferredDate, setPreferredDate] = useState('Tomorrow');
  const [preferredSlot, setPreferredSlot] = useState('11:00 AM - 1:00 PM');
  const [booked, setBooked] = useState(false);

  const activeIssueObj = REPAIR_ISSUES.find((i) => i.id === selectedIssue) || REPAIR_ISSUES[0];

  const handleBooking = (e: React.FormEvent) => {
    e.preventDefault();
    if (!deviceName || !contactPhone || !contactName) return;
    setBooked(true);
  };

  return (
    <main className="min-h-screen bg-white flex flex-col justify-between">
      <CustomerHeader />

      {/* Hero Header */}
      <section className="bg-gradient-to-b from-purple-950 via-slate-900 to-slate-950 text-white py-14 sm:py-20 relative overflow-hidden border-b border-purple-900/30">
        <div className="absolute inset-0 bg-[radial-gradient(#8b5cf6_0.5px,transparent_0.5px)] [background-size:24px_24px] opacity-20 pointer-events-none" />

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <nav className="flex items-center gap-2 text-xs font-semibold text-purple-200/70 mb-5">
            <Link href="/" className="hover:text-white transition-colors">Home</Link>
            <ChevronRight size={13} />
            <span className="text-purple-300 font-bold">Device Repair</span>
          </nav>

          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
            <div className="lg:col-span-8 space-y-4">
              <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-purple-500/20 text-purple-300 text-xs font-black border border-purple-500/30">
                <Wrench size={14} className="text-purple-400" />
                <span>EXPERT DOORSTEP REPAIR SERVICE</span>
              </div>

              <h1 className="text-3xl sm:text-5xl font-black text-white tracking-tight leading-tight">
                Doorstep Tech &amp; Smartphone Repair
              </h1>

              <p className="text-slate-300 text-sm sm:text-base leading-relaxed max-w-2xl font-medium">
                Genuine OEM parts, 6-month comprehensive warranty on replaced components, and verified technicians repairing your gadget right in front of your eyes at your home or office.
              </p>

              <div className="flex flex-wrap gap-4 pt-2 text-xs font-bold text-slate-300">
                <span className="flex items-center gap-1.5"><CheckCircle2 size={16} className="text-purple-400" /> Screen &amp; Battery Repair</span>
                <span className="flex items-center gap-1.5"><CheckCircle2 size={16} className="text-purple-400" /> 100% Original Parts</span>
                <span className="flex items-center gap-1.5"><CheckCircle2 size={16} className="text-purple-400" /> 6-Month Warranty</span>
                <span className="flex items-center gap-1.5"><CheckCircle2 size={16} className="text-purple-400" /> Done in 45 Minutes</span>
              </div>
            </div>

            <div className="lg:col-span-4 flex justify-center">
              <div className="bg-white/10 backdrop-blur-md rounded-3xl p-6 border border-white/20 text-center max-w-sm w-full shadow-2xl">
                <div className="w-16 h-16 rounded-2xl bg-purple-500/30 text-purple-300 flex items-center justify-center mx-auto mb-3 border border-purple-400/40">
                  <ShieldCheck size={32} />
                </div>
                <h3 className="text-lg font-black text-white">Zero Risk Guarantee</h3>
                <p className="text-xs text-purple-200 mt-1 leading-relaxed">
                  No advance payment. Inspect your repaired phone and pay only after complete satisfaction.
                </p>
                <div className="mt-4 pt-3 border-t border-white/10 flex items-center justify-center gap-2 text-amber-300 text-xs font-black">
                  <Star size={14} className="fill-amber-400" /> 4.9/5 Rating (25,000+ Repairs)
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Main Repair Workflow Section */}
      <section className="py-12 sm:py-16 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 w-full">
        {booked ? (
          <div className="max-w-xl mx-auto bg-white rounded-3xl p-8 border border-emerald-200 shadow-2xl text-center animate-in zoom-in-95 duration-300">
            <div className="w-16 h-16 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center mx-auto mb-4 border border-emerald-200">
              <CheckCircle2 size={36} />
            </div>
            <h2 className="text-2xl font-black text-slate-900 mb-2">Repair Scheduled Successfully!</h2>
            <p className="text-xs sm:text-sm text-slate-500 mb-6 leading-relaxed">
              Our technician has been assigned for your <strong>{deviceName}</strong> ({activeIssueObj.title}). They will arrive on <strong>{preferredDate} ({preferredSlot})</strong> at your doorstep.
            </p>
            <div className="p-4 bg-slate-50 rounded-2xl border border-slate-200 text-left text-xs space-y-1.5 mb-6">
              <p><strong>Customer Name:</strong> {contactName}</p>
              <p><strong>Phone:</strong> {contactPhone}</p>
              <p><strong>Address:</strong> {address}</p>
              <p><strong>Estimated Quote:</strong> {activeIssueObj.estPrice}</p>
            </div>
            <div className="flex gap-3 justify-center">
              <button
                onClick={() => setBooked(false)}
                className="px-6 py-3 rounded-xl bg-purple-600 hover:bg-purple-700 text-white font-bold text-xs shadow-md"
              >
                Book Another Repair
              </button>
              <Link
                href="/"
                className="px-6 py-3 rounded-xl border border-slate-200 hover:bg-slate-50 font-bold text-xs text-slate-700"
              >
                Back to Home
              </Link>
            </div>
          </div>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 lg:gap-12">
            
            {/* Left: Step 1 - Issue Selector (8 cols) */}
            <div className="lg:col-span-7 space-y-6">
              <div>
                <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-purple-50 border border-purple-200 text-purple-700 text-xs font-black mb-2">
                  <span>STEP 1 OF 2</span>
                </div>
                <h2 className="text-2xl font-black text-slate-900 tracking-tight">
                  Select Your Device Malfunction
                </h2>
                <p className="text-xs sm:text-sm text-slate-500 font-medium">
                  Select the primary problem to view guaranteed transparent pricing and estimated repair time.
                </p>
              </div>

              {/* Grid of Issues */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                {REPAIR_ISSUES.map((issue) => {
                  const active = selectedIssue === issue.id;
                  return (
                    <button
                      key={issue.id}
                      type="button"
                      onClick={() => setSelectedIssue(issue.id)}
                      className={`p-5 rounded-2xl border text-left transition-all duration-200 flex flex-col justify-between group cursor-pointer ${
                        active
                          ? 'bg-purple-50/90 border-purple-500 shadow-lg shadow-purple-500/10 ring-2 ring-purple-500/20'
                          : 'bg-white border-slate-200/90 hover:border-slate-300 hover:bg-slate-50/50'
                      }`}
                    >
                      <div>
                        <div className="flex items-center justify-between mb-3">
                          <span className="text-2xl p-2 rounded-xl bg-white shadow-2xs border border-slate-100">{issue.icon}</span>
                          <span className="text-[10px] font-black px-2 py-0.5 rounded-full bg-slate-100 text-slate-600">
                            ⏱ {issue.duration}
                          </span>
                        </div>
                        <h3 className="text-sm font-black text-slate-900 group-hover:text-purple-700 transition-colors">
                          {issue.title}
                        </h3>
                        <p className="text-[11px] text-slate-500 mt-1 leading-snug">
                          {issue.subtitle}
                        </p>
                      </div>

                      <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between">
                        <span className="text-xs font-black text-purple-700">{issue.estPrice}</span>
                        <span className={`text-[11px] font-bold ${active ? 'text-purple-700' : 'text-slate-400'}`}>
                          {active ? '✓ Selected' : 'Select'}
                        </span>
                      </div>
                    </button>
                  );
                })}
              </div>

              {/* Feature Highlights of Selected Issue */}
              <div className="p-5 rounded-2xl bg-slate-50 border border-slate-200/80">
                <h4 className="text-xs font-black uppercase tracking-wider text-slate-700 mb-2">
                  What is included in {activeIssueObj.title}:
                </h4>
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 text-xs font-semibold text-slate-600">
                  {activeIssueObj.features.map((f) => (
                    <div key={f} className="flex items-center gap-1.5">
                      <CheckCircle2 size={14} className="text-emerald-500 shrink-0" />
                      <span>{f}</span>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Right: Step 2 - Doorstep Booking Form (5 cols) */}
            <div className="lg:col-span-5">
              <div className="sticky top-28 bg-white rounded-3xl p-6 sm:p-7 border border-slate-200/90 shadow-xl">
                <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-blue-50 border border-blue-200 text-blue-700 text-xs font-black mb-3">
                  <span>STEP 2 OF 2</span>
                </div>
                <h3 className="text-lg font-black text-slate-900 mb-1">
                  Book Doorstep Technician
                </h3>
                <p className="text-xs text-slate-500 mb-5">
                  A certified executive will arrive at your location with genuine replacement parts.
                </p>

                <form onSubmit={handleBooking} className="space-y-4">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">
                      Device Model *
                    </label>
                    <input
                      type="text"
                      required
                      placeholder="e.g. iPhone 15 Pro, Galaxy S23, OnePlus 11"
                      value={deviceName}
                      onChange={(e) => setDeviceName(e.target.value)}
                      className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs text-slate-900 focus:outline-none focus:ring-2 focus:ring-purple-500/20 focus:border-purple-600"
                    />
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">
                        Your Name *
                      </label>
                      <input
                        type="text"
                        required
                        placeholder="Full name"
                        value={contactName}
                        onChange={(e) => setContactName(e.target.value)}
                        className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs text-slate-900 focus:outline-none focus:ring-2 focus:ring-purple-500/20 focus:border-purple-600"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">
                        Mobile Number *
                      </label>
                      <input
                        type="tel"
                        required
                        placeholder="10-digit phone"
                        value={contactPhone}
                        onChange={(e) => setContactPhone(e.target.value)}
                        className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs text-slate-900 focus:outline-none focus:ring-2 focus:ring-purple-500/20 focus:border-purple-600"
                      />
                    </div>
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">
                      Doorstep Address *
                    </label>
                    <textarea
                      required
                      rows={2}
                      placeholder="Flat/House no., landmark, city and pincode"
                      value={address}
                      onChange={(e) => setAddress(e.target.value)}
                      className="w-full px-3.5 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 focus:outline-none focus:ring-2 focus:ring-purple-500/20 focus:border-purple-600"
                    />
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">
                        Pickup Date
                      </label>
                      <select
                        value={preferredDate}
                        onChange={(e) => setPreferredDate(e.target.value)}
                        className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 bg-white"
                      >
                        <option value="Today">Today (Within 2 hrs)</option>
                        <option value="Tomorrow">Tomorrow</option>
                        <option value="Day After Tomorrow">Day After Tomorrow</option>
                      </select>
                    </div>

                    <div>
                      <label className="block text-xs font-bold text-slate-700 mb-1">
                        Time Slot
                      </label>
                      <select
                        value={preferredSlot}
                        onChange={(e) => setPreferredSlot(e.target.value)}
                        className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 bg-white"
                      >
                        <option value="9:00 AM - 11:00 AM">9 AM - 11 AM</option>
                        <option value="11:00 AM - 1:00 PM">11 AM - 1 PM</option>
                        <option value="1:00 PM - 3:00 PM">1 PM - 3 PM</option>
                        <option value="3:00 PM - 6:00 PM">3 PM - 6 PM</option>
                      </select>
                    </div>
                  </div>

                  <div className="p-3 bg-purple-50 rounded-2xl border border-purple-200/80 text-xs text-purple-900 flex items-center justify-between">
                    <div>
                      <span className="font-bold">Estimated Cost:</span>
                      <p className="text-sm font-black text-purple-700">{activeIssueObj.estPrice}</p>
                    </div>
                    <span className="text-[10px] font-bold bg-white px-2 py-1 rounded-lg border border-purple-200">
                      Pay Post-Repair
                    </span>
                  </div>

                  <button
                    type="submit"
                    className="w-full py-3.5 rounded-2xl bg-purple-600 hover:bg-purple-700 text-white font-black text-xs sm:text-sm shadow-lg shadow-purple-600/25 transition-all flex items-center justify-center gap-2 cursor-pointer hover:scale-[1.02]"
                  >
                    <span>Confirm Doorstep Repair Booking</span>
                    <ArrowRight size={16} />
                  </button>

                  <p className="text-[10px] text-center text-slate-400 font-medium">
                    🔒 Zero advance payment required • Free doorstep inspection
                  </p>
                </form>
              </div>
            </div>

          </div>
        )}
      </section>

      <CustomerFooter />
      <FloatingWhatsAppCTA />
    </main>
  );
}
