class Student {
  final String id;
  final String schoolId;
  final String idNumber; // رقم الهوية (10 خانات)
  final String name; // الاسم الثلاثي
  final String classSection; // الصف والشعبة
  final String guardianName; // اسم الوصي
  final String guardianPhone; // رقم جوال الوصي
  final DateTime createdAt;

  Student({
    required this.id,
    required this.schoolId,
    required this.idNumber,
    required this.name,
    required this.classSection,
    required this.guardianName,
    required this.guardianPhone,
    required this.createdAt,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      schoolId: map['schoolId'] ?? '',
      idNumber: map['idNumber'] ?? '',
      name: map['name'] ?? '',
      classSection: map['classSection'] ?? '',
      guardianName: map['guardianName'] ?? '',
      guardianPhone: map['guardianPhone'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolId': schoolId,
      'idNumber': idNumber,
      'name': name,
      'classSection': classSection,
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Student copyWith({
    String? id,
    String? schoolId,
    String? idNumber,
    String? name,
    String? classSection,
    String? guardianName,
    String? guardianPhone,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      idNumber: idNumber ?? this.idNumber,
      name: name ?? this.name,
      classSection: classSection ?? this.classSection,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
