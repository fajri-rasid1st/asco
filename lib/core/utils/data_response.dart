// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:equatable/equatable.dart';

class DataResponse extends Equatable {
  final String? status;
  final ErrorResponse? error;
  final dynamic data;

  const DataResponse({
    this.status,
    this.error,
    this.data,
  });

  @override
  List<Object?> get props => [status, error, data];

  factory DataResponse.fromMap(Map<String, dynamic> map) {
    return DataResponse(
      status: map['status'],
      error: map['error'] != null ? ErrorResponse.fromMap(map['error']) : null,
      data: map['data'],
    );
  }

  factory DataResponse.fromJson(String source) =>
      DataResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ErrorResponse extends Equatable {
  final String? code;
  final String? message;

  const ErrorResponse({
    this.code,
    this.message,
  });

  @override
  List<Object?> get props => [code, message];

  factory ErrorResponse.fromMap(Map<String, dynamic> map) {
    return ErrorResponse(
      code: map['code'],
      message: map['message'],
    );
  }

  factory ErrorResponse.fromJson(String source) =>
      ErrorResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
