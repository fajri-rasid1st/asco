// Package imports:
import 'package:equatable/equatable.dart';

class DataResponse extends Equatable {
  final String? status;
  final dynamic data;

  const DataResponse({
    this.status,
    this.data,
  });

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      status: json['status'],
      data: json['data'],
    );
  }

  @override
  List<Object?> get props => [status, data];
}
