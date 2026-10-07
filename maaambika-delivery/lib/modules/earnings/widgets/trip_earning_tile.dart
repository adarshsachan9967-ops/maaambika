import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/earnings_summary.dart';

class TripEarningTile extends StatelessWidget {
  final TripEarning earning;

  const TripEarningTile({
    super.key,
    required this.earning,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.check_circle, color: AppConstants.secondaryColor, size: 20),
        ),
        title: Text(earning.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(earning.date, style: const TextStyle(fontSize: 11, color: AppConstants.textSlate)),
            Text(earning.breakdown, style: const TextStyle(fontSize: 11, color: AppConstants.secondaryColor)),
          ],
        ),
        trailing: Text(
          earning.amount,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppConstants.textDark),
        ),
      ),
    );
  }
}
