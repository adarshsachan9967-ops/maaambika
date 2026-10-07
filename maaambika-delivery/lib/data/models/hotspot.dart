class Hotspot {
  final String title;
  final String zone;
  final String surge;
  final String ordersCount;
  final bool isHot;

  Hotspot({
    required this.title,
    required this.zone,
    required this.surge,
    required this.ordersCount,
    this.isHot = false,
  });

  factory Hotspot.fromMap(Map<String, dynamic> map) {
    return Hotspot(
      title: map['title'] as String? ?? '',
      zone: map['zone'] as String? ?? '',
      surge: map['surge'] as String? ?? '',
      ordersCount: map['ordersCount'] as String? ?? '',
      isHot: map['isHot'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'zone': zone,
      'surge': surge,
      'ordersCount': ordersCount,
      'isHot': isHot,
    };
  }
}

class DropOffHub {
  final String name;
  final String location;
  final String timings;
  final String description;

  DropOffHub({
    required this.name,
    required this.location,
    required this.timings,
    required this.description,
  });

  factory DropOffHub.fromMap(Map<String, dynamic> map) {
    return DropOffHub(
      name: map['name'] as String? ?? '',
      location: map['location'] as String? ?? '',
      timings: map['timings'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'timings': timings,
      'description': description,
    };
  }
}
