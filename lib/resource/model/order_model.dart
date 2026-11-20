import 'dart:convert';

import 'package:flutter_foodstore/resource/model/customer_model.dart';

class OrderModel {
  final int? id;
  final int? customerId;
  final String? provinceName;
  final String? cityName;
  final String? districtName;
  final String? subdistrictName;
  final int? zipCode;
  final String? fullAddress;
  final String? invoice;
  final int? weight;
  final int? total;
  final String? status;
  final String? snapToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CustomerModel? customer;

  OrderModel({
    this.id,
    this.customerId,
    this.provinceName,
    this.cityName,
    this.districtName,
    this.subdistrictName,
    this.zipCode,
    this.fullAddress,
    this.invoice,
    this.weight,
    this.total,
    this.status,
    this.snapToken,
    this.createdAt,
    this.updatedAt,
    this.customer,
  });

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ??
        double.tryParse(value.toString())?.toInt();
  }

  static List<OrderModel> fromList(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType()
        .map((item) => OrderModel.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  factory OrderModel.fromJson(String str) =>
      OrderModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
        id: _toInt(json["id"]),
        customerId: _toInt(json["customer_id"]),
        provinceName: json["province_name"]?.toString(),
        cityName: json["city_name"]?.toString(),
        districtName: json["district_name"]?.toString(),
        subdistrictName: json["subdistrict_name"]?.toString(),
        zipCode: _toInt(json["zip_code"]),
        fullAddress: json["full_address"]?.toString(),
        invoice: json["invoice"]?.toString(),
        weight: _toInt(json["weight"]),
        total: _toInt(json["total"]),
        status: json["status"]?.toString(),
        snapToken: json["snap_token"]?.toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"].toString()),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"].toString()),
        customer: json["customer"] is Map
            ? CustomerModel.fromMap(
                Map<String, dynamic>.from(json["customer"] as Map),
              )
            : null,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "customer_id": customerId,
        "province_name": provinceName,
        "city_name": cityName,
        "district_name": districtName,
        "subdistrict_name": subdistrictName,
        "zip_code": zipCode,
        "full_address": fullAddress,
        "invoice": invoice,
        "weight": weight,
        "total": total,
        "status": status,
        "snap_token": snapToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "customer": customer?.toMap(),
      };
}