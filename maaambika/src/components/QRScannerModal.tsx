'use client';
import React, { useState, useRef, useEffect } from 'react';
import { Camera, X, Scan, Upload, Search, CheckCircle, AlertCircle, Sparkles } from 'lucide-react';

interface QRScannerModalProps {
  isOpen: boolean;
  onClose: () => void;
  onScanSuccess: (orderIdOrNumber: string) => void;
  title?: string;
  subtitle?: string;
}

export default function QRScannerModal({
  isOpen,
  onClose,
  onScanSuccess,
  title = 'Scan Customer QR Code',
  subtitle = 'Point camera at customer booking QR code or enter Order ID manually',
}: QRScannerModalProps) {
  const [manualCode, setManualCode] = useState('');
  const [cameraActive, setCameraActive] = useState(false);
  const [cameraError, setCameraError] = useState<string | null>(null);
  const [scanStatus, setScanStatus] = useState<'idle' | 'scanning' | 'success' | 'error'>('idle');
  const [feedbackMsg, setFeedbackMsg] = useState('');
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const animFrameRef = useRef<number | null>(null);

  // Extract orderId from text/URL
  const extractOrderCode = (rawText: string): string => {
    const trimmed = rawText.trim();
    if (!trimmed) return '';

    // Check if it's a URL with orderId parameter
    try {
      if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
        const url = new URL(trimmed);
        const orderParam = url.searchParams.get('orderId');
        if (orderParam) return orderParam;
      }
    } catch {}

    // Check if JSON
    try {
      if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        const parsed = JSON.parse(trimmed);
        if (parsed.orderNumber) return parsed.orderNumber;
        if (parsed.id) return parsed.id;
        if (parsed.orderId) return parsed.orderId;
      }
    } catch {}

    // Check for CSM-2024-XXX or similar pattern
    const match = trimmed.match(/CSM-[A-Za-z0-9-]+/i) || trimmed.match(/ord-[A-Za-z0-9-]+/i);
    if (match) return match[0];

    return trimmed;
  };

  const handleDetectedCode = (code: string) => {
    const cleanCode = extractOrderCode(code);
    if (!cleanCode) return;

    setScanStatus('success');
    setFeedbackMsg(`Identified Order: ${cleanCode}`);
    stopCamera();

    setTimeout(() => {
      onScanSuccess(cleanCode);
      onClose();
    }, 600);
  };

  const startCamera = async () => {
    setCameraError(null);
    setCameraActive(true);
    setScanStatus('scanning');

    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: 'environment', width: { ideal: 1280 }, height: { ideal: 720 } },
      });
      streamRef.current = stream;
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        await videoRef.current.play();
      }

      // Check if native BarcodeDetector is available
      if ('BarcodeDetector' in window) {
        // @ts-ignore
        const barcodeDetector = new window.BarcodeDetector({ formats: ['qr_code'] });
        const detectFrame = async () => {
          if (!videoRef.current || videoRef.current.readyState < 2) {
            animFrameRef.current = requestAnimationFrame(detectFrame);
            return;
          }
          try {
            const barcodes = await barcodeDetector.detect(videoRef.current);
            if (barcodes && barcodes.length > 0) {
              const detectedValue = barcodes[0].rawValue;
              handleDetectedCode(detectedValue);
              return;
            }
          } catch {}
          animFrameRef.current = requestAnimationFrame(detectFrame);
        };
        detectFrame();
      }
    } catch (err: any) {
      console.warn('Camera stream error:', err);
      setCameraError(err.message || 'Unable to access device camera. You can type order ID or upload QR photo below.');
      setCameraActive(false);
      setScanStatus('idle');
    }
  };

  const stopCamera = () => {
    if (animFrameRef.current) {
      cancelAnimationFrame(animFrameRef.current);
      animFrameRef.current = null;
    }
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(track => track.stop());
      streamRef.current = null;
    }
    setCameraActive(false);
  };

  useEffect(() => {
    if (isOpen) {
      startCamera();
    } else {
      stopCamera();
    }
    return () => {
      stopCamera();
    };
  }, [isOpen]);

  const handleManualSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!manualCode.trim()) return;
    handleDetectedCode(manualCode);
  };

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if ('BarcodeDetector' in window) {
      try {
        // @ts-ignore
        const barcodeDetector = new window.BarcodeDetector({ formats: ['qr_code'] });
        const img = new Image();
        img.src = URL.createObjectURL(file);
        img.onload = async () => {
          try {
            const barcodes = await barcodeDetector.detect(img);
            if (barcodes && barcodes.length > 0) {
              handleDetectedCode(barcodes[0].rawValue);
              return;
            }
            setCameraError('No valid QR code found in uploaded photo. Please enter code manually.');
          } catch {
            setCameraError('Failed analyzing image. Please enter code manually.');
          }
        };
      } catch {
        setCameraError('Automatic image detection unsupported. Enter Order Number manually.');
      }
    } else {
      setCameraError('Direct file QR decoding not supported on this browser. Please type order number.');
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/70 backdrop-blur-xs flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-md w-full p-6 relative animate-in fade-in zoom-in-95 duration-200">
        {/* Close Button */}
        <button
          type="button"
          onClick={() => {
            stopCamera();
            onClose();
          }}
          className="absolute top-4 right-4 text-slate-400 hover:text-slate-700 p-2 rounded-full hover:bg-slate-100 transition-colors"
        >
          <X size={18} />
        </button>

        {/* Modal Header */}
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 rounded-2xl bg-emerald-50 text-emerald-700 flex items-center justify-center border border-emerald-200 shadow-xs">
            <Scan size={20} />
          </div>
          <div>
            <h3 className="text-lg font-black text-slate-900">{title}</h3>
            <p className="text-xs text-slate-500 font-semibold">{subtitle}</p>
          </div>
        </div>

        {/* Camera Viewfinder */}
        <div className="relative rounded-2xl overflow-hidden bg-slate-950 aspect-square mb-4 border-2 border-slate-800 flex items-center justify-center">
          {cameraActive ? (
            <>
              <video
                ref={videoRef}
                playsInline
                muted
                className="w-full h-full object-cover"
              />
              {/* Overlay Target Box */}
              <div className="absolute inset-0 flex items-center justify-center pointer-events-none p-12">
                <div className="w-full h-full border-2 border-emerald-400/80 rounded-2xl relative shadow-lg">
                  <div className="absolute top-0 left-0 w-4 h-4 border-t-4 border-l-4 border-emerald-400 -mt-0.5 -ml-0.5 rounded-tl" />
                  <div className="absolute top-0 right-0 w-4 h-4 border-t-4 border-r-4 border-emerald-400 -mt-0.5 -mr-0.5 rounded-tr" />
                  <div className="absolute bottom-0 left-0 w-4 h-4 border-b-4 border-l-4 border-emerald-400 -mb-0.5 -ml-0.5 rounded-bl" />
                  <div className="absolute bottom-0 right-0 w-4 h-4 border-b-4 border-r-4 border-emerald-400 -mb-0.5 -mr-0.5 rounded-br" />
                  <div className="w-full h-0.5 bg-emerald-400/80 absolute top-1/2 -translate-y-1/2 animate-pulse" />
                </div>
              </div>
              <p className="absolute bottom-3 text-[11px] font-bold text-white/90 bg-black/60 px-3 py-1 rounded-full backdrop-blur-xs">
                Scanning customer QR code...
              </p>
            </>
          ) : (
            <div className="text-center p-6 text-slate-400">
              <Camera size={36} className="mx-auto mb-2 opacity-50 text-slate-400" />
              <p className="text-xs font-bold text-slate-300">Camera preview inactive</p>
              {cameraError && (
                <p className="text-[11px] text-amber-400 mt-2 max-w-xs">{cameraError}</p>
              )}
              <button
                type="button"
                onClick={startCamera}
                className="mt-3 px-3.5 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold transition-all shadow-xs"
              >
                Restart Camera
              </button>
            </div>
          )}

          {scanStatus === 'success' && (
            <div className="absolute inset-0 bg-emerald-600/90 backdrop-blur-xs flex flex-col items-center justify-center text-white p-4 animate-in fade-in">
              <CheckCircle size={44} className="mb-2 text-white animate-bounce" />
              <p className="text-base font-black">QR Verified!</p>
              <p className="text-xs font-semibold text-emerald-100 mt-1">{feedbackMsg}</p>
            </div>
          )}
        </div>

        {/* Alternative Actions: Upload QR or Manual Input */}
        <div className="space-y-3">
          <form onSubmit={handleManualSubmit} className="flex gap-2">
            <div className="relative flex-1">
              <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
              <input
                type="text"
                placeholder="Or enter Order # (e.g. CSM-2024-123)"
                value={manualCode}
                onChange={e => setManualCode(e.target.value)}
                className="w-full pl-9 pr-3 py-2.5 rounded-xl border border-slate-200 text-xs font-semibold text-slate-800 focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
              />
            </div>
            <button
              type="submit"
              disabled={!manualCode.trim()}
              className="px-4 py-2.5 rounded-xl bg-slate-900 hover:bg-slate-800 disabled:opacity-40 text-white text-xs font-bold transition-colors cursor-pointer"
            >
              Verify
            </button>
          </form>

          <div className="flex items-center justify-between pt-2 border-t border-slate-100 text-xs">
            <label className="inline-flex items-center gap-1.5 text-slate-600 hover:text-slate-900 font-semibold cursor-pointer">
              <Upload size={14} className="text-emerald-600" />
              <span>Upload QR Image</span>
              <input
                type="file"
                accept="image/*"
                onChange={handleFileUpload}
                className="hidden"
              />
            </label>
            <span className="text-[11px] text-slate-400 font-medium">Auto-verifies & opens order</span>
          </div>
        </div>
      </div>
    </div>
  );
}
