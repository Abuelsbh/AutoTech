class ClassSection {
  final String id;
  final String schoolId;
  final String name; // مثل KG2 A, G1 C, الصف الاول أ
  final String description;
  final DateTime createdAt;

  ClassSection({
    required this.id,
    required this.schoolId,
    required this.name,
    this.description = '',
    required this.createdAt,
  });

  factory ClassSection.fromMap(Map<String, dynamic> map) {
    return ClassSection(
      id: map['id'] ?? '',
      schoolId: map['schoolId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolId': schoolId,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ClassSection copyWith({
    String? id,
    String? schoolId,
    String? name,
    String? description,
    DateTime? createdAt,
  }) {
    return ClassSection(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
