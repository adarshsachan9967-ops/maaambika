import '../models/admin_order.dart';
import '../models/partner_store.dart';
import '../models/promo_coupon.dart';
import '../models/overview_metrics.dart';
import '../models/audit_activity.dart';

class FallbackAdminData {
  static const OverviewMetrics defaultMetrics = OverviewMetrics(
    todayGmv: '₹24,85,920',
    gmvGrowth: '+18.4% vs yday',
    totalOrders: '142 Orders',
    pickupsCount: '86 Pickups',
    activeFleet: '38 Fleet Active',
    onTimeRate: '96% on-time',
    netProfit: '₹3.4L Profit',
    profitMargin: '13.8% Margin',
    pendingApprovals: 3,
  );

  static final List<AdminOrder> defaultOrders = [
    const AdminOrder(
      id: 'ORD-9831',
      type: 'Sell Phone',
      customer: 'Ananya Verma',
      phone: '+91 98765 43210',
      device: 'iPhone 14 Pro 128GB Deep Purple',
      quote: '₹48,500',
      assignedRider: 'Rahul Sharma (RD-8842)',
      status: 'Out for Pickup',
      date: 'Today, 11:30 AM',
      hub: 'South Delhi Hub',
    ),
    const AdminOrder(
      id: 'ORD-9832',
      type: 'Buy Refurbished',
      customer: 'Vikram Mehra',
      phone: '+91 98112 34567',
      device: 'MacBook Pro M2 512GB Space Gray',
      quote: '₹89,999',
      assignedRider: 'Praveen Kumar (RD-4412)',
      status: 'Processing',
      date: 'Today, 10:15 AM',
      hub: 'Noida Central Hub',
    ),
    const AdminOrder(
      id: 'ORD-9833',
      type: 'Screen Repair',
      customer: 'Sneha Nair',
      phone: '+91 99001 22334',
      device: 'Samsung S22 Ultra Phantom Black',
      quote: '₹8,499',
      assignedRider: 'Unassigned',
      status: 'Pending Dispatch',
      date: 'Today, 09:45 AM',
      hub: 'Indiranagar Lab Hub',
    ),
    const AdminOrder(
      id: 'ORD-9828',
      type: 'Sell Laptop',
      customer: 'Arun Kapoor',
      phone: '+91 97712 99881',
      device: 'Dell XPS 15 16GB / 512GB SSD',
      quote: '₹54,000',
      assignedRider: 'Amit Joshi (RD-1092)',
      status: 'Completed',
      date: 'Yesterday, 04:20 PM',
      hub: 'Gurgaon Cyber Hub',
    ),
  ];

  static final List<PartnerStore> defaultPartners = [
    const PartnerStore(
      name: 'Croma Mobile Exchange Desk',
      location: 'South Extension, New Delhi',
      owner: 'Rajesh Gupta',
      margin: '8.5%',
      devicesSold: '142 units',
      kyc: 'Approved',
      active: true,
    ),
    const PartnerStore(
      name: 'Vijay Sales Device Counter',
      location: 'Koramangala, Bengaluru',
      owner: 'Kiran Patel',
      margin: '9.0%',
      devicesSold: '98 units',
      kyc: 'Approved',
      active: true,
    ),
    const PartnerStore(
      name: 'Sangeetha Tech Corner',
      location: 'Bandra West, Mumbai',
      owner: 'Farhan Khan',
      margin: '8.0%',
      devicesSold: '64 units',
      kyc: 'Pending Review',
      active: false,
    ),
  ];

  static final List<PromoCoupon> defaultCoupons = [
    const PromoCoupon(
      code: 'AMBIKA1000',
      description: 'Flat ₹1,000 Off on Refurbished Laptops & Phones',
      usage: 'Used 418 times',
      status: 'Active',
    ),
    const PromoCoupon(
      code: 'SELLBONUS500',
      description: 'Get Extra ₹500 trade-in credit when selling phone',
      usage: 'Used 892 times',
      status: 'Active',
    ),
    const PromoCoupon(
      code: 'FREEDELIVERY',
      description: 'Zero pickup fee for first-time doorstep inspections',
      usage: 'Used 1,240 times',
      status: 'Active',
    ),
  ];

  static final List<AuditActivity> defaultActivities = [
    const AuditActivity(
      title: 'New Order Placed',
      description: 'ORD-9834: iPhone 15 Pro Max 256GB - Quote ₹68,000',
      time: '2 mins ago',
      type: 'order',
    ),
    const AuditActivity(
      title: 'Rider Assigned',
      description: 'Rahul Sharma assigned to ORD-9831 (Pickup in 15 mins)',
      time: '8 mins ago',
      type: 'rider',
    ),
    const AuditActivity(
      title: 'Payout Completed',
      description: '₹48,500 transferred to Ananya Verma via IMPS',
      time: '24 mins ago',
      type: 'payout',
    ),
    const AuditActivity(
      title: 'Price Overwrite',
      description: 'Manager adjusted trade-in value on ORD-9825 (+₹1,200)',
      time: '1 hour ago',
      type: 'pricing',
    ),
  ];
}
