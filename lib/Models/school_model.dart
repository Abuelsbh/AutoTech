class SchoolModel {
  final String? id;
  final String? name;
  final String? logo;
  final String? location;
  final String? adminUsername;
  final String? adminPassword;
  final double? range;
  final int? delayMinutes;
  final DateTime? createdAt;

  SchoolModel({
    this.id,
    this.name,
    this.logo,
    this.location,
    this.adminUsername,
    this.adminPassword,
    this.range,
    this.delayMinutes,
    this.createdAt,
  });

  factory SchoolModel.fromMap(Map<String, dynamic> map) {
    return SchoolModel(
      id: map['id'],
      name: map['name'],
      logo: map['logo'],
      location: map['location'],
      adminUsername: map['adminUsername'],
      adminPassword: map['adminPassword'],
      range: map['range']?.toDouble(),
      delayMinutes: map['delayMinutes'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'location': location,
      'adminUsername': adminUsername,
      'adminPassword': adminPassword,
      'range': range,
      'delayMinutes': delayMinutes,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel.fromMap(json);
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  SchoolModel copyWith({
    String? id,
    String? name,
    String? logo,
    String? location,
    String? adminUsername,
    String? adminPassword,
    double? range,
    int? delayMinutes,
    DateTime? createdAt,
  }) {
    return SchoolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      location: location ?? this.location,
      adminUsername: adminUsername ?? this.adminUsername,
      adminPassword: adminPassword ?? this.adminPassword,
      range: range ?? this.range,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
