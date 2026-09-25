'use client';
import React, { useState, useEffect, useRef } from 'react';
import { orders as defaultOrders, getOrderStatusLabel, getOrderStatusColor } from '@/lib/casmikData';
import type { Order } from '@/lib/casmikData';
import { createClient } from '@/lib/supabase/client';
import { triggerNotification } from '@/lib/notifications';
import QRScannerModal from '@/components/QRScannerModal';
import { 
  Camera, 
  CheckCircle, 
  XCircle, 
  Upload, 
  ClipboardCheck, 
  ArrowLeft, 
  SlidersHorizontal, 
  DollarSign, 
  Eye, 
  Trash2, 
  RefreshCw, 
  AlertTriangle, 
  Sparkles, 
  ShieldAlert, 
  Zap, 
  CheckCircle2, 
  X, 
  Maximize2,
  Scan,
  CreditCard,
  PlusCircle,
  Check,
  Phone,
  UserCheck,
  Lock
} from 'lucide-react';

interface InspectionCheckItem {
  id: string;
  label: string;
  subtext: string;
  deductionPct: number;
  bonusPct?: number;
  bonusLabel?: string;
}

const inspectionItems: InspectionCheckItem[] = [
  { id: 'display', label: 'Display & Touchscreen', subtext: 'Cracks, dead pixels, lines, touch responsiveness', deductionPct: 25, bonusPct: 5, bonusLabel: 'Flawless Like-New Screen (+5%)' },
  { id: 'body', label: 'Body & Frame Condition', subtext: 'Dents, heavy scratches, bent frame, discoloration', deductionPct: 12, bonusPct: 4, bonusLabel: 'Scratchless Like-New Body (+4%)' },
  { id: 'camera', label: 'Camera & Optics', subtext: 'Front & rear camera focus, lens glass, sensor dust', deductionPct: 15 },
  { id: 'battery', label: 'Battery Health & Endurance', subtext: 'Battery health degradation, rapid discharge, swelling', deductionPct: 10, bonusPct: 4, bonusLabel: 'Battery Health > 90% (+4%)' },
  { id: 'faceid', label: 'Biometrics (Face ID / Fingerprint)', subtext: 'Face ID, Touch ID, or fingerprint sensor failure', deductionPct: 12 },
  { id: 'charging', label: 'Charging & USB Port', subtext: 'Loose port, slow charging, or no PC data sync', deductionPct: 8 },
  { id: 'speaker', label: 'Speakers & Microphones', subtext: 'Cracking sound, low earpiece volume, mic distortion', deductionPct: 6 },
  { id: 'wifi', label: 'Wireless (Wi-Fi, Bluetooth, NFC)', subtext: 'Wi-Fi drop, Bluetooth pairing failure, GPS glitch', deductionPct: 6 },
  { id: 'network', label: 'Cellular SIM & Antennas', subtext: 'No service, baseband issue, damaged SIM slot', deductionPct: 10 },
  { id: 'buttons', label: 'Physical Buttons & Haptics', subtext: 'Stuck volume rocker, power key, faulty vibration', deductionPct: 5 },
  { id: 'water', label: 'Liquid Damage Check (LDI)', subtext: 'Internal moisture indicator triggered or corrosion', deductionPct: 20 },
  { id: 'accessories', label: 'Original Retail Box', subtext: 'Original matching box with authentic documentation', deductionPct: 5, bonusPct: 3, bonusLabel: 'Original Box Included (+3%)' },
  { id: 'charger', label: 'Original OEM Fast Charger', subtext: 'Authentic manufacturer fast charger and data cable', deductionPct: 0, bonusPct: 3, bonusLabel: 'Original Charger Included (+3%)' },
];

const photoAngles = [
  { id: 'front', label: 'Front Display (Screen On)', desc: 'Display with white background' },
  { id: 'back', label: 'Back Panel & Housing', desc: 'Back glass or aluminum body' },
  { id: 'left', label: 'Left Side & Frame', desc: 'Left edge & volume buttons' },
  { id: 'right', label: 'Right Side & Frame', desc: 'Right edge & power button' },
  { id: 'ports', label: 'Top / Bottom Ports', desc: 'Charging port & speaker grilles' },
  { id: 'camera_lens', label: 'Camera Lens & Optics', desc: 'Close-up of camera cluster' },
  { id: 'imei_label', label: 'IMEI / Serial Screen', desc: 'Settings > About screen' },
  { id: 'defect', label: 'Scratch / Defect Close-up', desc: 'Any cosmetic blemish' },
];

const getInspectionOrders = (): Order[] => {
  if (typeof window !== 'undefined') {
    try {
      const saved = localStorage.getItem('casmik_partner_orders_v1') || localStorage.getItem('casmik_orders_v1');
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed) && parsed.length > 0) {
          return parsed;
        }
      }
    } catch {}
  }
  return defaultOrders;
};

interface PartnerInspectionProps {
  initialOrderId?: string | null;
  onBackToOrders?: () => void;
}

export default function PartnerInspection({ initialOrderId, onBackToOrders }: PartnerInspectionProps) {
  const [ordersList, setOrdersList] = useState<Order[]>(getInspectionOrders);
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(() => {
    const list = getInspectionOrders();
    const targetId = initialOrderId || (typeof window !== 'undefined' ? localStorage.getItem('casmik_active_inspection_id') : null);
    if (targetId) {
      const match = list.find(o => o.id === targetId || o.orderNumber === targetId);
      if (match) return match;
    }
    const readyOrder = list.find(o => ['inspection', 'accepted', 'picked_up'].includes(o.status));
    return readyOrder || list[0] || null;
  });

  const [inspectionResults, setInspectionResults] = useState<Record<string, 'pass' | 'fail' | 'bonus' | 'na'>>({});
  const [photos, setPhotos] = useState<Record<string, string>>({});
  const [activePhotoModal, setActivePhotoModal] = useState<{ label: string; url: string } | null>(null);
  const [customPriceOverride, setCustomPriceOverride] = useState<string>('');
  const [isCustomPrice, setIsCustomPrice] = useState(false);
  const [imei, setImei] = useState('');
  const [notes, setNotes] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [payoutDisbursed, setPayoutDisbursed] = useState(false);

  // QR Code Scanner State
  const [isQRScannerOpen, setIsQRScannerOpen] = useState(false);

  // User Confirmation & Payment Flow State
  const [customerConfirmedPrice, setCustomerConfirmedPrice] = useState(false);
  const [payoutMode, setPayoutMode] = useState<'upi' | 'imps' | 'cash'>('upi');
  const [payoutUpiOrRef, setPayoutUpiOrRef] = useState('');
  const [isProcessingPayout, setIsProcessingPayout] = useState(false);

  const fileInputRefs = useRef<Record<string, HTMLInputElement | null>>({});
  const multiFileInputRef = useRef<HTMLInputElement | null>(null);
  const supabase = createClient();

  useEffect(() => {
    const list = getInspectionOrders();
    setOrdersList(list);
    const targetId = initialOrderId || (typeof window !== 'undefined' ? localStorage.getItem('casmik_active_inspection_id') : null);
    if (targetId) {
      const match = list.find(o => o.id === targetId || o.orderNumber === targetId);
      if (match) {
        setSelectedOrder(match);
      }
    }
  }, [initialOrderId]);

  // Handle image capture / upload for a specific angle
  const handlePhotoCapture = (angleId: string, e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (event) => {
      if (event.target?.result) {
        setPhotos(prev => ({
          ...prev,
          [angleId]: event.target!.result as string,
        }));
      }
    };
    reader.readAsDataURL(file);
  };

  // Handle bulk multi-photo upload
  const handleMultiUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;

    Array.from(files).forEach((file, idx) => {
      const unassignedAngle = photoAngles.find(a => !photos[a.id]) || photoAngles[idx % photoAngles.length];
      const reader = new FileReader();
      reader.onload = (event) => {
        if (event.target?.result) {
          setPhotos(prev => ({
            ...prev,
            [unassignedAngle.id]: event.target!.result as string,
          }));
        }
      };
      reader.readAsDataURL(file);
    });
  };

  // Checklist handler
  const handleResult = (itemId: string, result: 'pass' | 'fail' | 'bonus' | 'na') => {
    setInspectionResults(prev => ({ ...prev, [itemId]: result }));
  };

  // Scoring and dynamic price calculations
  const total = inspectionItems.length;
  const passedCount = Object.values(inspectionResults).filter(v => v === 'pass' || v === 'bonus').length;
  const failedCount = Object.values(inspectionResults).filter(v => v === 'fail').length;
  const bonusCount = Object.values(inspectionResults).filter(v => v === 'bonus').length;
  const scorePercent = total > 0 ? Math.round((passedCount / total) * 100) : 100;

  const quotedPrice = selectedOrder?.quotedPrice || 0;

  // Additions (Bonus) Calculation
  const bonusItems = inspectionItems.filter(item => inspectionResults[item.id] === 'bonus');
  const totalBonusPct = bonusItems.reduce((acc, item) => acc + (item.bonusPct || 0), 0);
  const totalAdditionAmount = Math.round(quotedPrice * (totalBonusPct / 100));

  // Deductions Calculation
  const failedItems = inspectionItems.filter(item => inspectionResults[item.id] === 'fail');
  const totalDeductionPct = Math.min(
    failedItems.reduce((acc, item) => acc + item.deductionPct, 0),
    75
  );
  const totalDeductionAmount = Math.round(quotedPrice * (totalDeductionPct / 100));

  // Final exact calculated payout
  const calculatedExactPayout = Math.max(
    Math.round(quotedPrice + totalAdditionAmount - totalDeductionAmount),
    Math.round(quotedPrice * 0.25)
  );

  const finalPayoutToUser = isCustomPrice && customPriceOverride
    ? parseInt(customPriceOverride, 10) || calculatedExactPayout
    : calculatedExactPayout;

  // Instant Spot Payout Handler (shifts order to completed & paid)
  const handleInstantPayout = async () => {
    if (!selectedOrder || !customerConfirmedPrice) return;
    setIsProcessingPayout(true);

    const completedOrder: Order = {
      ...selectedOrder,
      finalPrice: finalPayoutToUser,
      inspectionScore: scorePercent,
      status: 'completed',
      paymentStatus: 'paid',
      notes: `${notes || selectedOrder.notes || ''} [Paid ₹${finalPayoutToUser.toLocaleString('en-IN')} via ${payoutMode.toUpperCase()} (${payoutUpiOrRef || 'Direct Transfer'}) · Verified & Closed]`.trim(),
      updatedAt: new Date().toISOString(),
    };

    // 1. Update partner orders in local storage
    if (typeof window !== 'undefined') {
      try {
        const partnerOrders = localStorage.getItem('casmik_partner_orders_v1');
        if (partnerOrders) {
          const list = JSON.parse(partnerOrders);
          if (Array.isArray(list)) {
            const updated = list.map((o: Order) => o.id === selectedOrder.id ? completedOrder : o);
            localStorage.setItem('casmik_partner_orders_v1', JSON.stringify(updated));
          }
        }
        const globalOrders = localStorage.getItem('casmik_orders_v1');
        if (globalOrders) {
          const list = JSON.parse(globalOrders);
          if (Array.isArray(list)) {
            const updated = list.map((o: Order) => o.id === selectedOrder.id ? completedOrder : o);
            localStorage.setItem('casmik_orders_v1', JSON.stringify(updated));
          }
        }
      } catch {}
    }

    // 2. Update remote Supabase if available
    try {
      await supabase.from('orders').update({
        final_price: finalPayoutToUser,
        inspection_score: scorePercent,
        status: 'completed',
        payment_status: 'paid',
        notes: completedOrder.notes,
      }).eq('id', selectedOrder.id);
    } catch (err) {
      console.log('Remote complete error:', err);
    }

    // 3. Trigger Real-Time Notification across customer, admin, and partner dashboards
    triggerNotification({
      type: 'payout',
      targetRole: 'all',
      title: `🎉 Booking Completed: ₹${finalPayoutToUser.toLocaleString('en-IN')} Paid!`,
      shortDetails: `Inspection verified and payout of ₹${finalPayoutToUser.toLocaleString('en-IN')} disbursed for #${selectedOrder.orderNumber} (${selectedOrder.deviceName}) via ${payoutMode.toUpperCase()}. Order is finalized.`,
      orderNumber: selectedOrder.orderNumber,
      deviceName: selectedOrder.deviceName,
      customerName: selectedOrder.customerName,
      price: finalPayoutToUser,
      status: 'completed',
    });

    setIsProcessingPayout(false);
    setPayoutDisbursed(true);
    setSubmitted(true);
  };

  // Orders available for inspection
  const displayOrders = ordersList.filter(o =>
    ['inspection', 'accepted', 'picked_up'].includes(o.status) || o.id === selectedOrder?.id
  );
  const ordersToShow = displayOrders.length > 0 ? displayOrders : ordersList;

  if (submitted) {
    return (
      <div className="flex flex-col items-center justify-center py-16 text-center max-w-xl mx-auto bg-white rounded-3xl p-8 border border-gray-100 shadow-sm font-sans">
        <div className="w-20 h-20 rounded-full flex items-center justify-center mb-4 shadow-inner bg-emerald-100 text-emerald-600">
          <CheckCircle size={44} />
        </div>
        <span className="text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wider mb-2 bg-emerald-100 text-emerald-800">
          Booking Completed &amp; Locked
        </span>
        <h2 className="text-2xl font-black text-gray-900 mb-1">
          Payment Disbursed &amp; Order Finalized!
        </h2>
        <p className="text-gray-600 text-sm mb-4">
          Device: <strong>{selectedOrder?.deviceName}</strong> (#{selectedOrder?.orderNumber})
        </p>

        {/* Payout Card */}
        <div className="w-full bg-gradient-to-r from-emerald-600 to-teal-700 text-white rounded-2xl p-5 mb-5 text-left shadow-lg">
          <div className="flex justify-between items-center mb-1">
            <span className="text-xs text-emerald-200 uppercase font-bold tracking-wider">
              Disbursed Payout to Customer
            </span>
            <span className="text-xs font-bold bg-white/20 px-2.5 py-0.5 rounded-md">Condition Score: {scorePercent}%</span>
          </div>
          <p className="text-3xl font-black">₹{finalPayoutToUser.toLocaleString('en-IN')}</p>
          <div className="mt-3 pt-2.5 border-t border-white/20 text-xs flex justify-between text-emerald-100">
            <span>Base Quoted: ₹{quotedPrice.toLocaleString('en-IN')}</span>
            <span>Net Adjustments: {totalAdditionAmount > 0 ? `+₹${totalAdditionAmount.toLocaleString('en-IN')} ` : ''}-₹{totalDeductionAmount.toLocaleString('en-IN')}</span>
          </div>
        </div>

        <div className="w-full p-4 bg-emerald-50 border border-emerald-300 rounded-2xl mb-6 text-left">
          <p className="text-xs font-bold text-emerald-900 flex items-center gap-1.5">
            <CheckCircle size={15} className="text-emerald-600 flex-shrink-0" />
            Customer Booking Page Updated with Final Price
          </p>
          <p className="text-xs text-emerald-800 mt-1">
            The customer can now see the exact disbursed amount of <strong>₹{finalPayoutToUser.toLocaleString('en-IN')}</strong> on their tracking &amp; order page.
          </p>
        </div>

        <div className="flex flex-wrap gap-3 w-full">
          {onBackToOrders && (
            <button
              onClick={onBackToOrders}
              className="flex-1 py-3 bg-primary text-white rounded-xl font-bold text-sm hover:bg-primary/90 shadow-md shadow-primary/20 transition-all cursor-pointer"
            >
              &larr; Back to Orders Management
            </button>
          )}
          <button
            onClick={() => {
              setSubmitted(false);
              setPayoutDisbursed(false);
              setCustomerConfirmedPrice(false);
              setInspectionResults({});
              setPhotos({});
              setIsCustomPrice(false);
              setCustomPriceOverride('');
            }}
            className="flex-1 py-3 bg-gray-100 text-gray-700 rounded-xl font-bold text-sm hover:bg-gray-200 transition-colors cursor-pointer"
          >
            Inspect Next Device
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6 w-full max-w-7xl mx-auto font-sans">
      {/* Page Title & Scan QR Bar */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-black text-gray-900 flex items-center gap-2">
            Device Physical Inspection
            {selectedOrder && (
              <span className="text-xs font-bold px-2.5 py-1 rounded-lg bg-emerald-50 text-emerald-700 border border-emerald-200">
                #{selectedOrder.orderNumber}
              </span>
            )}
          </h1>
          <p className="text-sm text-gray-500 mt-0.5">
            Scan customer QR code, evaluate device condition with live additions &amp; deductions, confirm with user, and disburse payment.
          </p>
        </div>

        <div className="flex items-center gap-2 flex-wrap">
          <button
            type="button"
            onClick={() => setIsQRScannerOpen(true)}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-700 hover:to-teal-700 text-white text-xs font-black shadow-md shadow-emerald-600/20 transition-all cursor-pointer"
          >
            <Scan size={14} />
            <span>Scan Customer QR Pass</span>
          </button>

          {onBackToOrders && (
            <button
              onClick={onBackToOrders}
              className="inline-flex items-center gap-1.5 px-4 py-2 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 text-xs font-bold text-gray-700 shadow-sm transition-all"
            >
              <ArrowLeft size={14} /> Back to Orders
            </button>
          )}
        </div>
      </div>

      {/* Device Picker Bar */}
      {ordersToShow.length > 0 && (
        <div className="flex gap-2.5 overflow-x-auto pb-2 scrollbar-hide">
          {ordersToShow.map((order) => {
            const isSelected = selectedOrder?.id === order.id;
            return (
              <button
                key={order.id}
                onClick={() => {
                  setSelectedOrder(order);
                  setInspectionResults({});
                  setPhotos({});
                  setIsCustomPrice(false);
                  setCustomerConfirmedPrice(false);
                }}
                className={`p-3 rounded-2xl text-left border flex-shrink-0 transition-all min-w-[210px] cursor-pointer ${
                  isSelected
                    ? 'border-emerald-600 bg-emerald-50/20 ring-2 ring-emerald-500/20 shadow-sm'
                    : 'border-gray-200 bg-white hover:border-gray-300'
                }`}
              >
                <div className="flex justify-between items-center mb-1">
                  <span className="text-[11px] font-bold text-gray-500">#{order.orderNumber}</span>
                  <span className={`text-[10px] font-bold px-1.5 py-0.5 rounded capitalize ${getOrderStatusColor(order.status)}`}>
                    {order.status.replace(/_/g, ' ')}
                  </span>
                </div>
                <p className="text-xs font-bold text-gray-900 truncate">{order.deviceName}</p>
                <p className="text-[11px] text-gray-400 mt-0.5">Quoted: ₹{order.quotedPrice.toLocaleString('en-IN')}</p>
              </button>
            );
          })}
        </div>
      )}

      {selectedOrder ? (
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          
          {/* Left Column (Diagnostic Checklist with Additions & Deductions) */}
          <div className="lg:col-span-7 space-y-5">
            
            {/* Device Info & Live Score */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
              <div className="flex items-center justify-between mb-3">
                <div>
                  <p className="text-base font-black text-gray-900">{selectedOrder.deviceName}</p>
                  <p className="text-xs text-gray-500 mt-0.5">
                    Customer: <strong>{selectedOrder.customerName}</strong> (<a href={`tel:${selectedOrder.customerPhone}`} className="text-primary hover:underline">{selectedOrder.customerPhone}</a>)
                  </p>
                </div>
                <div className="text-right">
                  <p className="text-xs font-bold text-gray-400 uppercase">Diagnostics Score</p>
                  <p className={`text-2xl font-black ${
                    scorePercent >= 80 ? 'text-emerald-600' : scorePercent >= 60 ? 'text-amber-600' : 'text-red-600'
                  }`}>
                    {scorePercent}%
                  </p>
                </div>
              </div>
              <div className="h-2.5 bg-gray-100 rounded-full overflow-hidden">
                <div
                  className={`h-full rounded-full transition-all duration-500 ${
                    scorePercent >= 80 ? 'bg-emerald-500' : scorePercent >= 60 ? 'bg-amber-500' : 'bg-red-500'
                  }`}
                  style={{ width: `${scorePercent}%` }}
                />
              </div>
            </div>

            {/* IMEI Verification Input */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
              <label className="text-xs font-bold text-gray-700 mb-1.5 block">
                Physical Device IMEI / Serial Number *
              </label>
              <input
                value={imei}
                onChange={e => setImei(e.target.value)}
                placeholder="Dial *#06# or inspect SIM tray (e.g. 352948102938472)"
                className="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary font-mono"
              />
            </div>

            {/* Inspection Checklist with Visible Additions and Deductions */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
              <div className="px-5 py-4 border-b border-gray-100 flex items-center justify-between bg-gray-50/50">
                <div>
                  <h3 className="font-bold text-gray-900 text-sm">Condition &amp; Defect Assessment</h3>
                  <p className="text-[11px] text-gray-400">Answer items: select Bonus (+) or Fail (-) to adjust live payout</p>
                </div>
                <span className="text-xs font-bold text-gray-500">
                  {passedCount} Passed · {failedCount} Deductions
                </span>
              </div>

              <div className="divide-y divide-gray-50">
                {inspectionItems.map((item) => {
                  const result = inspectionResults[item.id];
                  const isFailed = result === 'fail';
                  const isBonus = result === 'bonus';
                  const isPass = result === 'pass';
                  const deductionAmt = Math.round(quotedPrice * (item.deductionPct / 100));
                  const bonusAmt = item.bonusPct ? Math.round(quotedPrice * (item.bonusPct / 100)) : 0;

                  return (
                    <div
                      key={item.id}
                      className={`flex items-center justify-between p-4 transition-colors ${
                        isFailed ? 'bg-red-50/30' : isBonus ? 'bg-emerald-50/40' : isPass ? 'bg-emerald-50/15' : ''
                      }`}
                    >
                      <div className="pr-2 min-w-0 flex-1">
                        <div className="flex items-center gap-2 flex-wrap">
                          <p className="text-xs sm:text-sm font-bold text-gray-900">{item.label}</p>
                          {isFailed && (
                            <span className="text-[10px] font-black px-1.5 py-0.5 rounded bg-red-100 text-red-700">
                              -{item.deductionPct}% (-₹{deductionAmt.toLocaleString('en-IN')})
                            </span>
                          )}
                          {isBonus && (
                            <span className="text-[10px] font-black px-1.5 py-0.5 rounded bg-emerald-100 text-emerald-800">
                              +{item.bonusPct}% (+₹{bonusAmt.toLocaleString('en-IN')} Bonus)
                            </span>
                          )}
                        </div>
                        <p className="text-[11px] text-gray-400 truncate mt-0.5">{item.subtext}</p>
                      </div>

                      <div className="flex gap-1.5 flex-shrink-0">
                        {item.bonusPct ? (
                          <button
                            type="button"
                            onClick={() => handleResult(item.id, 'bonus')}
                            className={`flex items-center gap-1 px-2.5 py-1.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
                              isBonus
                                ? 'bg-emerald-700 text-white shadow-sm'
                                : 'bg-gray-100 text-emerald-700 hover:bg-emerald-100'
                            }`}
                            title={item.bonusLabel || 'Like-new condition bonus'}
                          >
                            <PlusCircle size={13} />
                            <span>Bonus (+{item.bonusPct}%)</span>
                          </button>
                        ) : null}

                        <button
                          type="button"
                          onClick={() => handleResult(item.id, 'pass')}
                          className={`flex items-center gap-1 px-3 py-1.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
                            isPass
                              ? 'bg-emerald-600 text-white shadow-sm'
                              : 'bg-gray-100 text-gray-600 hover:bg-emerald-100 hover:text-emerald-700'
                          }`}
                        >
                          <CheckCircle size={13} /> Pass
                        </button>

                        <button
                          type="button"
                          onClick={() => handleResult(item.id, 'fail')}
                          className={`flex items-center gap-1 px-3 py-1.5 rounded-xl text-xs font-bold transition-all cursor-pointer ${
                            isFailed
                              ? 'bg-red-600 text-white shadow-sm'
                              : 'bg-gray-100 text-gray-600 hover:bg-red-100 hover:text-red-700'
                          }`}
                        >
                          <XCircle size={13} /> Fail (-{item.deductionPct}%)
                        </button>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Notes */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5">
              <label className="text-xs font-bold text-gray-700 mb-1.5 block">Technician Verification Remarks</label>
              <textarea
                value={notes}
                onChange={e => setNotes(e.target.value)}
                placeholder="Add technician inspection notes (e.g. slight bezel scuff, clean camera lenses, customer accepted price)"
                rows={2}
                className="w-full px-3.5 py-2.5 rounded-xl border border-gray-200 text-xs focus:outline-none focus:ring-2 focus:ring-primary/20 resize-none"
              />
            </div>
          </div>

          {/* Right Column (Dynamic Payout, Customer Confirmation & Payment) */}
          <div className="lg:col-span-5 space-y-5">
            
            {/* EXACT LIVE PAYOUT CARD (Shows live additions & deductions) */}
            <div className="bg-gradient-to-br from-slate-950 via-slate-900 to-[#0a101f] text-white rounded-3xl p-6 shadow-xl border border-slate-800 relative overflow-hidden">
              <div className="absolute top-0 right-0 w-48 h-48 bg-primary/20 rounded-full blur-3xl pointer-events-none" />
              
              <div className="flex items-center justify-between pb-3 border-b border-slate-800 relative z-10">
                <span className="text-xs font-extrabold uppercase tracking-wider text-emerald-400 flex items-center gap-1.5">
                  <Sparkles size={14} /> Live Inspected Valuation
                </span>
                <span className="text-[11px] px-2.5 py-0.5 rounded-full bg-white/10 text-slate-300 font-bold">
                  {failedCount === 0 && bonusCount === 0 ? 'Pristine Base' : `${bonusCount} Bonuses · ${failedCount} Deductions`}
                </span>
              </div>

              {/* Exact Price Highlight */}
              <div className="my-4 relative z-10">
                <p className="text-xs text-slate-400 font-semibold">Exact Payout to Pay Customer:</p>
                <div className="flex items-baseline gap-2 mt-1">
                  <p className="text-3xl sm:text-4xl font-black text-white font-mono">
                    ₹{finalPayoutToUser.toLocaleString('en-IN')}
                  </p>
                  <span className="text-xs font-bold px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-300 border border-emerald-500/30">
                    Live Verified
                  </span>
                </div>
              </div>

              {/* Additions & Deductions Breakdown */}
              <div className="p-3.5 rounded-2xl bg-white/5 border border-white/10 space-y-2 text-xs relative z-10">
                <div className="flex justify-between text-slate-300">
                  <span>Initial Estimated Quote:</span>
                  <span className="font-bold text-white">₹{quotedPrice.toLocaleString('en-IN')}</span>
                </div>

                {bonusItems.length > 0 && (
                  <div className="pt-2 border-t border-white/10 space-y-1">
                    <p className="text-[11px] font-bold text-emerald-400 uppercase">Condition Bonuses (+{totalBonusPct}%):</p>
                    {bonusItems.map(item => (
                      <div key={item.id} className="flex justify-between text-[11px] text-slate-300">
                        <span>• {item.label}:</span>
                        <span className="text-emerald-400 font-bold">
                          +₹{Math.round(quotedPrice * ((item.bonusPct || 0) / 100)).toLocaleString('en-IN')} (+{item.bonusPct}%)
                        </span>
                      </div>
                    ))}
                  </div>
                )}

                {failedItems.length > 0 ? (
                  <div className="pt-2 border-t border-white/10 space-y-1">
                    <p className="text-[11px] font-bold text-red-400 uppercase">Condition Deductions (-{totalDeductionPct}%):</p>
                    {failedItems.map(item => (
                      <div key={item.id} className="flex justify-between text-[11px] text-slate-400">
                        <span>• {item.label}:</span>
                        <span className="text-red-400 font-bold">
                          -₹{Math.round(quotedPrice * (item.deductionPct / 100)).toLocaleString('en-IN')} (-{item.deductionPct}%)
                        </span>
                      </div>
                    ))}
                    <div className="flex justify-between text-xs font-bold text-red-300 pt-1 border-t border-white/10">
                      <span>Total Deductions:</span>
                      <span>-₹{totalDeductionAmount.toLocaleString('en-IN')}</span>
                    </div>
                  </div>
                ) : (
                  <p className="text-[11px] text-emerald-400 font-bold pt-1">
                    ✓ No deductions! All tested components are in verified condition.
                  </p>
                )}
              </div>

              {/* Custom Override Option */}
              <div className="mt-4 pt-3 border-t border-slate-800 text-xs relative z-10">
                <button
                  type="button"
                  onClick={() => setIsCustomPrice(!isCustomPrice)}
                  className="text-xs font-bold text-primary hover:underline flex items-center gap-1 mb-2 cursor-pointer"
                >
                  <SlidersHorizontal size={12} />
                  {isCustomPrice ? 'Use Algorithm Calculated Price' : 'Override with Custom Negotiated Payout'}
                </button>

                {isCustomPrice && (
                  <div className="flex items-center gap-2 mt-2">
                    <span className="text-slate-400">₹</span>
                    <input
                      type="number"
                      value={customPriceOverride}
                      onChange={(e) => setCustomPriceOverride(e.target.value)}
                      placeholder={calculatedExactPayout.toString()}
                      className="w-full px-3 py-1.5 rounded-xl bg-slate-800 border border-slate-700 text-white font-bold text-sm focus:outline-none focus:border-primary"
                    />
                  </div>
                )}
              </div>
            </div>

            {/* ─── TELL USER AMOUNT & USER CONFIRMATION SECTION ─── */}
            <div className="bg-white rounded-3xl border-2 border-emerald-300 p-5 space-y-4 shadow-sm">
              <div className="flex items-center gap-2 text-emerald-900">
                <UserCheck size={18} className="text-emerald-600" />
                <h4 className="font-black text-sm">Customer Payout Agreement</h4>
              </div>

              <div className="p-3.5 rounded-2xl bg-emerald-50 border border-emerald-200 text-xs space-y-1">
                <p className="text-slate-600">Tell the customer:</p>
                <p className="text-sm font-black text-emerald-900">
                  &ldquo;Based on the physical diagnosis, we can pay you ₹{finalPayoutToUser.toLocaleString('en-IN')} instantly.&rdquo;
                </p>
              </div>

              {/* Customer Agreement Checkbox */}
              <label className="flex items-start gap-3 p-3.5 bg-slate-50 rounded-2xl border border-slate-200 cursor-pointer hover:bg-slate-100 transition-colors">
                <input
                  type="checkbox"
                  checked={customerConfirmedPrice}
                  onChange={e => setCustomerConfirmedPrice(e.target.checked)}
                  className="mt-0.5 w-4 h-4 text-emerald-600 rounded focus:ring-emerald-500"
                />
                <div className="text-xs">
                  <p className="font-black text-slate-900">Customer confirmed &amp; agreed to payout</p>
                  <p className="text-slate-500 text-[11px] mt-0.5">
                    Customer accepts ₹{finalPayoutToUser.toLocaleString('en-IN')} via instant transfer or cash handover.
                  </p>
                </div>
              </label>

              {/* Payment Mode Selection */}
              {customerConfirmedPrice && (
                <div className="space-y-3 pt-2 border-t border-slate-100 animate-in fade-in">
                  <label className="block text-xs font-bold text-slate-700">Payout Transfer Mode</label>
                  <div className="grid grid-cols-3 gap-2">
                    {[
                      { id: 'upi', label: 'UPI / GPay' },
                      { id: 'imps', label: 'Bank IMPS' },
                      { id: 'cash', label: 'Cash Spot' },
                    ].map(m => (
                      <button
                        key={m.id}
                        type="button"
                        onClick={() => setPayoutMode(m.id as any)}
                        className={`py-2 px-3 rounded-xl border text-xs font-bold transition-all cursor-pointer ${
                          payoutMode === m.id
                            ? 'border-emerald-600 bg-emerald-50 text-emerald-800'
                            : 'border-slate-200 hover:border-slate-300'
                        }`}
                      >
                        {m.label}
                      </button>
                    ))}
                  </div>

                  <div>
                    <input
                      type="text"
                      placeholder={payoutMode === 'cash' ? 'Cash receipt notes (optional)' : 'Customer UPI ID / Account / UTR'}
                      value={payoutUpiOrRef}
                      onChange={e => setPayoutUpiOrRef(e.target.value)}
                      className="w-full px-3 py-2 text-xs border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-emerald-500/20"
                    />
                  </div>
                </div>
              )}

              {/* Pay & Close Booking Button */}
              <button
                type="button"
                disabled={!customerConfirmedPrice || isProcessingPayout}
                onClick={handleInstantPayout}
                className="w-full py-4 bg-emerald-600 hover:bg-emerald-700 disabled:opacity-40 disabled:cursor-not-allowed text-white rounded-2xl font-black text-sm shadow-xl shadow-emerald-600/25 transition-all flex items-center justify-center gap-2 cursor-pointer"
              >
                {isProcessingPayout ? (
                  <span className="flex items-center gap-2">
                    <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    Disbursing Payment &amp; Closing Booking...
                  </span>
                ) : (
                  <>
                    <CreditCard size={18} />
                    <span>Pay ₹{finalPayoutToUser.toLocaleString('en-IN')} &amp; Close Booking</span>
                  </>
                )}
              </button>
              <p className="text-[11px] text-slate-500 text-center">
                Closing the booking shifts order to Completed, records payment, and immediately reveals the final paid price on customer&apos;s page.
              </p>
            </div>

            {/* Device Photos Upload Section */}
            <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="font-bold text-gray-900 text-sm">Device Inspection Photos</h3>
                  <p className="text-[11px] text-gray-400">Tap box to capture or upload photo proof</p>
                </div>
                <span className="text-xs font-bold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-md">
                  {Object.keys(photos).length} / {photoAngles.length} Photos
                </span>
              </div>

              <input
                type="file"
                ref={multiFileInputRef}
                multiple
                accept="image/*"
                className="hidden"
                onChange={handleMultiUpload}
              />

              <div className="grid grid-cols-2 gap-2.5">
                {photoAngles.map((angle) => {
                  const hasPhoto = !!photos[angle.id];

                  return (
                    <div
                      key={angle.id}
                      onClick={() => {
                        if (!hasPhoto) {
                          fileInputRefs.current[angle.id]?.click();
                        } else {
                          setActivePhotoModal({ label: angle.label, url: photos[angle.id] });
                        }
                      }}
                      className={`relative aspect-square rounded-2xl border-2 transition-all cursor-pointer overflow-hidden group flex flex-col items-center justify-center p-2 text-center ${
                        hasPhoto
                          ? 'border-emerald-500 bg-black/5 shadow-sm'
                          : 'border-dashed border-gray-200 hover:border-emerald-500 hover:bg-emerald-50/10'
                      }`}
                      title={hasPhoto ? 'Click to inspect photo' : `Click to take or upload ${angle.label}`}
                    >
                      <input
                        type="file"
                        accept="image/*"
                        ref={(el) => { fileInputRefs.current[angle.id] = el; }}
                        onChange={(e) => handlePhotoCapture(angle.id, e)}
                        className="hidden"
                      />

                      {hasPhoto ? (
                        <>
                          <img
                            src={photos[angle.id]}
                            alt={angle.label}
                            className="w-full h-full object-cover rounded-xl"
                          />
                          <span className="absolute top-2 right-2 text-[10px] font-bold bg-emerald-600 text-white px-1.5 py-0.5 rounded-md flex items-center gap-0.5 shadow">
                            <CheckCircle2 size={10} /> Captured
                          </span>
                        </>
                      ) : (
                        <>
                          <div className="w-10 h-10 rounded-xl bg-gray-100 group-hover:bg-emerald-50 group-hover:text-emerald-700 text-gray-400 flex items-center justify-center transition-colors mb-1">
                            <Camera size={20} />
                          </div>
                          <span className="text-[11px] font-bold text-gray-700 group-hover:text-emerald-700 transition-colors leading-tight">
                            {angle.label}
                          </span>
                          <span className="text-[9px] text-gray-400 mt-0.5">Tap to Capture</span>
                        </>
                      )}
                    </div>
                  );
                })}
              </div>

              <button
                type="button"
                onClick={() => multiFileInputRef.current?.click()}
                className="w-full flex items-center justify-center gap-2 py-2.5 rounded-xl border border-gray-200 bg-gray-50 hover:bg-gray-100 text-xs font-bold text-gray-700 transition-colors shadow-sm cursor-pointer"
              >
                <Upload size={14} /> Upload Multiple Photos at Once
              </button>
            </div>
          </div>

        </div>
      ) : (
        <div className="text-center py-16 bg-white rounded-3xl border border-gray-100 shadow-sm">
          <ClipboardCheck size={48} className="mx-auto text-gray-300 mb-3" />
          <p className="text-gray-700 font-bold text-base">No device selected for inspection</p>
          <p className="text-xs text-gray-400 mt-1">Please scan customer QR code or select an assigned order from above</p>
          <button
            type="button"
            onClick={() => setIsQRScannerOpen(true)}
            className="mt-4 inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-emerald-600 text-white text-xs font-black shadow-md cursor-pointer"
          >
            <Scan size={14} /> Scan Customer QR Pass
          </button>
        </div>
      )}

      {/* Photo Preview Lightbox Modal */}
      {activePhotoModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm p-4 animate-in fade-in-50">
          <div className="bg-white rounded-3xl max-w-2xl w-full overflow-hidden shadow-2xl flex flex-col border border-gray-100">
            <div className="p-4 border-b border-gray-100 flex items-center justify-between bg-gray-50">
              <h4 className="font-bold text-sm text-gray-900">{activePhotoModal.label}</h4>
              <button
                onClick={() => setActivePhotoModal(null)}
                className="w-8 h-8 rounded-full bg-gray-200 hover:bg-gray-300 flex items-center justify-center text-gray-600 transition-colors"
              >
                <X size={16} />
              </button>
            </div>
            <div className="p-4 bg-black flex items-center justify-center max-h-[70vh] overflow-hidden">
              <img
                src={activePhotoModal.url}
                alt={activePhotoModal.label}
                className="max-h-full max-w-full object-contain rounded-xl"
              />
            </div>
            <div className="p-4 bg-gray-50 flex justify-end">
              <button
                onClick={() => setActivePhotoModal(null)}
                className="px-5 py-2 bg-gray-900 text-white rounded-xl text-xs font-bold hover:bg-black"
              >
                Close Preview
              </button>
            </div>
          </div>
        </div>
      )}

      {/* QR Code Scanner Modal */}
      <QRScannerModal
        isOpen={isQRScannerOpen}
        onClose={() => setIsQRScannerOpen(false)}
        onScanSuccess={(detectedCode) => {
          setIsQRScannerOpen(false);
          const match = ordersList.find(o =>
            o.orderNumber?.toLowerCase() === detectedCode.toLowerCase() ||
            o.id === detectedCode
          );
          if (match) {
            setSelectedOrder(match);
            if (typeof window !== 'undefined') {
              localStorage.setItem('casmik_active_inspection_id', match.id);
            }
          } else {
            // Check global orders
            try {
              const globalSaved = localStorage.getItem('casmik_orders_v1');
              if (globalSaved) {
                const list = JSON.parse(globalSaved);
                const found = list.find((o: any) =>
                  o.orderNumber?.toLowerCase() === detectedCode.toLowerCase() ||
                  o.id === detectedCode
                );
                if (found) {
                  setSelectedOrder(found);
                  if (typeof window !== 'undefined') {
                    localStorage.setItem('casmik_active_inspection_id', found.id);
                  }
                  return;
                }
              }
            } catch {}
          }
        }}
        title="Scan Customer Booking QR Pass"
        subtitle="Point camera at customer booking QR code to launch device inspection"
      />
    </div>
  );
}
