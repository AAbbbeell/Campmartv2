// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      errors: json['errors'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'errors': instance.errors,
    };

PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PaginatedResponse<T>(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
  pagination: json['pagination'] == null
      ? null
      : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data?.map(toJsonT).toList(),
  'pagination': instance.pagination,
};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  currentPage: (json['currentPage'] as num).toInt(),
  perPage: (json['perPage'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  hasNext: json['hasNext'] as bool,
  hasPrev: json['hasPrev'] as bool,
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'perPage': instance.perPage,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
      'hasPrev': instance.hasPrev,
    };
