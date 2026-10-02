'use client';
import React, { useState } from 'react';
import { Shield, CheckCircle2, AlertTriangle, Lock, ChevronRight, Eye, Smartphone } from 'lucide-react';
import type { DeviceVerificationReport } from '@/lib/deviceVerification/types';
import DeviceVerificationModal from './DeviceVerificationModal';
import FullVerificationReportModal from './FullVerificationReportModal';

interface DeviceVerificationSectionProps {
  selectedBrand?: string;
  selectedModel?: string;
  selectedVariant?: string;
  verificationReport: DeviceVerificationReport | null;
  onVerified: (report: DeviceVerificationReport) => void;
  onRecheck?: () => void;
}

export default function DeviceVerificationSection({
  selectedBrand,
  selectedModel,
  selectedVariant,
  verificationReport,
  onVerified,
  onRecheck,
}: DeviceVerificationSectionProps) {
  const [showModal, setShowModal] = useState(false);
  const [showReport, setShowReport] = useState(false);

  const isVerified = verificationReport?.status === 'verified';
  const isMismatch = verificationReport?.status === 'mismatch';
  const isFailed = verificationReport?.status === 'failed';

  if (isVerified && verificationReport) {
    return (
      <>
        <div className="my-5 rounded-2xl bg-emerald-50 border border-emerald-200 p-4 space-y-3 shadow-sm">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2.5">
              <div className="w-9 h-9 rounded-xl bg-emerald-600 flex items-center justify-center shadow-md shadow-emerald-600/30">
                <CheckCircle2 size={20} className="text-white" />
              </div>
              <div>
                <p className="font-black text-emerald-800 text-sm leading-none">{verificationReport.verificationLabel}</p>
                <p className="text-xs text-emerald-600 mt-0.5 font-medium">Identity confirmed — proceed to get quote</p>
              </div>
            </div>
            <button
              onClick={() => setShowReport(true)}
              className="text-xs text-emerald-700 bg-white border border-emerald-300 px-2.5 py-1.5 rounded-lg flex items-center gap-1 hover:bg-emerald-50 transition-colors"
            >
              <Eye size={11} />
              View
            </button>
          </div>

          <div className="grid grid-cols-2 gap-2 text-xs">
            <div className="bg-white rounded-xl p-2.5 border border-emerald-100">
              <p className="text-gray-500 text-[10px] uppercase font-bold mb-0.5">Device</p>
              <p className="font-bold text-gray-900">{verificationReport.device.brand} {verificationReport.device.model}</p>
            </div>
            <div className="bg-white rounded-xl p-2.5 border border-emerald-100">
              <p className="text-gray-500 text-[10px] uppercase font-bold mb-0.5">IMEI (Masked)</p>
              <p className="font-mono font-bold text-gray-900">{verificationReport.identifiers.maskedImei}</p>
            </div>
            <div className="bg-white rounded-xl p-2.5 border border-emerald-100">
              <p className="text-gray-500 text-[10px] uppercase font-bold mb-0.5">Verification ID</p>
              <p className="font-mono font-bold text-emerald-700">{verificationReport.verificationId}</p>
            </div>
            <div className="bg-white rounded-xl p-2.5 border border-emerald-100">
              <p className="text-gray-500 text-[10px] uppercase font-bold mb-0.5">Checks</p>
              <div className="flex flex-col gap-0.5">
                {verificationReport.matching.brandMatched && <span className="text-emerald-600">✓ Brand matched</span>}
                {verificationReport.matching.modelMatched && <span className="text-emerald-600">✓ Model matched</span>}
                {verificationReport.identifiers.luhnValid && <span className="text-emerald-600">✓ IMEI valid</span>}
              </div>
            </div>
          </div>
        </div>

        {showReport && verificationReport && (
          <FullVerificationReportModal
            report={verificationReport}
            onClose={() => setShowReport(false)}
          />
        )}
      </>
    );
  }

  if (isMismatch && verificationReport) {
    return (
      <>
        <div className="my-5 rounded-2xl bg-amber-50 border border-amber-200 p-4 space-y-3">
          <div className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-xl bg-amber-500 flex items-center justify-center">
              <AlertTriangle size={18} className="text-white" />
            </div>
            <div>
              <p className="font-black text-amber-800 text-sm">⚠ DEVICE INFORMATION MISMATCH</p>
              <p className="text-xs text-amber-700">The detected device does not match the device selected for this transaction.</p>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-2 text-xs">
            <div className="bg-white rounded-xl p-2.5 border border-amber-100">
              <p className="text-gray-500 text-[10px] uppercase font-bold mb-0.5">Selected</p>
              <p className="font-bold text-gray-900">{verificationReport.matching.selectedDevice.brand} {verificationReport.matching.selectedDevice.model}</p>
            </div>
            <div className="bg-white rounded-xl p-2.5 border border-amber-100">
              <p className="text-gray-500 text-[10px] uppercase font-bold mb-0.5">Detected</p>
              <p className="font-bold text-gray-900">{verificationReport.matching.detectedDevice.brand} {verificationReport.matching.detectedDevice.model}</p>
            </div>
          </div>
          <div className="flex gap-2">
            <button
              onClick={() => setShowModal(true)}
              className="flex-1 py-2 text-xs font-bold bg-amber-600 text-white rounded-xl hover:bg-amber-700 transition-colors"
            >
              Recheck Device
            </button>
            {onRecheck && (
              <button
                onClick={onRecheck}
                className="flex-1 py-2 text-xs font-bold bg-white border border-amber-300 text-amber-800 rounded-xl hover:bg-amber-50 transition-colors"
              >
                Change Device
              </button>
            )}
          </div>
        </div>

        {showModal && (
          <DeviceVerificationModal
            selectedBrand={selectedBrand}
            selectedModel={selectedModel}
            selectedVariant={selectedVariant}
            onSuccess={(report) => { onVerified(report); setShowModal(false); }}
            onClose={() => setShowModal(false)}
          />
        )}
      </>
    );
  }

  // Default: direct manual IMEI input on page
  const [inlineImei, setInlineImei] = useState('');
  const [isVerifying, setIsVerifying] = useState(false);
  const [inlineError, setInlineError] = useState<string | null>(null);

  const handleInlineVerify = async () => {
    const cleanImei = inlineImei.trim().replace(/\D/g, '');
    if (!cleanImei || cleanImei.length !== 15) {
      setInlineError('Please enter a valid 15-digit IMEI number.');
      return;
    }
    setIsVerifying(true);
    setInlineError(null);
    try {
      const res = await fetch('/api/device-verification/validate-imei', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          imei: cleanImei,
          selectedBrand: selectedBrand || '',
          selectedModel: selectedModel || '',
          selectedVariant: selectedVariant || '',
        }),
      });
      const data = await res.json();
      if (data.report) {
        onVerified(data.report);
      } else {
        setInlineError(data.message || 'Verification failed. Please check the IMEI.');
      }
    } catch {
      setInlineError('Connection issue. Please retry.');
    } finally {
      setIsVerifying(false);
    }
  };

  return (
    <>
      <div className="my-5 rounded-2xl border-2 border-dashed border-emerald-300 bg-emerald-50/40 p-5 space-y-4">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-slate-900 flex items-center justify-center shadow-md">
            <Shield size={20} className="text-emerald-400" />
          </div>
          <div>
            <p className="font-black text-slate-900 text-sm flex items-center gap-1.5">
              🔐 VERIFY DEVICE (MANUAL IMEI)
            </p>
            <p className="text-xs text-slate-500">
              Dial <strong>*#06#</strong> on your phone keypad to find your 15-digit IMEI number.
            </p>
          </div>
        </div>

        <div className="bg-white rounded-2xl p-4 border border-emerald-200/80 shadow-xs space-y-3">
          <div>
            <label className="text-xs font-bold text-gray-700 mb-1.5 block">
              Enter 15-Digit IMEI Number:
            </label>
            <div className="flex gap-2">
              <input
                type="text"
                value={inlineImei}
                onChange={e => {
                  setInlineImei(e.target.value.replace(/\D/g, '').slice(0, 15));
                  setInlineError(null);
                }}
                placeholder="e.g. 359123456789012"
                inputMode="numeric"
                className="flex-1 px-4 py-2.5 rounded-xl border border-gray-200 text-sm font-mono focus:outline-none focus:ring-2 focus:ring-primary/20 bg-white"
              />
              <button
                type="button"
                onClick={handleInlineVerify}
                disabled={isVerifying || inlineImei.replace(/\D/g, '').length !== 15}
                className="px-5 py-2.5 bg-slate-900 hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed text-white font-bold text-xs rounded-xl shadow-xs transition-all cursor-pointer flex items-center gap-1.5 whitespace-nowrap"
              >
                {isVerifying ? 'Checking...' : 'Verify IMEI'}
              </button>
            </div>
            <div className="flex justify-between items-center text-[11px] text-gray-400 mt-1">
              <span>{inlineImei.length}/15 digits</span>
              {inlineImei.length === 15 && (
                <span className="text-emerald-600 font-bold flex items-center gap-1">
                  ✓ Ready to verify
                </span>
              )}
            </div>
          </div>

          {inlineError && (
            <p className="text-xs text-red-600 bg-red-50 p-2.5 rounded-xl border border-red-100">
              ⚠ {inlineError}
            </p>
          )}

          <p className="text-[11px] text-gray-400 flex items-center gap-1">
            <Lock size={11} className="text-emerald-600" />
            <span>Strict manual IMEI verification only. Confidential &amp; masked on receipts.</span>
          </p>
        </div>

        {isFailed && verificationReport && (
          <p className="text-xs text-red-600 text-center">
            ⚠ Last attempt failed: {verificationReport.notes[verificationReport.notes.length - 1]}
          </p>
        )}
      </div>

      {showModal && (
        <DeviceVerificationModal
          selectedBrand={selectedBrand}
          selectedModel={selectedModel}
          selectedVariant={selectedVariant}
          onSuccess={(report) => { onVerified(report); setShowModal(false); }}
          onClose={() => setShowModal(false)}
        />
      )}
    </>
  );
}
