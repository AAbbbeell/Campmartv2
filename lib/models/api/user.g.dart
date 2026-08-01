// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

University _$UniversityFromJson(Map<String, dynamic> json) => University(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  slug: json['slug'] as String,
);

Map<String, dynamic> _$UniversityToJson(University instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String?,
  email: json['email'] as String,
  fullName: json['fullName'] as String?,
  firstname: json['firstname'] as String?,
  lastname: json['lastname'] as String?,
  phone: json['phone'] as String?,
  role: json['role'] as String?,
  status: json['status'] as String?,
  profileImage: json['profileImage'] as String?,
  university: json['university'] == null
      ? null
      : University.fromJson(json['university'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'fullName': instance.fullName,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'phone': instance.phone,
  'role': instance.role,
  'status': instance.status,
  'profileImage': instance.profileImage,
  'university': instance.university,
};

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  tokenType: json['tokenType'] as String,
  expiresIn: (json['expiresIn'] as num).toInt(),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
    };
