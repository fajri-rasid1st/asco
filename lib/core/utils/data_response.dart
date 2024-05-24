// Package imports:
import 'package:equatable/equatable.dart';

class DataResponse extends Equatable {
  final int? code;
  final String? message;
  final dynamic data;

  const DataResponse({
    this.code,
    this.message,
    this.data,
  });

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }

  @override
  List<Object?> get props => [code, message, data];
}
