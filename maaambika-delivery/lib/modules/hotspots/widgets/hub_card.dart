import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/hotspot.dart';

class HubCard extends StatelessWidget {
  final DropOffHub hub;

  const HubCard({
    super.key,
    required this.hub,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.warehouse, color: AppConstants.appBarDark, size: 24),
        title: Text(hub.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${hub.location} • ${hub.timings}', style: const TextStyle(fontSize: 11, color: AppConstants.textSlate)),
            Text(hub.description, style: const TextStyle(fontSize: 11, color: AppConstants.primaryColor)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.directions, color: AppConstants.primaryColor),
          onPressed: () {
            Helpers.openMapAddress('${hub.name}, ${hub.location}');
          },
        ),
      ),
    );
  }
}
