class School {
  final String id;
  final String name;
  final String logo;
  final String location;
  final double? latitude; // خط العرض
  final double? longitude; // خط الطول
  final String adminUsername;
  final String adminPassword;
  final double range; // مسافة النطاق بالمتر
  final int delayMinutes; // عدد الدقائق للتنبيه
  final DateTime createdAt;
  final DateTime? updatedAt;

  School({
    required this.id,
    required this.name,
    required this.logo,
    required this.location,
    this.latitude,
    this.longitude,
    required this.adminUsername,
    required this.adminPassword,
    this.range = 100.0,
    this.delayMinutes = 15,
    required this.createdAt,
    this.updatedAt,
  });

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      logo: map['logo'] ?? '',
      location: map['location'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      adminUsername: map['adminUsername'] ?? '',
      adminPassword: map['adminPassword'] ?? '',
      range: (map['range'] ?? 100.0).toDouble(),
      delayMinutes: map['delayMinutes'] ?? 15,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'adminUsername': adminUsername,
      'adminPassword': adminPassword,
      'range': range,
      'delayMinutes': delayMinutes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  School copyWith({
    String? id,
    String? name,
    String? logo,
    String? location,
    double? latitude,
    double? longitude,
    String? adminUsername,
    String? adminPassword,
    double? range,
    int? delayMinutes,
    DateTime? createdAt,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      adminUsername: adminUsername ?? this.adminUsername,
      adminPassword: adminPassword ?? this.adminPassword,
      range: range ?? this.range,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
