import 'user_role.dart';

class UserProfile {
  UserProfile({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.password,
    required this.document,
    required this.role,
    this.avatarPath,
  });

  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String password;
  final String document;
  final UserRole role;
  final String? avatarPath;

  factory UserProfile.fromApi(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: '',
      document: json['document']?.toString() ?? '',
      role: userRoleFromApi(json['role']?.toString() ?? 'proprietario'),
      avatarPath: json['avatar_path']?.toString(),
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? password,
    String? document,
    UserRole? role,
    String? avatarPath,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      document: document ?? this.document,
      role: role ?? this.role,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
