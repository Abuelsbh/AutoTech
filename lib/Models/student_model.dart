class StudentModel {
  final String? id;
  final String? schoolId;
  final String? schoolName;
  final String? idNumber;
  final String? name;
  final String? classSection;
  final String? guardianName;
  final String? guardianPhone;
  final String? imageProfile;
  final String? imageSchool;
  final DateTime? createdAt;

  StudentModel({
    this.id,
    this.schoolId,
    this.schoolName,
    this.idNumber,
    this.name,
    this.classSection,
    this.guardianName,
    this.guardianPhone,
    this.imageProfile,
    this.imageSchool,
    this.createdAt,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'],
      schoolId: map['schoolId'],
      schoolName: map['schoolName'],
      idNumber: map['idNumber'],
      name: map['name'],
      classSection: map['classSection'],
      guardianName: map['guardianName'],
      guardianPhone: map['guardianPhone'],
      imageProfile: map['imageProfile'],
      imageSchool: map['imageSchool'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolId': schoolId,
      'schoolName': schoolName,
      'idNumber': idNumber,
      'name': name,
      'classSection': classSection,
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
      'imageProfile': imageProfile,
      'imageSchool': imageSchool,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel.fromMap(json);
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  StudentModel copyWith({
    String? id,
    String? schoolId,
    String? schoolName,
    String? idNumber,
    String? name,
    String? classSection,
    String? guardianName,
    String? guardianPhone,
    String? imageProfile,
    String? imageSchool,
    DateTime? createdAt,
  }) {
    return StudentModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      idNumber: idNumber ?? this.idNumber,
      name: name ?? this.name,
      classSection: classSection ?? this.classSection,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      imageProfile: imageProfile ?? this.imageProfile,
      imageSchool: imageSchool ?? this.imageSchool,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
