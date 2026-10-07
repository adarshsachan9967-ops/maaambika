import 'package:flutter/material.dart';

class LocationPickerSheet extends StatelessWidget {
  final String currentCity;
  final String currentArea;
  final Function(String city, String area) onLocationSelected;

  const LocationPickerSheet({
    super.key,
    required this.currentCity,
    required this.currentArea,
    required this.onLocationSelected,
  });

  static final List<Map<String, dynamic>> cities = [
    {
      'name': 'Mumbai',
      'areas': ['Mira Road', 'Andheri West', 'Bandra', 'Borivali', 'Thane'],
    },
    {
      'name': 'Bengaluru',
      'areas': ['Indiranagar', 'Koramangala', 'HSR Layout', 'Whitefield'],
    },
    {
      'name': 'Delhi NCR',
      'areas': ['Connaught Place', 'Gurugram CyberCity', 'Noida Sec 62'],
    },
    {
      'name': 'Hyderabad',
      'areas': ['HITEC City', 'Gachibowli', 'Jubilee Hills'],
    },
    {
      'name': 'Pune',
      'areas': ['Kothrud', 'Viman Nagar', 'Baner', 'Hinjewadi'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Service City', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 2),
                  Text('Available for same-day doorstep inspection', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (ctx, idx) {
                final city = cities[idx];
                final cityName = city['name'] as String;
                final areas = List<String>.from(city['areas'] as List);
                final isSelected = cityName == currentCity;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? const Color(0xFF059669) : Colors.grey.shade200,
                      width: isSelected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: isSelected,
                    leading: Icon(
                      Icons.location_city,
                      color: isSelected ? const Color(0xFF059669) : Colors.grey.shade600,
                    ),
                    title: Text(
                      cityName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xFF059669) : Colors.black87,
                      ),
                    ),
                    children: areas.map((area) {
                      final isAreaSelected = isSelected && area == currentArea;
                      return ListTile(
                        dense: true,
                        title: Text(area),
                        trailing: isAreaSelected
                            ? const Icon(Icons.check_circle, color: Color(0xFF059669), size: 18)
                            : null,
                        onTap: () {
                          onLocationSelected(cityName, area);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
