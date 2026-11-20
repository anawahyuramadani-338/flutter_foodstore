import 'dart:convert';

import 'package:flutter_foodstore/core/utils/parse_helper.dart';
import 'package:flutter_foodstore/resource/model/product_model.dart';

class CartResponseModel {
  final int? totalWeight;
  final int? totalPrice;
  final List<Cart>? carts;

  CartResponseModel({
    this.totalWeight,
    this.totalPrice,
    this.carts,
  });

  factory CartResponseModel.fromJson(String str) =>
      CartResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CartResponseModel.fromMap(dynamic json) {
    if (json is List) {
      final parsedCarts = json
          .whereType()
          .map((x) => Cart.fromMap(Map<String, dynamic>.from(x)))
          .toList();
      return CartResponseModel(
        totalWeight: 0,
        totalPrice: 0,
        carts: parsedCarts,
      );
    }

    final map =
        json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{};
    final rawCarts = map["carts"];

    return CartResponseModel(
      totalWeight: toIntOrNull(map["total_weight"]),
      totalPrice: toIntOrNull(map["total_price"]),
      carts: rawCarts is List
          ? rawCarts
              .whereType()
              .map((x) => Cart.fromMap(Map<String, dynamic>.from(x)))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() => {
        "total_weight": totalWeight,
        "total_price": totalPrice,
        "carts": carts == null
            ? []
            : List<dynamic>.from(carts!.map((x) => x.toMap())),
      };
}

class Cart {
  final int? id;
  final int? customerId;
  final int? productId;
  final int? qty;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProductModel? product;

  Cart({
    this.id,
    this.customerId,
    this.productId,
    this.qty,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory Cart.fromJson(String str) => Cart.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
        id: toIntOrNull(json["id"]),
        customerId: toIntOrNull(json["customer_id"]),
        productId: toIntOrNull(json["product_id"]),
        qty: toIntOrNull(json["qty"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"].toString()),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"].toString()),
        product: json["product"] is Map
            ? ProductModel.fromMap(
                Map<String, dynamic>.from(json["product"] as Map),
              )
            : null,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "customer_id": customerId,
        "product_id": productId,
        "qty": qty,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "product": product?.toMap(),
      };
}