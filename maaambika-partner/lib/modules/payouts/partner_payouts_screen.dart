import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/helpers.dart';
import 'bloc/partner_payouts_bloc.dart';
import 'bloc/partner_payouts_event.dart';
import 'bloc/partner_payouts_state.dart';

class PartnerPayoutsScreen extends StatefulWidget {
  const PartnerPayoutsScreen({super.key});

  @override
  State<PartnerPayoutsScreen> createState() => _PartnerPayoutsScreenState();
}

class _PartnerPayoutsScreenState extends State<PartnerPayoutsScreen> {
  final TextEditingController _upiController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _upiController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handlePayout(BuildContext context) {
    final upi = _upiController.text.trim();
    final amountStr = _amountController.text.trim();

    if (upi.isEmpty || amountStr.isEmpty) {
      Helpers.showErrorSnackbar('Error', 'Please enter both UPI ID and settlement amount.');
      return;
    }

    final amount = int.tryParse(amountStr.replaceAll(',', '').replaceAll('₹', '')) ?? 0;
    if (amount <= 0) {
      Helpers.showErrorSnackbar('Error', 'Please enter a valid amount.');
      return;
    }

    context.read<PartnerPayoutsBloc>().add(
          ExecutePayoutEvent(upiId: upi, amount: amount),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PartnerPayoutsBloc, PartnerPayoutsState>(
      listener: (context, state) {
        if (state is PartnerPayoutsSuccessState) {
          Helpers.showSuccessSnackbar('Success', state.successMessage);
          _upiController.clear();
          _amountController.clear();
        }
      },
      builder: (context, state) {
        final isProcessing = state is PartnerPayoutsProcessingState;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Float Wallet Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accentColor, AppColors.accentLight],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FLOAT WALLET BALANCE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatCurrency(state.floatBalance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Direct Node to Bank Escrow Active',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Instant Customer Settlement',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Send money directly to seller bank account via IMPS or UPI upon device handover.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Settlement Form
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _upiController,
                      decoration: const InputDecoration(
                        labelText: 'Customer UPI ID (e.g. 9876543210@paytm)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.payment),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Settlement Amount (₹)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: isProcessing ? null : () => _handlePayout(context),
                        child: isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Authorize Immediate RTGS/UPI Transfer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
