import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_foodstore/resource/model/cart_response_model.dart';

class CartRemoteResource {
  final Dio _dio;

  CartRemoteResource(this._dio);

  String _errorMessage(DioException e) {
    if (e.response?.statusCode == 401) {
      return e.response?.statusCode.toString() ?? '';
    }
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return e.toString();
  }

  Future<Either<String, CartResponseModel>> fetchCart() async {
    try {
      final response = await _dio.get('customer/carts');
      final rawData =
          response.data is Map ? response.data['data'] : response.data;
      final result = CartResponseModel.fromMap(rawData);
      return Right(result);
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> cartStore(
    int productId,
    int qty,
  ) async {
    try {
      final response = await _dio.post(
        'customer/carts',
        data: {
          'product_id': productId.toString(),
          'qty': qty.toString(),
        },
      );
      return Right(response.data['message']?.toString() ?? '');
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> incrementCart(
    int productId,
    int cartId,
  ) async {
    try {
      final response = await _dio.post(
        'customer/carts/increment',
        data: {
          'product_id': productId.toString(),
          'cart_id': cartId.toString(),
        },
      );
      return Right(response.data['message']?.toString() ?? '');
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> decrementCart(
    int productId,
    int cartId,
  ) async {
    try {
      final response = await _dio.post(
        'customer/carts/decrement',
        data: {
          'product_id': productId.toString(),
          'cart_id': cartId.toString(),
        },
      );
      return Right(response.data['message']?.toString() ?? '');
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> removeCart(
    int cartId,
  ) async {
    try {
      final response = await _dio.delete(
        'customer/carts/$cartId',
      );
      return Right(response.data['message']?.toString() ?? '');
    } on DioException catch (e) {
      return Left(_errorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }
}