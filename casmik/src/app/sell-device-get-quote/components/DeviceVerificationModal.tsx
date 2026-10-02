'use client';
import React, { useState } from 'react';
import {
  X, Shield, Lock, AlertTriangle, Loader2, Eye, EyeOff, CheckCircle2
} from 'lucide-react';
import type { DeviceVerificationReport } from '@/lib/deviceVerification/types';

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
  const [imei, setImei] = useState('');
  const [imei2, setImei2] = useState('');
  const [showImei, setShowImei] = useState(false);
  const [isVerifying, setIsVerifying] = useState(false);
  const [verifyError, setVerifyError] = useState<string | null>(null);

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
              <p className="font-black text-sm">Verify Device via IMEI</p>
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

        <div className="overflow-y-auto flex-1 p-5 space-y-4">
          <div className="bg-blue-50 border border-blue-100 rounded-xl p-3 text-xs text-blue-800">
            <p className="font-bold mb-0.5 flex items-center gap-1.5">
              <span>📱</span> How to find your IMEI
            </p>
            <p>Dial <strong>*#06#</strong> on your phone keypad to display your 15-digit IMEI number, or check <strong>Settings → About Phone</strong>.</p>
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
              <div className="flex justify-between items-center text-[11px] text-gray-400 mt-1">
                <span>{imei.length}/15 digits</span>
                {imei.length === 15 && <span className="text-emerald-600 font-bold flex items-center gap-1"><CheckCircle2 size={11} /> 15 digits entered</span>}
              </div>
            </div>

            <div>
              <label className="text-xs font-bold text-gray-700 mb-1.5 block">IMEI 2 (Optional — for dual SIM devices)</label>
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
            <p className="font-bold flex items-center gap-1 mb-0.5"><Lock size={11} /> Your IMEI is securely protected</p>
            <p>Verification is processed securely. Masked format is used across all receipts and orders.</p>
          </div>

          {verifyError && (
            <div className="flex items-start gap-2 p-3 bg-red-50 border border-red-100 rounded-xl text-xs text-red-700">
              <AlertTriangle size={13} className="flex-shrink-0 mt-0.5" />
              <span>{verifyError}</span>
            </div>
          )}

          <button
            onClick={handleManualVerify}
            disabled={isVerifying || imei.replace(/\D/g, '').length !== 15}
            className="w-full py-3.5 bg-slate-900 hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed text-white rounded-2xl font-bold text-sm flex items-center justify-center gap-2 shadow-md transition-all cursor-pointer"
          >
            {isVerifying ? (
              <>
                <Loader2 size={16} className="animate-spin" />
                Verifying IMEI & Brand…
              </>
            ) : (
              <>
                <Shield size={16} className="text-emerald-400" />
                Verify Device IMEI
              </>
            )}
          </button>

          <p className="text-[10px] text-gray-400 text-center">
            Verification checks Luhn checksum, TAC database, and matches selected brand and model.
          </p>
        </div>
      </div>
    </div>
  );
}
