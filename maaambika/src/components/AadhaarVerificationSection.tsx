'use client';
import React, { useState, useEffect, useRef } from 'react';
import {
  Shield, CheckCircle2, Clock, AlertTriangle, Lock, ChevronRight,
  Upload, X, Loader2, FileText, Eye, Camera, Info, UserCheck
} from 'lucide-react';
import type { AadhaarVerificationSession } from '@/lib/aadhaarVerification/store';

interface AadhaarVerificationSectionProps {
  userType: 'partner' | 'delivery';
  onVerified?: () => void;
}

type Step = 'status' | 'consent' | 'upload' | 'pending';

const CONSENT_TEXT =
  'I hereby voluntarily consent to the collection, processing, and secure storage of my Aadhaar number and associated documents for the purpose of identity verification by Maa Ambika Services. I understand this data will be processed in compliance with applicable Indian laws including DPDP Act 2023 and the Aadhaar Act 2016. I confirm I am the lawful holder of the Aadhaar number being submitted.';

export default function AadhaarVerificationSection({ userType, onVerified }: AadhaarVerificationSectionProps) {
  const [session, setSession] = useState<AadhaarVerificationSession | null>(null);
  const [step, setStep] = useState<Step>('status');
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [consentChecked, setConsentChecked] = useState(false);

  // Upload state
  const [frontFile, setFrontFile] = useState<File | null>(null);
  const [backFile, setBackFile] = useState<File | null>(null);
  const [selfieFile, setSelfieFile] = useState<File | null>(null);
  const [uploadProgress, setUploadProgress] = useState(0);

  const frontRef = useRef<HTMLInputElement>(null);
  const backRef = useRef<HTMLInputElement>(null);
  const selfieRef = useRef<HTMLInputElement>(null);

  // Read userId from localStorage (casmik_partner_session or casmik_delivery_session)
  const getUserId = (): string => {
    if (typeof window === 'undefined') return 'anonymous';
    try {
      const sessionKey = userType === 'delivery' ? 'casmik_delivery_session' : 'casmik_partner_session';
      const raw = localStorage.getItem(sessionKey);
      if (raw) {
        const parsed = JSON.parse(raw);
        return parsed?.id || parsed?.userId || parsed?.partnerId || 'anonymous';
      }
      // Fallback: check generic user session
      const userSession = localStorage.getItem('casmik_user_session');
      if (userSession) {
        const parsed = JSON.parse(userSession);
        return parsed?.id || parsed?.phone || 'anonymous';
      }
    } catch {}
    return 'anonymous';
  };

  useEffect(() => {
    loadSession();
  }, []);

  const loadSession = async () => {
    setLoading(true);
    setError(null);
    try {
      const userId = getUserId();
      const res = await fetch(`/api/identity-verification/session?userType=${userType}&userId=${encodeURIComponent(userId)}`);
      const data = await res.json();
      if (data.success && data.session) {
        setSession(data.session);
        // Route to correct step based on status
        const status = data.session.status;
        if (status === 'verified') {
          setStep('status');
          onVerified?.();
        } else if (status === 'pending_consent') {
          setStep('consent');
        } else if (status === 'consent_given') {
          setStep('upload');
        } else if (status === 'document_uploaded' || status === 'under_review') {
          setStep('pending');
        }
      } else {
        setStep('consent'); // No session yet — start with consent
      }
    } catch {
      setError('Failed to load verification status.');
    } finally {
      setLoading(false);
    }
  };

  const startSession = async () => {
    setSubmitting(true);
    setError(null);
    try {
      const userId = getUserId();
      const res = await fetch('/api/identity-verification/session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ userType, userId }),
      });
      const data = await res.json();
      if (data.success) {
        setSession(data.session);
        setStep('consent');
      } else {
        setError(data.message || 'Failed to start verification session.');
      }
    } catch {
      setError('Network error. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  const submitConsent = async () => {
    if (!session) { await startSession(); return; }
    if (!consentChecked) {
      setError('You must agree to the consent terms to proceed.');
      return;
    }
    setSubmitting(true);
    setError(null);
    try {
      const userId = getUserId();
      const res = await fetch('/api/identity-verification/consent', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ sessionId: session.sessionId, userId, explicitConsent: true }),
      });
      const data = await res.json();
      if (data.success) {
        setSession(prev => prev ? { ...prev, status: 'consent_given' } : prev);
        setStep('upload');
      } else {
        setError(data.message || 'Failed to record consent.');
      }
    } catch {
      setError('Network error. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  const submitDocuments = async () => {
    if (!session || !frontFile) {
      setError('Aadhaar front image is required.');
      return;
    }
    setSubmitting(true);
    setError(null);
    setUploadProgress(10);
    try {
      const formData = new FormData();
      formData.append('sessionId', session.sessionId);
      formData.append('userId', getUserId());
      formData.append('front', frontFile);
      if (backFile) formData.append('back', backFile);
      if (selfieFile) formData.append('selfie', selfieFile);

      setUploadProgress(40);
      const res = await fetch('/api/identity-verification/document', {
        method: 'POST',
        body: formData,
      });
      setUploadProgress(80);
      const data = await res.json();
      if (data.success) {
        setUploadProgress(100);
        setSession(prev => prev ? { ...prev, status: 'document_uploaded' } : prev);
        setStep('pending');
      } else {
        setError(data.message || 'Upload failed. Please try again.');
        setUploadProgress(0);
      }
    } catch {
      setError('Upload failed. Please check your connection.');
      setUploadProgress(0);
    } finally {
      setSubmitting(false);
    }
  };

  const handleFileChange = (slot: 'front' | 'back' | 'selfie', file: File | null) => {
    setError(null);
    if (slot === 'front') setFrontFile(file);
    if (slot === 'back') setBackFile(file);
    if (slot === 'selfie') setSelfieFile(file);
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-10 gap-3 text-sm text-gray-500">
        <Loader2 size={18} className="animate-spin" />
        Checking identity verification status…
      </div>
    );
  }

  // ── VERIFIED ────────────────────────────────────────────────────────────────
  if (session?.status === 'verified') {
    return (
      <div className="rounded-2xl bg-emerald-50 border border-emerald-200 p-4 space-y-2">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-emerald-600 flex items-center justify-center shadow-md shadow-emerald-600/30">
            <UserCheck size={20} className="text-white" />
          </div>
          <div>
            <p className="font-black text-emerald-800 text-sm">✅ Identity Verified</p>
            <p className="text-xs text-emerald-700">
              {session.verifiedName && <span>{session.verifiedName} · </span>}
              Aadhaar {session.maskedAadhaarNumber}
            </p>
          </div>
        </div>
        <p className="text-xs text-emerald-600 bg-emerald-100 rounded-xl px-3 py-2">
          Your identity is confirmed. Payment disbursement is now enabled.
        </p>
      </div>
    );
  }

  // ── UNDER REVIEW / PENDING ──────────────────────────────────────────────────
  if (step === 'pending' || session?.status === 'document_uploaded' || session?.status === 'under_review') {
    return (
      <div className="rounded-2xl bg-amber-50 border border-amber-200 p-4 space-y-2">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-amber-500 flex items-center justify-center">
            <Clock size={18} className="text-white" />
          </div>
          <div>
            <p className="font-black text-amber-800 text-sm">🕐 Identity Under Review</p>
            <p className="text-xs text-amber-700">Your Aadhaar documents have been submitted and are being reviewed.</p>
          </div>
        </div>
        <div className="bg-white rounded-xl p-3 text-xs text-gray-600 space-y-1.5 border border-amber-100">
          <p className="flex items-center gap-1.5"><CheckCircle2 size={12} className="text-emerald-500" /> Documents uploaded successfully</p>
          <p className="flex items-center gap-1.5"><Clock size={12} className="text-amber-500" /> Admin review in progress (typically 2–4 hours)</p>
          <p className="flex items-center gap-1.5"><Lock size={12} className="text-blue-500" /> Your data is encrypted and secure</p>
        </div>
        <p className="text-[11px] text-amber-600 text-center">
          Payments will be enabled once your identity is verified by our team.
        </p>
      </div>
    );
  }

  // ── REJECTED ─────────────────────────────────────────────────────────────────
  if (session?.status === 'rejected') {
    return (
      <div className="rounded-2xl bg-red-50 border border-red-200 p-4 space-y-3">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-red-600 flex items-center justify-center">
            <AlertTriangle size={18} className="text-white" />
          </div>
          <div>
            <p className="font-black text-red-800 text-sm">Verification Rejected</p>
            <p className="text-xs text-red-700">
              {session.reviewNotes || 'Documents were not accepted. Please resubmit with clearer images.'}
            </p>
          </div>
        </div>
        <button
          onClick={() => { setStep('consent'); setConsentChecked(false); }}
          className="w-full py-3 bg-red-600 text-white rounded-xl font-bold text-sm hover:bg-red-700 transition-colors"
        >
          Resubmit Documents
        </button>
      </div>
    );
  }

  // ── CONSENT STEP ─────────────────────────────────────────────────────────────
  if (step === 'consent') {
    return (
      <div className="rounded-2xl border-2 border-dashed border-slate-300 bg-slate-50 p-5 space-y-4">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-slate-900 flex items-center justify-center">
            <Shield size={20} className="text-emerald-400" />
          </div>
          <div>
            <p className="font-black text-slate-900 text-sm">🔐 Aadhaar Identity Verification Required</p>
            <p className="text-xs text-slate-500">Complete this once to unlock payment disbursement.</p>
          </div>
        </div>

        <div className="space-y-2 text-xs">
          {[
            'Aadhaar front & back photo',
            'Optional: Live selfie for liveness check',
            'Secure review by Maa Ambika team (2–4 hours)',
          ].map(item => (
            <div key={item} className="flex items-center gap-2 text-slate-600">
              <ChevronRight size={12} className="text-emerald-500 flex-shrink-0" />
              <span>{item}</span>
            </div>
          ))}
        </div>

        <div className="bg-blue-50 border border-blue-100 rounded-xl p-3 text-xs text-blue-800">
          <p className="font-bold flex items-center gap-1.5 mb-1"><Info size={12} /> Consent Required</p>
          <p className="leading-relaxed">{CONSENT_TEXT}</p>
        </div>

        <label className="flex items-start gap-2.5 cursor-pointer">
          <input
            type="checkbox"
            checked={consentChecked}
            onChange={e => { setConsentChecked(e.target.checked); setError(null); }}
            className="w-4 h-4 mt-0.5 flex-shrink-0 accent-emerald-600"
          />
          <span className="text-xs text-gray-700 leading-relaxed">
            I have read and <strong>voluntarily agree</strong> to the above consent for Aadhaar identity verification.
          </span>
        </label>

        {error && (
          <div className="flex items-center gap-2 p-3 bg-red-50 border border-red-100 rounded-xl text-xs text-red-700">
            <AlertTriangle size={13} className="flex-shrink-0" />
            {error}
          </div>
        )}

        <button
          onClick={submitConsent}
          disabled={!consentChecked || submitting}
          className="w-full py-3 bg-slate-900 hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed text-white rounded-xl font-bold text-sm flex items-center justify-center gap-2 transition-all"
        >
          {submitting ? <Loader2 size={15} className="animate-spin" /> : <Shield size={15} className="text-emerald-400" />}
          {submitting ? 'Processing…' : 'Agree & Continue to Upload'}
        </button>
      </div>
    );
  }

  // ── UPLOAD STEP ──────────────────────────────────────────────────────────────
  return (
    <div className="rounded-2xl bg-white border border-slate-200 p-5 space-y-4 shadow-sm">
      <div className="flex items-center gap-3">
        <div className="w-9 h-9 rounded-xl bg-blue-100 flex items-center justify-center">
          <Upload size={16} className="text-blue-700" />
        </div>
        <div>
          <p className="font-black text-slate-900 text-sm">Upload Aadhaar Documents</p>
          <p className="text-xs text-slate-500">JPEG, PNG, WebP, or PDF · max 5MB each</p>
        </div>
      </div>

      {/* Front */}
      <FileUploadSlot
        label="Aadhaar Front (Required)"
        icon={<FileText size={18} className="text-gray-400" />}
        file={frontFile}
        onSelect={file => handleFileChange('front', file)}
        inputRef={frontRef}
        required
      />

      {/* Back */}
      <FileUploadSlot
        label="Aadhaar Back (Optional)"
        icon={<FileText size={18} className="text-gray-400" />}
        file={backFile}
        onSelect={file => handleFileChange('back', file)}
        inputRef={backRef}
      />

      {/* Selfie */}
      <FileUploadSlot
        label="Live Selfie (Optional — for liveness)"
        icon={<Camera size={18} className="text-gray-400" />}
        file={selfieFile}
        onSelect={file => handleFileChange('selfie', file)}
        inputRef={selfieRef}
      />

      <div className="bg-amber-50 border border-amber-100 rounded-xl p-3 text-xs text-amber-800">
        <p className="font-bold flex items-center gap-1 mb-0.5"><Lock size={11} /> Your documents are protected</p>
        <p>Documents are uploaded over HTTPS, stored encrypted, and never accessible publicly. Only authorized Maa Ambika admins can review them.</p>
      </div>

      {/* Progress bar */}
      {uploadProgress > 0 && uploadProgress < 100 && (
        <div className="space-y-1">
          <div className="flex justify-between text-xs text-gray-500">
            <span>Uploading…</span>
            <span>{uploadProgress}%</span>
          </div>
          <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
            <div
              className="h-full bg-emerald-500 rounded-full transition-all duration-300"
              style={{ width: `${uploadProgress}%` }}
            />
          </div>
        </div>
      )}

      {error && (
        <div className="flex items-start gap-2 p-3 bg-red-50 border border-red-100 rounded-xl text-xs text-red-700">
          <AlertTriangle size={13} className="flex-shrink-0 mt-0.5" />
          {error}
        </div>
      )}

      <button
        onClick={submitDocuments}
        disabled={!frontFile || submitting}
        className="w-full py-3.5 bg-slate-900 hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed text-white rounded-2xl font-bold text-sm flex items-center justify-center gap-2 shadow-md transition-all"
      >
        {submitting ? (
          <><Loader2 size={15} className="animate-spin" /> Uploading Documents…</>
        ) : (
          <><Shield size={15} className="text-emerald-400" /> Submit for Verification</>
        )}
      </button>

      <p className="text-[10px] text-gray-400 text-center">
        After submission, Maa Ambika team will review your documents within 2–4 hours. Payments unlock upon successful verification.
      </p>
    </div>
  );
}

// ── File Upload Slot sub-component ──────────────────────────────────────────
interface FileUploadSlotProps {
  label: string;
  icon: React.ReactNode;
  file: File | null;
  onSelect: (file: File | null) => void;
  inputRef: React.RefObject<HTMLInputElement | null>;
  required?: boolean;
}

function FileUploadSlot({ label, icon, file, onSelect, inputRef, required }: FileUploadSlotProps) {
  return (
    <div>
      <label className="text-xs font-bold text-gray-700 mb-1.5 block">
        {label} {required && <span className="text-red-500">*</span>}
      </label>
      {file ? (
        <div className="flex items-center gap-3 p-3 bg-emerald-50 border border-emerald-200 rounded-xl text-xs">
          <CheckCircle2 size={16} className="text-emerald-600 flex-shrink-0" />
          <div className="flex-1 min-w-0">
            <p className="font-bold text-gray-900 truncate">{file.name}</p>
            <p className="text-gray-500">{(file.size / 1024).toFixed(0)} KB</p>
          </div>
          <button
            onClick={() => onSelect(null)}
            className="p-1 rounded-lg hover:bg-emerald-100 text-gray-500 hover:text-gray-700 transition-colors"
          >
            <X size={14} />
          </button>
        </div>
      ) : (
        <button
          type="button"
          onClick={() => inputRef.current?.click()}
          className="w-full flex items-center gap-3 p-3.5 border-2 border-dashed border-gray-200 hover:border-primary/40 hover:bg-gray-50 rounded-xl text-xs text-gray-500 transition-all"
        >
          {icon}
          <span>Click to choose file</span>
          <ChevronRight size={12} className="ml-auto" />
        </button>
      )}
      <input
        ref={inputRef as React.RefObject<HTMLInputElement>}
        type="file"
        accept="image/jpeg,image/png,image/webp,application/pdf"
        className="hidden"
        onChange={e => onSelect(e.target.files?.[0] ?? null)}
      />
    </div>
  );
}
