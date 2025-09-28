enum StaffRole {
  teacher,
  principal,
  guard,
  monitor,
}

class Staff {
  final String id;
  final String schoolId;
  final String name;
  final String email;
  final String phone;
  final StaffRole role;
  final String username;
  final String password;
  final DateTime createdAt;

  Staff({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.username,
    required this.password,
    required this.createdAt,
  });

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['id'] ?? '',
      schoolId: map['schoolId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: StaffRole.values.firstWhere(
        (e) => e.toString() == 'StaffRole.${map['role']}',
        orElse: () => StaffRole.teacher,
      ),
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schoolId': schoolId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.toString().split('.').last,
      'username': username,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get roleDisplayName {
    switch (role) {
      case StaffRole.teacher:
        return 'معلم';
      case StaffRole.principal:
        return 'مدير';
      case StaffRole.guard:
        return 'حارس';
      case StaffRole.monitor:
        return 'مراقب';
    }
  }

  Staff copyWith({
    String? id,
    String? schoolId,
    String? name,
    String? email,
    String? phone,
    StaffRole? role,
    String? username,
    String? password,
    DateTime? createdAt,
  }) {
    return Staff(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      username: username ?? this.username,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
