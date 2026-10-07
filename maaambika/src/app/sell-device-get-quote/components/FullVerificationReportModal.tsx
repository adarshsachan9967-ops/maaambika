'use client';
import React from 'react';
import { X, CheckCircle2, AlertTriangle, Shield, Smartphone, Clock, FileText } from 'lucide-react';
import type { DeviceVerificationReport } from '@/lib/deviceVerification/types';

interface FullVerificationReportModalProps {
  report: DeviceVerificationReport;
  onClose: () => void;
}

export default function FullVerificationReportModal({ report, onClose }: FullVerificationReportModalProps) {
  const isVerified = report.status === 'verified';
  const isMismatch = report.status === 'mismatch';
  const isFailed = report.status === 'failed';

  const statusColor = isVerified
    ? 'bg-emerald-100 text-emerald-800 border-emerald-200'
    : isMismatch
    ? 'bg-amber-100 text-amber-800 border-amber-200'
    : 'bg-red-100 text-red-800 border-red-200';

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center p-4 bg-black/70 backdrop-blur-sm">
      <div className="bg-white rounded-3xl w-full max-w-lg shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
        {/* Header */}
        <div className="flex items-center justify-between p-5 border-b border-gray-100 flex-shrink-0">
          <div className="flex items-center gap-3">
            <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${isVerified ? 'bg-emerald-100' : isMismatch ? 'bg-amber-100' : 'bg-red-100'}`}>
              {isVerified ? <CheckCircle2 size={20} className="text-emerald-600" /> :
               isMismatch ? <AlertTriangle size={20} className="text-amber-600" /> :
               <AlertTriangle size={20} className="text-red-600" />}
            </div>
            <div>
              <h3 className="font-black text-gray-900 text-sm">Verification Report</h3>
              <p className="text-xs text-gray-500">Maa Ambika Device Verification</p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-gray-100 hover:bg-gray-200 flex items-center justify-center transition-colors"
          >
            <X size={16} />
          </button>
        </div>

        <div className="overflow-y-auto flex-1 p-5 space-y-4">
          {/* Status Banner */}
          <div className={`p-4 rounded-2xl border ${statusColor} text-center`}>
            <p className="font-black text-lg">{report.verificationLabel}</p>
            <p className="text-xs mt-0.5 opacity-80">{report.providerName}</p>
          </div>

          {/* Verification ID */}
          <div className="bg-slate-50 rounded-2xl p-3 border border-slate-100">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-gray-500 font-bold uppercase tracking-wide">Verification ID</p>
                <p className="font-mono font-black text-primary text-base mt-0.5">{report.verificationId}</p>
              </div>
              <Shield size={22} className="text-slate-300" />
            </div>
            <p className="text-[11px] text-gray-400 mt-1 flex items-center gap-1">
              <Clock size={10} />
              {new Date(report.timestamp).toLocaleString('en-IN', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' })}
            </p>
          </div>

          {/* Device Info */}
          <div className="space-y-2">
            <p className="text-xs font-bold text-gray-500 uppercase tracking-wide flex items-center gap-1.5">
              <Smartphone size={12} /> Device Information
            </p>
            <div className="bg-gray-50 rounded-2xl border border-gray-100 p-3 grid grid-cols-2 gap-2 text-xs">
              {[
                { label: 'Brand', value: report.device.brand },
                { label: 'Model', value: report.device.model },
                report.device.modelNumber ? { label: 'Model Number', value: report.device.modelNumber } : null,
                report.device.os ? { label: 'OS', value: report.device.os } : null,
                { label: 'Device Type', value: report.device.deviceType || 'Smartphone' },
                report.device.storage ? { label: 'Storage', value: report.device.storage } : null,
              ].filter(Boolean).map((item: any) => (
                <div key={item.label}>
                  <p className="text-gray-400 text-[10px] uppercase font-bold">{item.label}</p>
                  <p className="font-bold text-gray-900 mt-0.5">{item.value}</p>
                </div>
              ))}
            </div>
          </div>

          {/* Identifiers */}
          <div className="space-y-2">
            <p className="text-xs font-bold text-gray-500 uppercase tracking-wide">IMEI & Identifiers</p>
            <div className="bg-gray-50 rounded-2xl border border-gray-100 p-3 space-y-2 text-xs">
              <div className="flex justify-between items-center">
                <span className="text-gray-500">IMEI (Masked)</span>
                <span className="font-mono font-bold text-gray-900">{report.identifiers.maskedImei}</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-500">TAC Code</span>
                <span className="font-mono font-bold text-gray-700">{report.identifiers.tac}</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-500">Luhn Checksum</span>
                <span className={`font-bold ${report.identifiers.luhnValid ? 'text-emerald-600' : 'text-red-600'}`}>
                  {report.identifiers.luhnValid ? '✓ Valid' : '✗ Failed'}
                </span>
              </div>
            </div>
          </div>

          {/* Matching */}
          <div className="space-y-2">
            <p className="text-xs font-bold text-gray-500 uppercase tracking-wide">Device Matching</p>
            <div className="bg-gray-50 rounded-2xl border border-gray-100 p-3 space-y-1.5 text-xs">
              {[
                { label: 'Brand', passed: report.matching.brandMatched },
                { label: 'Model', passed: report.matching.modelMatched },
                { label: 'Variant', passed: report.matching.variantMatched },
              ].map(item => (
                <div key={item.label} className="flex items-center justify-between">
                  <span className="text-gray-600">{item.label}</span>
                  <span className={`font-bold flex items-center gap-1 ${item.passed ? 'text-emerald-600' : 'text-red-500'}`}>
                    {item.passed ? <CheckCircle2 size={12} /> : <AlertTriangle size={12} />}
                    {item.passed ? 'Matched' : 'Mismatch'}
                  </span>
                </div>
              ))}
              {report.matching.mismatchReason && (
                <p className="text-amber-700 text-[11px] bg-amber-50 rounded-lg p-2 mt-1">{report.matching.mismatchReason}</p>
              )}
            </div>
          </div>

          {/* Security */}
          <div className="space-y-2">
            <p className="text-xs font-bold text-gray-500 uppercase tracking-wide">Security Status</p>
            <div className="bg-gray-50 rounded-2xl border border-gray-100 p-3 space-y-1.5 text-xs">
              <div className="flex items-center justify-between">
                <span className="text-gray-600">Blacklist Status</span>
                <span className={`font-bold uppercase ${report.security.blacklistStatus === 'clean' ? 'text-emerald-600' : report.security.blacklistStatus === 'blacklisted' ? 'text-red-600' : 'text-amber-600'}`}>
                  {report.security.blacklistStatus}
                </span>
              </div>
              {report.security.carrierLock && (
                <div className="flex items-center justify-between">
                  <span className="text-gray-600">Network Lock</span>
                  <span className="font-bold text-gray-800">{report.security.carrierLock}</span>
                </div>
              )}
              {report.security.networkCapability && (
                <div className="flex items-center justify-between">
                  <span className="text-gray-600">Network</span>
                  <span className="font-bold text-gray-800">{report.security.networkCapability}</span>
                </div>
              )}
              {report.security.blacklistRecord && (
                <div className="bg-red-50 border border-red-100 rounded-xl p-2 mt-1">
                  <p className="font-bold text-red-700 text-[11px]">⚠ Blacklist Record Detected</p>
                  <p className="text-red-600 text-[11px] mt-0.5">{report.security.blacklistRecord.reason}</p>
                  <p className="text-red-400 text-[10px] mt-0.5">Source: {report.security.blacklistRecord.source}</p>
                </div>
              )}
            </div>
          </div>

          {/* Notes / Audit Trail */}
          {report.notes && report.notes.length > 0 && (
            <div className="space-y-2">
              <p className="text-xs font-bold text-gray-500 uppercase tracking-wide flex items-center gap-1.5">
                <FileText size={12} /> Audit Trail
              </p>
              <div className="bg-slate-50 rounded-2xl border border-slate-100 p-3 space-y-1 text-[11px] text-slate-600">
                {report.notes.map((note, idx) => (
                  <p key={idx} className="flex items-start gap-1.5">
                    <span className="text-slate-300 mt-0.5">•</span>
                    {note}
                  </p>
                ))}
              </div>
            </div>
          )}

          <div className="bg-amber-50 border border-amber-100 rounded-xl p-3 text-[11px] text-amber-700">
            <strong>Note:</strong> A clean blacklist result is not a universal guarantee that this device has never been reported lost or stolen globally. For high-value transactions, request CEIR/Sanchar Saathi verification from the seller.
          </div>
        </div>

        <div className="p-4 border-t border-gray-100 flex-shrink-0">
          <button
            onClick={onClose}
            className="w-full py-3 bg-gray-900 text-white rounded-2xl font-bold text-sm hover:bg-black transition-colors"
          >
            Close Report
          </button>
        </div>
      </div>
    </div>
  );
}
