'use client';
import React, { useState, useEffect, useCallback } from 'react';
import {
  Shield, UserCheck, Clock, CheckCircle2, XCircle, AlertTriangle,
  RefreshCw, Loader2, Filter, ChevronDown
} from 'lucide-react';
import type { AadhaarVerificationSession } from '@/lib/aadhaarVerification/store';

type SessionWithExtra = AadhaarVerificationSession & { _displayTime?: string };

export default function AdminIdentityVerification() {
  const [sessions, setSessions] = useState<SessionWithExtra[]>([]);
  const [loading, setLoading] = useState(true);
  const [filterType, setFilterType] = useState<'all' | 'partner' | 'delivery'>('all');
  const [reviewingId, setReviewingId] = useState<string | null>(null);
  const [reviewForm, setReviewForm] = useState({
    decision: 'verified' as 'verified' | 'rejected',
    maskedAadhaarNumber: '',
    verifiedName: '',
    reviewNotes: '',
  });
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const loadSessions = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const url = filterType === 'all'
        ? '/api/identity-verification/admin'
        : `/api/identity-verification/admin?userType=${filterType}`;
      const res = await fetch(url);
      const data = await res.json();
      if (data.success) {
        setSessions(data.sessions.map((s: SessionWithExtra) => ({
          ...s,
          _displayTime: new Date(s.updatedAt).toLocaleString('en-IN', {
            day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit',
          }),
        })));
      } else {
        setError(data.message || 'Failed to load sessions.');
      }
    } catch {
      setError('Network error loading sessions.');
    } finally {
      setLoading(false);
    }
  }, [filterType]);

  useEffect(() => {
    loadSessions();
  }, [loadSessions]);

  const handleReview = async (sessionId: string) => {
    setSubmitting(true);
    setError(null);
    setSuccess(null);
    try {
      const res = await fetch('/api/identity-verification/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ sessionId, ...reviewForm }),
      });
      const data = await res.json();
      if (data.success) {
        setSuccess(`Session ${reviewForm.decision} successfully.`);
        setReviewingId(null);
        setReviewForm({ decision: 'verified', maskedAadhaarNumber: '', verifiedName: '', reviewNotes: '' });
        loadSessions();
      } else {
        setError(data.message || 'Review failed.');
      }
    } catch {
      setError('Network error during review.');
    } finally {
      setSubmitting(false);
    }
  };

  const statusBadge = (status: AadhaarVerificationSession['status']) => {
    const map: Record<string, { color: string; label: string }> = {
      pending_consent: { color: 'bg-gray-100 text-gray-600', label: 'Pending Consent' },
      consent_given: { color: 'bg-blue-100 text-blue-700', label: 'Consent Given' },
      document_uploaded: { color: 'bg-amber-100 text-amber-700', label: '📋 Needs Review' },
      under_review: { color: 'bg-amber-100 text-amber-700', label: 'Under Review' },
      verified: { color: 'bg-emerald-100 text-emerald-700', label: '✅ Verified' },
      rejected: { color: 'bg-red-100 text-red-700', label: '❌ Rejected' },
    };
    const s = map[status] || { color: 'bg-gray-100 text-gray-600', label: status };
    return (
      <span className={`text-[11px] font-bold px-2.5 py-1 rounded-full ${s.color}`}>
        {s.label}
      </span>
    );
  };

  return (
    <div className="space-y-5">
      {/* Header */}
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-slate-900 flex items-center justify-center">
            <Shield size={20} className="text-emerald-400" />
          </div>
          <div>
            <h2 className="font-black text-slate-900 text-lg">Identity Verification Review</h2>
            <p className="text-xs text-slate-500">Partner & Delivery Aadhaar KYC submissions</p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <select
            value={filterType}
            onChange={e => setFilterType(e.target.value as any)}
            className="text-xs border border-gray-200 rounded-xl px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary/20 bg-white"
          >
            <option value="all">All Users</option>
            <option value="partner">Partners Only</option>
            <option value="delivery">Delivery Only</option>
          </select>
          <button
            onClick={loadSessions}
            className="p-2 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 transition-colors"
          >
            <RefreshCw size={15} className={loading ? 'animate-spin text-primary' : 'text-gray-500'} />
          </button>
        </div>
      </div>

      {/* Alerts */}
      {error && (
        <div className="flex items-center gap-2 p-3 bg-red-50 border border-red-100 rounded-xl text-xs text-red-700">
          <AlertTriangle size={14} className="flex-shrink-0" />
          {error}
        </div>
      )}
      {success && (
        <div className="flex items-center gap-2 p-3 bg-emerald-50 border border-emerald-100 rounded-xl text-xs text-emerald-700">
          <CheckCircle2 size={14} className="flex-shrink-0" />
          {success}
        </div>
      )}

      {/* Sessions list */}
      {loading ? (
        <div className="flex items-center justify-center py-12 gap-2 text-sm text-gray-400">
          <Loader2 size={18} className="animate-spin" />
          Loading submissions…
        </div>
      ) : sessions.length === 0 ? (
        <div className="text-center py-12 bg-gray-50 rounded-2xl border border-dashed border-gray-200">
          <UserCheck size={36} className="mx-auto text-gray-300 mb-2" />
          <p className="text-sm font-bold text-gray-500">No pending submissions</p>
          <p className="text-xs text-gray-400 mt-1">Verification submissions from partners and delivery agents will appear here.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {sessions.map(session => (
            <div key={session.sessionId} className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
              {/* Session card */}
              <div className="p-4 flex items-start justify-between gap-4 flex-wrap">
                <div className="space-y-1.5">
                  <div className="flex items-center gap-2 flex-wrap">
                    {statusBadge(session.status)}
                    <span className={`text-[11px] font-bold px-2.5 py-0.5 rounded-full ${
                      session.userType === 'partner' ? 'bg-purple-100 text-purple-700' : 'bg-teal-100 text-teal-700'
                    }`}>
                      {session.userType === 'partner' ? '👤 Partner' : '🛵 Delivery'}
                    </span>
                  </div>
                  <p className="text-sm font-bold text-gray-900">User: <span className="font-mono text-xs text-gray-600">{session.userId}</span></p>
                  <p className="text-xs text-gray-500">Session: <span className="font-mono">{session.sessionId}</span></p>
                  <p className="text-xs text-gray-400">Updated: {session._displayTime}</p>
                  {session.consent?.givenAt && (
                    <p className="text-xs text-emerald-600">✓ Consent given at {new Date(session.consent.givenAt).toLocaleString('en-IN')}</p>
                  )}
                  {session.reviewNotes && (
                    <p className="text-xs text-gray-600 italic">Notes: {session.reviewNotes}</p>
                  )}
                </div>

                {session.status === 'document_uploaded' && (
                  <button
                    onClick={() => setReviewingId(reviewingId === session.sessionId ? null : session.sessionId)}
                    className="flex items-center gap-1.5 px-4 py-2 bg-slate-900 text-white rounded-xl text-xs font-bold hover:bg-black transition-colors"
                  >
                    Review <ChevronDown size={12} className={reviewingId === session.sessionId ? 'rotate-180' : ''} />
                  </button>
                )}

                {session.status === 'verified' && (
                  <div className="text-right">
                    <p className="text-xs text-emerald-700 font-bold">✅ {session.verifiedName}</p>
                    <p className="text-xs text-gray-500 font-mono">{session.maskedAadhaarNumber}</p>
                    <p className="text-[11px] text-gray-400">By: {session.reviewedBy}</p>
                  </div>
                )}
              </div>

              {/* Review Form */}
              {reviewingId === session.sessionId && (
                <div className="border-t border-gray-100 bg-slate-50 p-4 space-y-3">
                  <div className="bg-amber-50 border border-amber-100 rounded-xl p-3 text-xs text-amber-800">
                    <p className="font-bold mb-1">⚠ Reviewer Instructions</p>
                    <ul className="space-y-0.5 list-disc pl-4">
                      <li>Access documents securely via the internal admin file viewer (never copy file paths)</li>
                      <li>Enter <strong>only masked Aadhaar</strong> (e.g. XXXX XXXX 1234) — never store full Aadhaar</li>
                      <li>Verify that the selfie/photo matches the Aadhaar document</li>
                    </ul>
                  </div>

                  <div className="grid grid-cols-2 gap-2">
                    <button
                      onClick={() => setReviewForm(f => ({ ...f, decision: 'verified' }))}
                      className={`flex items-center justify-center gap-1.5 py-2 rounded-xl border text-xs font-bold transition-all ${
                        reviewForm.decision === 'verified'
                          ? 'border-emerald-600 bg-emerald-50 text-emerald-800'
                          : 'border-gray-200 bg-white text-gray-600 hover:border-emerald-300'
                      }`}
                    >
                      <CheckCircle2 size={13} /> Approve
                    </button>
                    <button
                      onClick={() => setReviewForm(f => ({ ...f, decision: 'rejected' }))}
                      className={`flex items-center justify-center gap-1.5 py-2 rounded-xl border text-xs font-bold transition-all ${
                        reviewForm.decision === 'rejected'
                          ? 'border-red-600 bg-red-50 text-red-800'
                          : 'border-gray-200 bg-white text-gray-600 hover:border-red-300'
                      }`}
                    >
                      <XCircle size={13} /> Reject
                    </button>
                  </div>

                  {reviewForm.decision === 'verified' && (
                    <>
                      <div>
                        <label className="text-xs font-bold text-gray-700 mb-1 block">Masked Aadhaar Number <span className="text-red-500">*</span></label>
                        <input
                          type="text"
                          placeholder="XXXX XXXX 1234"
                          value={reviewForm.maskedAadhaarNumber}
                          onChange={e => setReviewForm(f => ({ ...f, maskedAadhaarNumber: e.target.value }))}
                          className="w-full px-3 py-2 text-xs border border-gray-200 rounded-xl font-mono focus:outline-none focus:ring-2 focus:ring-primary/20"
                        />
                        <p className="text-[11px] text-amber-600 mt-0.5">⚠ Enter only the last 4 digits visible. Never store full Aadhaar.</p>
                      </div>
                      <div>
                        <label className="text-xs font-bold text-gray-700 mb-1 block">Verified Name (as on Aadhaar) <span className="text-red-500">*</span></label>
                        <input
                          type="text"
                          placeholder="Full name as on Aadhaar"
                          value={reviewForm.verifiedName}
                          onChange={e => setReviewForm(f => ({ ...f, verifiedName: e.target.value }))}
                          className="w-full px-3 py-2 text-xs border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20"
                        />
                      </div>
                    </>
                  )}

                  <div>
                    <label className="text-xs font-bold text-gray-700 mb-1 block">Review Notes {reviewForm.decision === 'rejected' && <span className="text-red-500">*</span>}</label>
                    <textarea
                      placeholder={reviewForm.decision === 'rejected' ? 'Reason for rejection (shown to user)' : 'Optional notes'}
                      value={reviewForm.reviewNotes}
                      onChange={e => setReviewForm(f => ({ ...f, reviewNotes: e.target.value }))}
                      rows={2}
                      className="w-full px-3 py-2 text-xs border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 resize-none"
                    />
                  </div>

                  {error && (
                    <p className="text-xs text-red-600 bg-red-50 border border-red-100 rounded-xl p-2">{error}</p>
                  )}

                  <div className="flex gap-2">
                    <button
                      onClick={() => { setReviewingId(null); setError(null); }}
                      className="flex-1 py-2 border border-gray-200 rounded-xl text-xs font-bold text-gray-700 hover:bg-gray-50 transition-colors"
                    >
                      Cancel
                    </button>
                    <button
                      onClick={() => handleReview(session.sessionId)}
                      disabled={submitting || (reviewForm.decision === 'verified' && (!reviewForm.maskedAadhaarNumber || !reviewForm.verifiedName))}
                      className="flex-1 py-2 bg-slate-900 hover:bg-black disabled:opacity-40 disabled:cursor-not-allowed text-white rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 transition-colors"
                    >
                      {submitting ? (
                        <><Loader2 size={12} className="animate-spin" /> Processing…</>
                      ) : (
                        <>{reviewForm.decision === 'verified' ? <CheckCircle2 size={12} /> : <XCircle size={12} />} Submit Review</>
                      )}
                    </button>
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
