import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_foodstore/resource/model/order_model.dart';
import 'package:flutter_foodstore/resource/model/paging_model.dart';

class OrderRemoteResource {
  final Dio _dio;

  OrderRemoteResource(this._dio);

  Future<Either<String, PagingModel>> fetchOrders({int page = 1}) async {
    try {
      final response = await _dio.get('customer/my-orders?page=$page');
      final rawData =
          response.data is Map ? response.data['data'] : response.data;

      if (rawData is List) {
        final orders = OrderModel.fromList(rawData);
        return Right(
          PagingModel(
            data: orders,
            nextPageUrl: null,
          ),
        );
      }

      if (rawData is Map) {
        final result = PagingModel.fromMap(
          Map<String, dynamic>.from(rawData),
          OrderModel.fromMap,
        );
        return Right(result);
      }

      return Right(
        PagingModel(
          data: <OrderModel>[],
          nextPageUrl: null,
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(e.response?.statusCode.toString() ?? '');
      } else {
        final message = e.response?.data is Map
            ? e.response?.data['message']?.toString()
            : null;
        return Left(message ?? e.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, dynamic>> detailOrder(String snapToken) async {
    try {
      final response = await _dio.get('customer/my-orders/$snapToken');
      return Right(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(e.response?.statusCode.toString() ?? '');
      } else {
        final message = e.response?.data is Map
            ? e.response?.data['message']?.toString()
            : null;
        return Left(message ?? e.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> reviewProduct(
    int transactionDetailId,
    int productId,
    int rating,
    String review,
  ) async {
    try {
      final response = await _dio.post(
        'customer/ratings',
        data: {
          'transaction_detail_id': transactionDetailId,
          'product_id': productId,
          'rating': rating,
          'review': review,
        },
      );
      return Right(response.data['message']?.toString() ?? '');
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : null;
      return Left(message ?? e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }
}