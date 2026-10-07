import '../fallback/fallback_data.dart';

class RentalsRepository {
  Future<List<Map<String, dynamic>>> fetchRentals() async {
    // Eager cache fallback
    return FallbackData.rentals;
  }

  Future<Map<String, dynamic>> bookRental({
    required String rentalId,
    required String startDate,
    required int days,
    required String customerPhone,
    required String customerName,
  }) async {
    return {
      'success': true,
      'bookingId': 'RNT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'message': 'Rental booking confirmed!',
    };
  }
}
