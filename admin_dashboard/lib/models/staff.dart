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
  final List<StaffRole> roles;
  final String username;
  final String password;
  final DateTime createdAt;

  Staff({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.email,
    required this.phone,
    required this.roles,
    required this.username,
    required this.password,
    required this.createdAt,
  });

  factory Staff.fromMap(Map<String, dynamic> map) {
    List<StaffRole> roles = [];
    
    // Handle both old single role format and new multiple roles format
    if (map['roles'] != null && map['roles'] is List) {
      // New format with multiple roles
      roles = (map['roles'] as List).map((roleString) {
        return StaffRole.values.firstWhere(
          (e) => e.toString() == 'StaffRole.$roleString',
          orElse: () => StaffRole.teacher,
        );
      }).toList();
    } else if (map['role'] != null) {
      // Old format with single role - convert to list
      roles = [StaffRole.values.firstWhere(
        (e) => e.toString() == 'StaffRole.${map['role']}',
        orElse: () => StaffRole.teacher,
      )];
    } else {
      // Default to teacher role if no roles specified
      roles = [StaffRole.teacher];
    }
    
    return Staff(
      id: map['id'] ?? '',
      schoolId: map['schoolId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      roles: roles,
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
      'roles': roles.map((role) => role.toString().split('.').last).toList(),
      'username': username,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get roleDisplayName {
    if (roles.isEmpty) return 'غير محدد';
    if (roles.length == 1) {
      switch (roles.first) {
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
    // Multiple roles - return comma-separated list
    return roles.map((role) {
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
    }).join('، ');
  }

  Staff copyWith({
    String? id,
    String? schoolId,
    String? name,
    String? email,
    String? phone,
    List<StaffRole>? roles,
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
      roles: roles ?? this.roles,
      username: username ?? this.username,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
