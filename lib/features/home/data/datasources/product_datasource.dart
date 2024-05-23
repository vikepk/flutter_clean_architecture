import 'dart:convert';

import 'package:riverpod_files/core/params/params.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_files/features/home/business/entities/product_entity.dart';
import '../../../../core/error/exceptions.dart';
import '../model/product_model.dart';

abstract class ProducRemoteDataSource {
  Future<List<ProductModel>> getProducts({required ProductParams params});
  Future<String> postProducts({required Set<ProductModel> postProducts});
}

class ProductRemoteDataSourceImpl implements ProducRemoteDataSource {
  final Dio dio;
  ProductRemoteDataSourceImpl({required this.dio});
  @override
  Future<List<ProductModel>> getProducts(
      {required ProductParams params}) async {
    final response = await dio.get('http://192.168.148.56:5000/getdata');
    if (response.statusCode == 200) {
      final List jsonData = response.data;
      print(response.data);

      return jsonData.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> postProducts(
      {required Set<ProductEntity> postProducts}) async {
    print(postProducts);
    final List<Map<String, dynamic>> productsList = postProducts
        .map((product) => (product as ProductModel).toJson())
        .toList();
    final response = await dio.post(
      'http://192.168.148.56:5000/postdata',
      data: jsonEncode(productsList),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (response.statusCode == 200) {
      final String res = response.data;
      print(res);
      return res;
    } else if (response.statusCode == 400) {
      final String res = response.data;
      print(res);
      return res;
    } else {
      throw ServerException();
    }
  }
}
