import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class University {
  final int id;
  final String name;
  final String slug;

  University({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory University.fromJson(Map<String, dynamic> json) =>
      _$UniversityFromJson(json);

  Map<String, dynamic> toJson() => _$UniversityToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String? username;
  final String email;
  final String? fullName;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final String? role;
  final String? status;
  final String? profileImage;
  final University? university;

  User({
    required this.id,
    this.username,
    required this.email,
    this.fullName,
    this.firstname,
    this.lastname,
    this.phone,
    this.role,
    this.status,
    this.profileImage,
    this.university,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) return fullName!;
    if (firstname != null && lastname != null) {
      return '$firstname $lastname';
    }
    return username ?? email;
  }
}

@JsonSerializable()
class AuthResponse {
  final User user;
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
