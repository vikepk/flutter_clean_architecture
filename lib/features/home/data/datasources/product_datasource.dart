import 'package:riverpod_files/core/params/params.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../model/product_model.dart';

abstract class ProducRemoteDataSource {
  Future<List<ProductModel>> getProducts({required ProductParams params});
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
}
