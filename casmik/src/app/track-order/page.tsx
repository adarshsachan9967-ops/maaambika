'use client';
import React, { useState, useEffect, useCallback } from 'react';
import { createClient } from '@/lib/supabase/client';
import { getOrderStatusLabel, getOrderStatusColor, getTypeColor } from '@/lib/casmikData';
import type { OrderStatus } from '@/lib/casmikData';
import { Package, CheckCircle, Clock, Truck, Search, Wrench, CreditCard, MapPin, Phone, X, Wifi, WifiOff, QrCode, ShieldCheck } from 'lucide-react';
import BookingQRCode from '@/components/BookingQRCode';

interface LiveOrder {
  id: string;
  order_number: string;
  order_type: string;
  status: string;
  customer_name: string;
  customer_phone: string;
  device_name: string;
  quoted_price: number;
  final_price: number;
  partner_name: string | null;
  delivery_agent_name: string | null;
  pickup_date: string | null;
  pickup_slot: string | null;
  city: string | null;
  pin_code: string | null;
  payment_status: string;
  inspection_score: number | null;
  notes: string | null;
  updated_at: string;
}

const STATUS_STEPS = [
  { key: 'created', label: 'Order Created', icon: Package, desc: 'Your order has been placed' },
  { key: 'assigned', label: 'Partner Assigned', icon: CheckCircle, desc: 'A partner has been assigned' },
  { key: 'accepted', label: 'Partner Accepted', icon: CheckCircle, desc: 'Partner confirmed your order' },
  { key: 'pickup_scheduled', label: 'Pickup Scheduled', icon: Clock, desc: 'Pickup agent is on the way' },
  { key: 'picked_up', label: 'Device Picked Up', icon: Truck, desc: 'Your device has been collected' },
  { key: 'inspection', label: 'Under Inspection', icon: Search, desc: 'Device is being inspected' },
  { key: 'inspection_completed', label: 'Inspection Done', icon: CheckCircle, desc: 'Inspection completed' },
  { key: 'payment_processing', label: 'Payment Processing', icon: CreditCard, desc: 'Payment is being processed' },
  { key: 'paid', label: 'Payment Done', icon: CheckCircle, desc: 'Payment sent to your account' },
  { key: 'completed', label: 'Completed', icon: CheckCircle, desc: 'Order successfully completed' },
];

const REPAIR_STEPS = [
  { key: 'created', label: 'Order Created', icon: Package, desc: 'Your repair order is placed' },
  { key: 'assigned', label: 'Partner Assigned', icon: CheckCircle, desc: 'Repair partner assigned' },
  { key: 'accepted', label: 'Accepted', icon: CheckCircle, desc: 'Partner confirmed your repair' },
  { key: 'pickup_scheduled', label: 'Pickup Scheduled', icon: Clock, desc: 'Pickup agent is on the way' },
  { key: 'picked_up', label: 'Device Picked Up', icon: Truck, desc: 'Device collected for repair' },
  { key: 'inspection', label: 'Under Repair', icon: Wrench, desc: 'Your device is being repaired' },
  { key: 'completed', label: 'Completed', icon: CheckCircle, desc: 'Repair done, device returned' },
];

export default function CustomerOrderTracker() {
  const [orders, setOrders] = useState<LiveOrder[]>([]);
  const [loading, setLoading] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const [searchPhone, setSearchPhone] = useState('');
  const [searchInput, setSearchInput] = useState('');
  const [selectedOrder, setSelectedOrder] = useState<LiveOrder | null>(null);
  const [qrModalOrder, setQrModalOrder] = useState<LiveOrder | null>(null);
  const [recentUpdate, setRecentUpdate] = useState<string | null>(null);
  const supabase = createClient();

  const getLocalMatchingOrders = (query: string): LiveOrder[] => {
    if (typeof window === 'undefined') return [];
    try {
      const saved = localStorage.getItem('casmik_orders_v1');
      if (saved) {
        const list = JSON.parse(saved);
        if (Array.isArray(list)) {
          const q = query.toLowerCase().trim();
          return list
            .filter((o: any) =>
              o.customerPhone?.includes(q) ||
              o.orderNumber?.toLowerCase().includes(q) ||
              o.id?.toLowerCase().includes(q)
            )
            .map((o: any) => ({
              id: o.id,
              order_number: o.orderNumber,
              order_type: o.type,
              status: o.status,
              customer_name: o.customerName,
              customer_phone: o.customerPhone,
              device_name: o.deviceName,
              quoted_price: o.quotedPrice || 0,
              final_price: o.finalPrice || 0,
              partner_name: o.partnerName || null,
              delivery_agent_name: o.deliveryAgentName || null,
              pickup_date: o.pickupDate || null,
              pickup_slot: o.pickupSlot || null,
              city: o.city || null,
              pin_code: o.pinCode || null,
              payment_status: o.paymentStatus || 'pending',
              inspection_score: o.inspectionScore || null,
              notes: o.notes || null,
              updated_at: o.updatedAt || new Date().toISOString(),
            }));
        }
      }
    } catch {}
    return [];
  };

  const fetchOrders = useCallback(async (query: string) => {
    if (!query) return;
    setLoading(true);
    const localMatches = getLocalMatchingOrders(query);

    try {
      const isPhoneNumber = /^\d+$/.test(query.trim());
      let queryBuilder = supabase.from('orders').select('*');

      if (isPhoneNumber) {
        queryBuilder = queryBuilder.eq('customer_phone', query.trim());
      } else {
        queryBuilder = queryBuilder.or(`order_number.ilike.%${query.trim()}%,id.eq.${query.trim()}`);
      }

      const { data, error } = await queryBuilder.order('created_at', { ascending: false });
      if (!error && data && data.length > 0) {
        // Merge remote and local without duplicates
        const map = new Map();
        data.forEach(item => map.set(item.id, item));
        localMatches.forEach(item => {
          if (!map.has(item.id)) map.set(item.id, item);
        });
        setOrders(Array.from(map.values()));
        return;
      }
    } catch (err: any) {
      console.log('Customer orders error:', err.message);
    } finally {
      setLoading(false);
    }

    if (localMatches.length > 0) {
      setOrders(localMatches);
    }
  }, [supabase]);

  // Handle URL params on mount
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const params = new URLSearchParams(window.location.search);
      const paramOrderId = params.get('orderId');
      const paramPhone = params.get('phone');
      if (paramOrderId) {
        setSearchInput(paramOrderId);
        fetchOrders(paramOrderId);
      } else if (paramPhone) {
        setSearchPhone(paramPhone);
        setSearchInput(paramPhone);
        fetchOrders(paramPhone);
      }
    }
  }, [fetchOrders]);

  useEffect(() => {
    if (!searchPhone) return;

    const channel = supabase
      .channel(`customer-orders-${searchPhone}`)
      .on('postgres_changes', {
        event: '*', schema: 'public', table: 'orders',
        filter: `customer_phone=eq.${searchPhone}`
      }, (payload) => {
        setRecentUpdate(payload.new && 'order_number' in payload.new ? (payload.new as any).order_number : null);
        setTimeout(() => setRecentUpdate(null), 4000);

        if (payload.eventType === 'UPDATE') {
          setOrders(prev => prev.map(o => o.id === (payload.new as LiveOrder).id ? payload.new as LiveOrder : o));
          setSelectedOrder(prev => prev?.id === (payload.new as LiveOrder).id ? payload.new as LiveOrder : prev);
        } else if (payload.eventType === 'INSERT') {
          setOrders(prev => [payload.new as LiveOrder, ...prev]);
        }
      })
      .subscribe(status => setIsConnected(status === 'SUBSCRIBED'));

    return () => { supabase.removeChannel(channel); };
  }, [searchPhone, supabase]);

  const handleSearch = () => {
    if (searchInput.trim().length >= 3) {
      if (/^\d{10,}$/.test(searchInput.trim())) {
        setSearchPhone(searchInput.trim());
      }
      fetchOrders(searchInput.trim());
    }
  };

  const getSteps = (orderType: string) => orderType === 'repair' ? REPAIR_STEPS : STATUS_STEPS;

  const getStepIndex = (steps: typeof STATUS_STEPS, status: string) =>
    steps.findIndex(s => s.key === status);

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-blue-50/30 py-8 px-4">
      <div className="max-w-2xl mx-auto">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center mx-auto mb-4">
            <Package size={32} className="text-primary" />
          </div>
          <h1 className="text-2xl font-black text-gray-900 mb-2">Track Your Order &amp; Inspection</h1>
          <p className="text-gray-500 text-sm">Enter your phone number or Order ID (e.g. CSM-2024-XXX) to see live status &amp; QR pass</p>
        </div>

        {/* Search */}
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-6">
          <div className="flex gap-3">
            <div className="relative flex-1">
              <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                value={searchInput}
                onChange={e => setSearchInput(e.target.value)}
                onKeyDown={e => e.key === 'Enter' && handleSearch()}
                placeholder="Enter mobile number or Order ID (e.g. CSM-2024-123)"
                className="w-full pl-10 pr-4 py-3 rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary/30"
              />
            </div>
            <button onClick={handleSearch}
              className="px-5 py-3 bg-primary text-white rounded-xl text-sm font-bold hover:bg-primary/90 transition-colors cursor-pointer">
              Track
            </button>
          </div>
          {searchPhone && (
            <div className="flex items-center gap-2 mt-3 text-xs">
              <span className={`inline-flex items-center gap-1 font-bold px-2 py-0.5 rounded-full ${
                isConnected ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'
              }`}>
                {isConnected ? <Wifi size={10} /> : <WifiOff size={10} />}
                {isConnected ? 'Live updates active' : 'Connecting...'}
              </span>
              <span className="text-gray-400">Tracking: {searchPhone}</span>
            </div>
          )}
        </div>

        {/* Recent Update Banner */}
        {recentUpdate && (
          <div className="bg-green-50 border border-green-200 rounded-xl p-3 mb-4 flex items-center gap-2 text-sm text-green-700 font-semibold animate-pulse">
            <div className="w-2 h-2 rounded-full bg-green-500" />
            Order {recentUpdate} status just updated!
          </div>
        )}

        {/* Orders */}
        {searchInput && !loading && (
          <div className="space-y-4">
            {orders.length === 0 ? (
              <div className="bg-white rounded-2xl border border-gray-100 p-12 text-center">
                <p className="text-4xl mb-3">📭</p>
                <p className="font-bold text-gray-700 mb-1">No orders found</p>
                <p className="text-sm text-gray-400">No orders found for &ldquo;{searchInput}&rdquo;</p>
              </div>
            ) : (
              orders.map(order => {
                const steps = getSteps(order.order_type);
                const currentIdx = getStepIndex(steps, order.status);
                const isTerminal = ['completed', 'cancelled', 'rejected'].includes(order.status);
                const isSell = order.order_type === 'sell';
                const isCompleted = order.status === 'completed' || order.payment_status === 'paid';

                return (
                  <div key={order.id}
                    className={`bg-white rounded-2xl border shadow-sm overflow-hidden transition-all ${
                      recentUpdate === order.order_number ? 'border-green-300 ring-2 ring-green-100' : 'border-gray-100'
                    }`}>
                    <div className="p-5">
                      {/* Order Header */}
                      <div className="flex items-start justify-between mb-4">
                        <div>
                          <div className="flex items-center gap-2 mb-1">
                            <span className="text-xs font-black text-gray-500">#{order.order_number}</span>
                            <span className={`text-xs font-bold px-2 py-0.5 rounded-lg capitalize ${getTypeColor(order.order_type as any)}`}>
                              {order.order_type}
                            </span>
                            {recentUpdate === order.order_number && (
                              <span className="text-xs font-bold text-green-600 bg-green-50 px-2 py-0.5 rounded-lg animate-pulse">● Updated</span>
                            )}
                          </div>
                          <p className="font-bold text-gray-900">{order.device_name}</p>
                          <p className="text-xs text-gray-500 mt-0.5">{order.city || 'Delhi NCR'} · {order.pickup_date || 'Scheduled'}</p>
                        </div>
                        <div className="text-right">
                          {isSell && !isCompleted ? (
                            <div>
                              <p className="text-lg font-black text-slate-900 font-mono tracking-wider">₹ ****</p>
                              <span className="text-[10px] font-bold text-amber-600 bg-amber-50 px-2 py-0.5 rounded-md border border-amber-200 block mt-0.5">
                                Pending Inspection
                              </span>
                            </div>
                          ) : (
                            <div>
                              <p className="text-lg font-black text-emerald-600 font-tabular">
                                ₹{(order.final_price || order.quoted_price || 0).toLocaleString('en-IN')}
                              </p>
                              {isCompleted && (
                                <span className="text-[10px] font-black text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-md border border-emerald-200 block mt-0.5">
                                  ✅ Paid on Spot
                                </span>
                              )}
                            </div>
                          )}
                          <span className={`text-xs font-semibold px-2 py-0.5 rounded-lg mt-1 inline-block ${getOrderStatusColor(order.status as OrderStatus)}`}>
                            {getOrderStatusLabel(order.status as OrderStatus)}
                          </span>
                        </div>
                      </div>

                      {/* Prominent Inspection QR Action */}
                      <div className="mb-4 p-3 rounded-2xl bg-gradient-to-r from-emerald-50 to-teal-50 border border-emerald-200 flex items-center justify-between gap-3">
                        <div className="flex items-center gap-2.5">
                          <div className="w-9 h-9 rounded-xl bg-emerald-600 text-white flex items-center justify-center shadow-xs">
                            <QrCode size={18} />
                          </div>
                          <div>
                            <p className="text-xs font-black text-emerald-900">Doorstep Inspection Pass</p>
                            <p className="text-[11px] text-emerald-700">Show QR code to technician to begin</p>
                          </div>
                        </div>
                        <button
                          type="button"
                          onClick={() => setQrModalOrder(order)}
                          className="px-3.5 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold shadow-xs transition-all cursor-pointer whitespace-nowrap"
                        >
                          View QR Pass
                        </button>
                      </div>

                      {/* Progress Steps */}
                      <div className="space-y-2">
                        {steps.map((step, idx) => {
                          const Icon = step.icon;
                          const isDone = idx < currentIdx || (isTerminal && order.status === 'completed');
                          const isCurrent = idx === currentIdx;
                          return (
                            <div key={step.key} className={`flex items-center gap-3 py-1.5 px-3 rounded-xl transition-all ${
                              isCurrent ? 'bg-primary/5 border border-primary/20' : isDone ? 'opacity-60' : 'opacity-30'
                            }`}>
                              <div className={`w-7 h-7 rounded-full flex items-center justify-center flex-shrink-0 ${
                                isDone ? 'bg-green-500 text-white' : isCurrent ? 'bg-primary text-white ring-2 ring-primary/30' : 'bg-gray-100 text-gray-400'
                              }`}>
                                <Icon size={13} />
                              </div>
                              <div className="flex-1 min-w-0">
                                <p className={`text-xs font-bold ${isCurrent ? 'text-primary' : isDone ? 'text-green-700' : 'text-gray-400'}`}>
                                  {step.label}
                                </p>
                                {isCurrent && <p className="text-xs text-gray-500">{step.desc}</p>}
                              </div>
                              {isCurrent && <div className="w-2 h-2 rounded-full bg-primary animate-pulse flex-shrink-0" />}
                            </div>
                          );
                        })}
                      </div>

                      {/* Partner/Agent Info */}
                      <div className="mt-4 pt-4 border-t border-gray-100 flex items-center justify-between text-xs">
                        <div className="flex items-center gap-2">
                          {order.partner_name && (
                            <div className="flex items-center gap-1.5 text-gray-600">
                              <MapPin size={12} className="text-primary" />
                              <span className="font-semibold">{order.partner_name}</span>
                            </div>
                          )}
                          {order.delivery_agent_name && (
                            <div className="flex items-center gap-1.5 text-gray-600">
                              <Truck size={12} className="text-blue-500" />
                              <span className="font-semibold">{order.delivery_agent_name}</span>
                            </div>
                          )}
                        </div>

                        <button
                          type="button"
                          onClick={() => setSelectedOrder(order)}
                          className="px-3 py-1 rounded-lg bg-gray-100 hover:bg-gray-200 text-gray-700 text-xs font-bold transition-colors cursor-pointer"
                        >
                          View Details
                        </button>
                      </div>
                    </div>
                  </div>
                );
              })
            )}
          </div>
        )}

        {!searchInput && (
          <div className="text-center py-12 text-gray-400">
            <p className="text-5xl mb-4">📦</p>
            <p className="font-semibold text-gray-500">Enter your phone number or Order ID above to track your orders</p>
            <p className="text-sm mt-1">Real-time updates and doorstep inspection QR code will appear automatically</p>
          </div>
        )}
      </div>

      {/* QR Code Modal */}
      {qrModalOrder && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/70 backdrop-blur-xs">
          <div className="relative bg-white rounded-3xl shadow-2xl w-full max-w-sm p-6 z-10 animate-in fade-in zoom-in-95">
            <button
              onClick={() => setQrModalOrder(null)}
              className="absolute top-4 right-4 text-slate-400 hover:text-slate-700 p-1.5 rounded-full hover:bg-slate-100 transition-colors"
            >
              <X size={18} />
            </button>
            <div className="mb-2">
              <BookingQRCode
                orderNumber={qrModalOrder.order_number}
                orderId={qrModalOrder.id}
                deviceName={qrModalOrder.device_name}
                customerName={qrModalOrder.customer_name}
              />
            </div>
            <button
              onClick={() => setQrModalOrder(null)}
              className="w-full py-2.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold transition-colors cursor-pointer"
            >
              Done
            </button>
          </div>
        </div>
      )}

      {/* Order Detail Modal */}
      {selectedOrder && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setSelectedOrder(null)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 z-10 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between mb-5">
              <h3 className="text-lg font-black text-gray-900">#{selectedOrder.order_number}</h3>
              <button onClick={() => setSelectedOrder(null)} className="p-2 rounded-xl hover:bg-gray-100"><X size={18} /></button>
            </div>
            <div className="space-y-4">
              <div className="flex gap-2">
                <span className={`text-xs font-bold px-2 py-1 rounded-lg capitalize ${getTypeColor(selectedOrder.order_type as any)}`}>{selectedOrder.order_type}</span>
                <span className={`text-xs font-semibold px-2 py-1 rounded-lg ${getOrderStatusColor(selectedOrder.status as OrderStatus)}`}>{getOrderStatusLabel(selectedOrder.status as OrderStatus)}</span>
              </div>
              <div className="bg-gray-50 rounded-xl p-4">
                <p className="text-xs font-bold text-gray-500 mb-2">Device</p>
                <p className="font-bold text-gray-900">{selectedOrder.device_name}</p>
              </div>

              {/* QR Code Embedded in Details */}
              <div className="p-2 bg-slate-50 rounded-2xl border border-slate-200">
                <BookingQRCode
                  orderNumber={selectedOrder.order_number}
                  orderId={selectedOrder.id}
                  deviceName={selectedOrder.device_name}
                  customerName={selectedOrder.customer_name}
                  size={160}
                  showDetails={false}
                  showDownload={true}
                />
              </div>

              <div className="bg-green-50 rounded-xl p-4">
                <p className="text-xs font-bold text-gray-500 mb-2">Pricing Status</p>
                {selectedOrder.order_type === 'sell' && selectedOrder.status !== 'completed' && selectedOrder.payment_status !== 'paid' ? (
                  <div className="space-y-1">
                    <div className="flex justify-between">
                      <span className="text-sm text-gray-600">Quoted Valuation</span>
                      <span className="font-bold text-gray-900 font-mono tracking-wider">₹ ****</span>
                    </div>
                    <p className="text-xs text-amber-700 bg-amber-100/60 p-2 rounded-lg mt-2">
                      🔒 Exact final price calculated on doorstep physical inspection &amp; transferred instantly to your UPI/Bank.
                    </p>
                  </div>
                ) : (
                  <div className="space-y-1">
                    <div className="flex justify-between">
                      <span className="text-sm text-gray-600">Final Paid Price</span>
                      <span className="font-black text-emerald-700 text-lg">
                        ₹{(selectedOrder.final_price || selectedOrder.quoted_price || 0).toLocaleString('en-IN')}
                      </span>
                    </div>
                    <p className="text-xs text-emerald-700 font-semibold">
                      ✅ Disbursed &amp; Order Finalized
                    </p>
                  </div>
                )}
              </div>
              {selectedOrder.pickup_date && (
                <div className="bg-blue-50 rounded-xl p-4">
                  <p className="text-xs font-bold text-gray-500 mb-1">Pickup Schedule</p>
                  <p className="text-sm font-bold text-gray-900">📅 {selectedOrder.pickup_date}</p>
                  {selectedOrder.pickup_slot && <p className="text-xs text-gray-500">🕐 {selectedOrder.pickup_slot}</p>}
                </div>
              )}
              {selectedOrder.inspection_score && (
                <div className="bg-purple-50 rounded-xl p-4">
                  <p className="text-xs font-bold text-gray-500 mb-1">Inspection Score</p>
                  <p className="text-2xl font-black text-purple-700">{selectedOrder.inspection_score}/100</p>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
