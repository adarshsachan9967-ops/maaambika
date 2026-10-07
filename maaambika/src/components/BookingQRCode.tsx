'use client';
import React, { useEffect, useState } from 'react';
import QRCode from 'qrcode';
import { QrCode, Download, Copy, Check, ShieldCheck, Sparkles } from 'lucide-react';

interface BookingQRCodeProps {
  orderNumber: string;
  orderId?: string;
  deviceName?: string;
  customerName?: string;
  size?: number;
  showDetails?: boolean;
  showDownload?: boolean;
  className?: string;
}

export default function BookingQRCode({
  orderNumber,
  orderId,
  deviceName,
  customerName,
  size = 200,
  showDetails = true,
  showDownload = true,
  className = '',
}: BookingQRCodeProps) {
  const [qrDataUrl, setQrDataUrl] = useState<string>('');
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    if (!orderNumber) return;

    let inspectionUrl = `https://camsik.vercel.app/partner/inspection?orderId=${encodeURIComponent(orderNumber)}`;
    if (typeof window !== 'undefined') {
      inspectionUrl = `${window.location.origin}/partner/inspection?orderId=${encodeURIComponent(orderNumber)}`;
    }

    QRCode.toDataURL(inspectionUrl, {
      width: size * 2,
      margin: 1.5,
      color: {
        dark: '#0f172a',
        light: '#ffffff',
      },
      errorCorrectionLevel: 'H',
    })
      .then(url => {
        setQrDataUrl(url);
      })
      .catch(err => {
        console.error('Failed generating QR code:', err);
      });
  }, [orderNumber, size]);

  const handleCopy = () => {
    navigator.clipboard.writeText(orderNumber);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleDownload = () => {
    if (!qrDataUrl) return;
    const a = document.createElement('a');
    a.href = qrDataUrl;
    a.download = `Booking-QR-${orderNumber}.png`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  };

  return (
    <div className={`flex flex-col items-center text-center p-5 bg-white rounded-3xl border border-slate-200/90 shadow-sm ${className}`}>
      {/* Header Pill */}
      <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 text-[11px] font-black uppercase tracking-wider mb-3 border border-emerald-200/70">
        <ShieldCheck size={13} className="text-emerald-600" />
        <span>Doorstep Inspection Pass</span>
      </div>

      {/* QR Code Container */}
      <div className="p-3 bg-white rounded-2xl border-2 border-dashed border-emerald-300 shadow-xs relative group">
        {qrDataUrl ? (
          <img
            src={qrDataUrl}
            alt={`QR Code for Booking #${orderNumber}`}
            style={{ width: size, height: size }}
            className="rounded-xl object-contain"
          />
        ) : (
          <div
            style={{ width: size, height: size }}
            className="flex items-center justify-center bg-slate-50 rounded-xl"
          >
            <div className="w-8 h-8 border-2 border-emerald-600 border-t-transparent rounded-full animate-spin" />
          </div>
        )}
      </div>

      {showDetails && (
        <div className="mt-3.5 space-y-1">
          <p className="text-xs font-semibold text-slate-500">Unique Verification Code</p>
          <div className="flex items-center justify-center gap-2">
            <span className="font-mono text-base font-black text-slate-900 tracking-tight">
              #{orderNumber}
            </span>
            <button
              type="button"
              onClick={handleCopy}
              className="p-1 text-slate-400 hover:text-slate-700 hover:bg-slate-100 rounded-md transition-colors"
              title="Copy Order Number"
            >
              {copied ? <Check size={14} className="text-emerald-600" /> : <Copy size={14} />}
            </button>
          </div>
          {deviceName && (
            <p className="text-xs font-bold text-slate-700 truncate max-w-[220px]">
              {deviceName}
            </p>
          )}
          <p className="text-[11px] text-slate-500 max-w-[260px] leading-relaxed pt-1">
            Show this QR code to our partner / technician at doorstep to verify and initiate physical inspection.
          </p>
        </div>
      )}

      {showDownload && qrDataUrl && (
        <div className="flex items-center gap-2 mt-4 pt-3 border-t border-slate-100 w-full justify-center">
          <button
            type="button"
            onClick={handleDownload}
            className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold transition-colors cursor-pointer"
          >
            <Download size={13} />
            <span>Download QR</span>
          </button>
          <button
            type="button"
            onClick={handleCopy}
            className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl border border-slate-200 hover:border-slate-300 text-slate-700 text-xs font-bold hover:bg-slate-50 transition-colors cursor-pointer"
          >
            {copied ? <Check size={13} className="text-emerald-600" /> : <Copy size={13} />}
            <span>{copied ? 'Copied!' : 'Copy Code'}</span>
          </button>
        </div>
      )}
    </div>
  );
}
