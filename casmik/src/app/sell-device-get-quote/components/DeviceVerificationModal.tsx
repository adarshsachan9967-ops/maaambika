'use client';
import React, { useState, useEffect, useRef } from 'react';
import {
  X, Shield, Smartphone, QrCode, Lock, CheckCircle2, AlertTriangle,
  RefreshCw, Loader2, Eye, EyeOff, Info, ChevronRight, MonitorSmartphone
} from 'lucide-react';
import type { DeviceVerificationReport } from '@/lib/deviceVerification/types';

type VerifyMode = 'choose' | 'qr' | 'manual';

interface DeviceVerificationModalProps {
  selectedBrand?: string;
  selectedModel?: string;
  selectedVariant?: string;
  onSuccess: (report: DeviceVerificationReport) => void;
  onClose: () => void;
}

export default function DeviceVerificationModal({
  selectedBrand,
  selectedModel,
  selectedVariant,
  onSuccess,
  onClose,
}: DeviceVerificationModalProps) {
  const [mode, setMode] = useState<VerifyMode>('choose');
  const [imei, setImei] = useState('');
  const [imei2, setImei2] = useState('');
  const [showImei, setShowImei] = useState(false);
  const [isVerifying, setIsVerifying] = useState(false);
  const [verifyError, setVerifyError] = useState<string | null>(null);
  const [qrDataUrl, setQrDataUrl] = useState<string | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [qrLoading, setQrLoading] = useState(false);
  const [pollingActive, setPollingActive] = useState(false);
  const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);

  // Start QR session
  const startQRSession = async () => {
    setQrLoading(true);
    setVerifyError(null);
    try {
      const res = await fetch('/api/device-verification/session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          selectedDevice: {
            brand: selectedBrand || '',
            model: selectedModel || '',
            variant: selectedVariant || '',
          },
        }),
      });
      const data = await res.json();
      if (data.success) {
        setQrDataUrl(data.qrCodeDataUrl);
        setSessionId(data.session.sessionId);
        startPolling(data.session.sessionId);
      } else {
        setVerifyError('Failed to generate verification QR. Please use manual IMEI entry.');
      }
    } catch {
      setVerifyError('Network error. Please use manual IMEI entry.');
    } finally {
      setQrLoading(false);
    }
  };

  const startPolling = (sId: string) => {
    setPollingActive(true);
    pollRef.current = setInterval(async () => {
      try {
        const res = await fetch(`/api/device-verification/session/${encodeURIComponent(sId)}`);
        const data = await res.json();
        if (data.success && data.session.status === 'completed' && data.session.verificationReport) {
          stopPolling();
          onSuccess(data.session.verificationReport);
        } else if (data.session?.status === 'expired') {
          stopPolling();
          setVerifyError('Verification session expired. Please try again.');
          setQrDataUrl(null);
        }
      } catch {
        // continue polling
      }
    }, 3000);
  };

  const stopPolling = () => {
    setPollingActive(false);
    if (pollRef.current) {
      clearInterval(pollRef.current);
      pollRef.current = null;
    }
  };

  useEffect(() => {
    return () => stopPolling();
  }, []);

  useEffect(() => {
    if (mode === 'qr') {
      startQRSession();
    } else {
      stopPolling();
    }
  }, [mode]);

  const handleManualVerify = async () => {
    const cleanImei = imei.trim().replace(/\D/g, '');
    if (!cleanImei || cleanImei.length !== 15) {
      setVerifyError('Please enter a valid 15-digit IMEI number.');
      return;
    }
    setIsVerifying(true);
    setVerifyError(null);
    try {
      const res = await fetch('/api/device-verification/validate-imei', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          imei: cleanImei,
          imei2: imei2.trim().replace(/\D/g, '') || undefined,
          selectedBrand: selectedBrand || '',
          selectedModel: selectedModel || '',
          selectedVariant: selectedVariant || '',
        }),
      });
      const data = await res.json();
      if (data.report) {
        onSuccess(data.report);
      } else {
        setVerifyError(data.message || 'Verification failed. Please check the IMEI and try again.');
      }
    } catch {
      setVerifyError('Network error. Please check connection and try again.');
    } finally {
      setIsVerifying(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-4 bg-black/70 backdrop-blur-sm">
      <div className="bg-white rounded-3xl w-full max-w-md shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
        {/* Header */}
        <div className="flex items-center justify-between p-5 border-b border-gray-100 bg-gradient-to-r from-slate-900 to-slate-800 text-white flex-shrink-0">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center">
              <Shield size={18} className="text-emerald-400" />
            </div>
            <div>
              <p className="font-black text-sm">Device Verification</p>
              <p className="text-xs text-slate-400 mt-0.5">
                {selectedBrand} {selectedModel} {selectedVariant && `· ${selectedVariant}`}
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-white/10 hover:bg-white/20 flex items-center justify-center transition-colors"
          >
            <X size={16} />
          </button>
        </div>

        <div className="overflow-y-auto flex-1">
          {/* Mode Chooser */}
          {mode === 'choose' && (
            <div className="p-5 space-y-4">
              <div className="bg-blue-50 border border-blue-100 rounded-2xl p-4 text-xs text-blue-800">
                <p className="font-bold mb-1 flex items-center gap-1.5"><Info size={13} /> How verification works</p>
                <p>Your web browser cannot directly read IMEI numbers. Choose an option below. All verification is secure and server-side.</p>
              </div>

              <button
                onClick={() => setMode('qr')}
                className="w-full flex items-center gap-4 p-4 bg-slate-900 text-white rounded-2xl hover:bg-slate-800 transition-all shadow-md"
              >
                <div className="w-11 h-11 rounded-xl bg-emerald-500/20 flex items-center justify-center flex-shrink-0">
                  <QrCode size={22} className="text-emerald-400" />
                </div>
                <div className="text-left">
                  <p className="font-bold text-sm">Verify using Maa Ambika App</p>
                  <p className="text-xs text-slate-400 mt-0.5">Scan QR code with mobile app for automatic verification</p>
                </div>
                <ChevronRight size={16} className="text-slate-400 ml-auto flex-shrink-0" />
              </button>

              <button
                onClick={() => setMode('manual')}
                className="w-full flex items-center gap-4 p-4 bg-gray-50 border border-gray-200 rounded-2xl hover:bg-gray-100 transition-all"
              >
                <div className="w-11 h-11 rounded-xl bg-slate-100 flex items-center justify-center flex-shrink-0">
                  <MonitorSmartphone size={22} className="text-slate-600" />
                </div>
                <div className="text-left">
                  <p className="font-bold text-sm text-gray-900">Enter IMEI Manually</p>
                  <p className="text-xs text-gray-500 mt-0.5">Dial *#06# on device to view IMEI, then enter below</p>
                </div>
                <ChevronRight size={16} className="text-gray-400 ml-auto flex-shrink-0" />
              </button>
            </div>
          )}

          {/* QR Mode */}
          {mode === 'qr' && (
            <div className="p-5 space-y-4">
              <button
                onClick={() => { setMode('choose'); setVerifyError(null); }}
                className="text-xs text-gray-500 hover:text-gray-800 flex items-center gap-1"
              >
                ← Back
              </button>

              <div className="bg-slate-50 rounded-2xl border border-slate-200 p-4">
                <h3 className="font-bold text-sm text-slate-900 mb-1">Scan with Maa Ambika App</h3>
                <p className="text-xs text-slate-500 mb-3">Open the Maa Ambika mobile app, go to <strong>Verify Device</strong>, and scan this QR code. The app will read your device IMEI and send it back automatically.</p>

                {qrLoading ? (
                  <div className="flex items-center justify-center h-48 bg-white rounded-xl border border-slate-100">
                    <Loader2 size={32} className="animate-spin text-slate-400" />
                  </div>
                ) : qrDataUrl ? (
                  <div className="flex flex-col items-center gap-3">
                    <div className="bg-white p-2 rounded-xl border border-slate-200 shadow-sm">
                      {/* eslint-disable-next-line @next/next/no-img-element */}
                      <img src={qrDataUrl} alt="Verification QR Code" className="w-48 h-48 object-contain" />
                    </div>
                    {pollingActive && (
                      <div className="flex items-center gap-2 text-xs text-emerald-700 bg-emerald-50 border border-emerald-100 px-3 py-2 rounded-xl">
                        <Loader2 size={12} className="animate-spin" />
                        Waiting for mobile app verification…
                      </div>
                    )}
                    <button
                      onClick={() => { stopPolling(); setQrDataUrl(null); startQRSession(); }}
                      className="text-xs text-gray-500 hover:text-gray-700 flex items-center gap-1"
                    >
                      <RefreshCw size={12} /> Refresh QR Code
                    </button>
                  </div>
                ) : null}
              </div>

              <div className="text-center">
                <p className="text-xs text-gray-400">Don&apos;t have the app?</p>
                <button
                  onClick={() => setMode('manual')}
                  className="text-xs font-bold text-primary hover:underline mt-1"
                >
                  Enter IMEI manually instead →
                </button>
              </div>

              {verifyError && (
                <div className="flex items-center gap-2 p-3 bg-red-50 border border-red-100 rounded-xl text-xs text-red-700">
                  <AlertTriangle size={13} className="flex-shrink-0" />
                  {verifyError}
                </div>
              )}
            </div>
          )}

          {/* Manual IMEI Mode */}
          {mode === 'manual' && (
            <div className="p-5 space-y-4">
              <button
                onClick={() => { setMode('choose'); setVerifyError(null); }}
                className="text-xs text-gray-500 hover:text-gray-800 flex items-center gap-1"
              >
                ← Back
              </button>

              <div className="bg-blue-50 border border-blue-100 rounded-xl p-3 text-xs text-blue-800">
                <p className="font-bold mb-0.5">How to find your IMEI</p>
                <p>Dial <strong>*#06#</strong> on your phone, or go to <strong>Settings → About Phone</strong>.</p>
              </div>

              <div className="space-y-3">
                <div>
                  <label className="text-xs font-bold text-gray-700 mb-1.5 block">IMEI 1 (Required)</label>
                  <div className="relative">
                    <input
                      type={showImei ? 'text' : 'password'}
                      value={imei}
                      onChange={e => {
                        setImei(e.target.value.replace(/\D/g, '').slice(0, 15));
                        setVerifyError(null);
                      }}
                      placeholder="15-digit IMEI number"
                      inputMode="numeric"
                      className="w-full px-4 py-3 rounded-xl border border-gray-200 text-sm font-mono focus:outline-none focus:ring-2 focus:ring-primary/20 bg-white pr-10"
                    />
                    <button
                      type="button"
                      onClick={() => setShowImei(!showImei)}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-700"
                    >
                      {showImei ? <EyeOff size={16} /> : <Eye size={16} />}
                    </button>
                  </div>
                  <p className="text-[11px] text-gray-400 mt-1">{imei.length}/15 digits</p>
                </div>

                <div>
                  <label className="text-xs font-bold text-gray-700 mb-1.5 block">IMEI 2 (Optional — dual SIM devices)</label>
                  <input
                    type="text"
                    value={imei2}
                    onChange={e => setImei2(e.target.value.replace(/\D/g, '').slice(0, 15))}
                    placeholder="Second IMEI (if available)"
                    inputMode="numeric"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 text-sm font-mono focus:outline-none focus:ring-2 focus:ring-primary/20 bg-white"
                  />
                </div>
              </div>

              <div className="bg-amber-50 border border-amber-100 rounded-xl p-3 text-xs text-amber-800">
                <p className="font-bold flex items-center gap-1 mb-0.5"><Lock size={11} /> Your IMEI is protected</p>
                <p>IMEI is transmitted securely (HTTPS). It is masked in all interfaces and never exposed in logs, URLs or notifications.</p>
              </div>

              {verifyError && (
                <div className="flex items-start gap-2 p-3 bg-red-50 border border-red-100 rounded-xl text-xs text-red-700">
                  <AlertTriangle size={13} className="flex-shrink-0 mt-0.5" />
                  {verifyError}
                </div>
              )}

              <button
                onClick={handleManualVerify}
                disabled={isVerifying || imei.replace(/\D/g, '').length !== 15}
                className="w-full py-3.5 bg-slate-900 hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed text-white rounded-2xl font-bold text-sm flex items-center justify-center gap-2 shadow-md transition-all"
              >
                {isVerifying ? (
                  <>
                    <Loader2 size={16} className="animate-spin" />
                    Verifying IMEI…
                  </>
                ) : (
                  <>
                    <Shield size={16} className="text-emerald-400" />
                    Verify Device
                  </>
                )}
              </button>

              <p className="text-[10px] text-gray-400 text-center">
                Verification runs Luhn checksum, TAC lookup, and device matching. No external API required for basic verification.
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
