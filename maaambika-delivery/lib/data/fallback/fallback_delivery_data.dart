import '../models/delivery_task.dart';
import '../models/earnings_summary.dart';
import '../models/hotspot.dart';

class FallbackDeliveryData {
  static List<DeliveryTask> getInitialTasks() {
    return [
      DeliveryTask(
        id: 'DEL-9081',
        type: 'Pickup (Sell Order)',
        customer: 'Ananya Verma',
        phone: '+91 98765 43210',
        address: 'Flat 402, Green Glen Heights, Bellandur, Bengaluru',
        distance: '1.8 km away',
        device: 'iPhone 14 Pro 128GB Space Black',
        condition: 'Flawless - Screen original, battery 92%',
        payoutToCustomer: '₹48,500',
        feeEarned: '₹240',
        otp: '7291',
        status: 'Assigned',
        timeSlot: '11:00 AM - 01:00 PM',
        checks: [false, false, false, false],
      ),
      DeliveryTask(
        id: 'DEL-9082',
        type: 'Delivery (Refurbished)',
        customer: 'Rohit Deshmukh',
        phone: '+91 99887 66554',
        address: 'B-12, Sector 62, Noida, NCR',
        distance: '3.4 km away',
        device: 'MacBook Pro M2 512GB Space Gray',
        condition: 'Refurbished Superb - Sealed Box',
        payoutToCustomer: '₹0 (Prepaid)',
        feeEarned: '₹320',
        otp: '4183',
        status: 'In Transit',
        timeSlot: '02:00 PM - 04:00 PM',
        checks: [true, true, true, false],
      ),
      DeliveryTask(
        id: 'DEL-9083',
        type: 'Pickup (Exchange)',
        customer: 'Siddharth Rao',
        phone: '+91 91234 56789',
        address: 'Villa 9, Palm Meadows, Whitefield, Bengaluru',
        distance: '5.2 km away',
        device: 'Samsung Galaxy S23 Ultra 256GB Phantom Black',
        condition: 'Good - Minor hairline scratches',
        payoutToCustomer: '₹42,000',
        feeEarned: '₹280',
        otp: '8845',
        status: 'Assigned',
        timeSlot: '04:30 PM - 06:30 PM',
        checks: [false, false, false, false],
      ),
      DeliveryTask(
        id: 'DEL-9079',
        type: 'Pickup (Sell Order)',
        customer: 'Pooja Iyer',
        phone: '+91 98111 22334',
        address: 'Flat 8A, Prestige Falcon Tower, South End, Bengaluru',
        distance: 'Completed',
        device: 'iPad Pro 11" M2 256GB Wi-Fi',
        condition: 'Flawless - With Apple Pencil',
        payoutToCustomer: '₹45,000',
        feeEarned: '₹250',
        otp: '6621',
        status: 'Delivered',
        timeSlot: '09:30 AM - 10:30 AM',
        checks: [true, true, true, true],
      ),
    ];
  }

  static EarningsSummary getEarningsSummary() {
    return EarningsSummary(
      walletBalance: 4890.00,
      todayEstimated: '₹1,090',
      completedTrips: 4,
      targetTrips: 6,
      incentiveBonus: 400.0,
      rating: 4.95,
      recentTrips: [
        TripEarning(
          id: 'DEL-9079',
          title: 'DEL-9079: iPad Pro Handover',
          date: 'Today, 10:28 AM',
          amount: '₹250.00',
          breakdown: 'Base ₹180 + Surge ₹70',
        ),
        TripEarning(
          id: 'DEL-9076',
          title: 'DEL-9076: Galaxy S22 Pickup',
          date: 'Yesterday, 06:15 PM',
          amount: '₹310.00',
          breakdown: 'Base ₹200 + Distance ₹110',
        ),
        TripEarning(
          id: 'DEL-9074',
          title: 'DEL-9074: iPhone 13 Pro',
          date: 'Yesterday, 02:40 PM',
          amount: '₹280.00',
          breakdown: 'Base ₹180 + Tip ₹100',
        ),
        TripEarning(
          id: 'BONUS-WK',
          title: 'Weekly Target Completion Bonus',
          date: 'Sunday, 11:59 PM',
          amount: '₹1,200.00',
          breakdown: 'Direct Incentive Credit',
        ),
      ],
    );
  }

  static List<Hotspot> getHotspots() {
    return [
      Hotspot(
        title: 'Indiranagar & Koramangala Hub',
        zone: 'Bengaluru Central',
        surge: '1.5x Surge',
        ordersCount: '28 orders awaiting rider',
        isHot: true,
      ),
      Hotspot(
        title: 'Whitefield ITPL Corridor',
        zone: 'Bengaluru East',
        surge: '1.3x Surge',
        ordersCount: '19 orders awaiting rider',
        isHot: true,
      ),
      Hotspot(
        title: 'HSR Layout & Electronic City',
        zone: 'Bengaluru South',
        surge: '1.2x Surge',
        ordersCount: '14 orders awaiting rider',
        isHot: false,
      ),
    ];
  }

  static List<DropOffHub> getHubs() {
    return [
      DropOffHub(
        name: 'Maa Ambika Central Tech Lab',
        location: 'Main Road, Odisha',
        timings: 'Open until 09:00 PM',
        description: 'Drop inspected phones here',
      ),
      DropOffHub(
        name: 'Maa Ambika Hub - Main Store',
        location: 'Main Storefront',
        timings: 'Open until 08:30 PM',
        description: 'Drop laptop & accessories boxes',
      ),
    ];
  }

  static List<Map<String, String>> getNotifications() {
    return [
      {
        'title': 'Great Job! 5-Star feedback received',
        'subtitle': 'Customer Ananya Verma rated your handover as super professional.',
        'type': 'star',
      },
      {
        'title': 'Daily payout processed',
        'subtitle': '₹1,450 deposited into your bank account.',
        'type': 'money',
      },
    ];
  }
}
