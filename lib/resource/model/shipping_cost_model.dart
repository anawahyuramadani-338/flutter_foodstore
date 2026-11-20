import 'dart:convert';

import 'package:flutter_foodstore/core/utils/parse_helper.dart';

class ShippingCostModel {
  final String? name;
  final String? code;
  final String? service;
  final String? description;
  final int? cost;
  final String? etd;

  ShippingCostModel({
    this.name,
    this.code,
    this.service,
    this.description,
    this.cost,
    this.etd,
  });

  static List<ShippingCostModel> fromOngkirResponse(dynamic raw) {
    final payload =
        (raw is Map && raw['data'] != null) ? raw['data'] : raw;

    if (payload is! List) return [];

    final List<ShippingCostModel> results = [];

    for (final courierItem in payload) {
      if (courierItem is! Map) continue;
      final courierMap = Map<String, dynamic>.from(courierItem);

      final code = courierMap['code']?.toString();
      final name = courierMap['name']?.toString();
      final costsList = courierMap['costs'];

      if (costsList is List && costsList.isNotEmpty) {
        for (final serviceItem in costsList) {
          if (serviceItem is! Map) continue;
          final serviceMap = Map<String, dynamic>.from(serviceItem);

          final service = serviceMap['service']?.toString();
          final description = serviceMap['description']?.toString();
          final costField = serviceMap['cost'];

          if (costField is List && costField.isNotEmpty) {
            final firstCost = costField.first;
            if (firstCost is Map) {
              final costMap = Map<String, dynamic>.from(firstCost);
              results.add(
                ShippingCostModel(
                  name: name,
                  code: code,
                  service: service,
                  description: description,
                  cost: toIntOrNull(costMap['value'] ?? costMap['cost']) ?? 0,
                  etd: costMap['etd']?.toString(),
                ),
              );
            }
          } else {
            results.add(
              ShippingCostModel(
                name: name,
                code: code,
                service: service,
                description: description,
                cost: toIntOrNull(costField) ?? 0,
                etd: serviceMap['etd']?.toString(),
              ),
            );
          }
        }
      } else {
        results.add(ShippingCostModel.fromMap(courierMap));
      }
    }

    return results;
  }

  factory ShippingCostModel.fromJson(String str) =>
      ShippingCostModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShippingCostModel.fromMap(Map<String, dynamic> json) =>
      ShippingCostModel(
        name: json["name"]?.toString(),
        code: json["code"]?.toString(),
        service: json["service"]?.toString(),
        description: json["description"]?.toString(),
        cost: toIntOrNull(json["cost"]),
        etd: json["etd"]?.toString(),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "code": code,
        "service": service,
        "description": description,
        "cost": cost,
        "etd": etd,
      };
}