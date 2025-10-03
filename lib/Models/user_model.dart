
class UserModel {
  final String? token;
  final String? phoneNumber;
  final String? email;
  final String? role;
  final String? uid;
  final DateTime? createdAt;

  UserModel({
    this.token,
    this.phoneNumber,
    this.email,
    this.role,
    this.uid,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    token: json["token"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    role: json["role"],
    uid: json["uid"],
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "phoneNumber": phoneNumber,
    "email": email,
    "role": role,
    "uid": uid,
    "createdAt": createdAt?.toIso8601String(),
  };

  // إنشاء نسخة محدثة من المستخدم
  UserModel copyWith({
    String? token,
    String? phoneNumber,
    String? email,
    String? role,
    String? uid,
    DateTime? createdAt,
  }) {
    return UserModel(
      token: token ?? this.token,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      role: role ?? this.role,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
