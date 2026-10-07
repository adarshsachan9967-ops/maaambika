import 'package:flutter/material.dart';
import '../../core/utils/helpers.dart';
import '../../data/fallback/fallback_data.dart';
import 'views/rental_catalog_view.dart';
import 'views/rental_checkout_view.dart';
import 'views/rental_detail_view.dart';

class RentalCamerasScreen extends StatefulWidget {
  const RentalCamerasScreen({super.key});

  @override
  State<RentalCamerasScreen> createState() => _RentalCamerasScreenState();
}

class _RentalCamerasScreenState extends State<RentalCamerasScreen> {
  Map<String, dynamic>? _selectedRental;
  bool _isCheckout = false;
  final int _rentalDays = 3;

  @override
  Widget build(BuildContext context) {
    if (_isCheckout && _selectedRental != null) {
      return RentalCheckoutView(
        rental: _selectedRental!,
        days: _rentalDays,
        onBack: () => setState(() => _isCheckout = false),
        onConfirmBooking: () {
          Helpers.showSuccessSnackbar('Success', 'Rental Booking Confirmed for ${_selectedRental!['model']}!');
          setState(() {
            _selectedRental = null;
            _isCheckout = false;
          });
        },
      );
    }

    if (_selectedRental != null) {
      return RentalDetailView(
        rental: _selectedRental!,
        onBack: () => setState(() => _selectedRental = null),
        onProceedToCheckout: () => setState(() => _isCheckout = true),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Cinema & Pro Cameras', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: RentalCatalogView(
        rentals: FallbackData.rentals,
        onRentalSelected: (rental) {
          setState(() => _selectedRental = rental);
        },
      ),
    );
  }
}
