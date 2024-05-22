import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_files/core/error/failure.dart';
import 'package:riverpod_files/features/home/business/entities/product_entity.dart';
import 'package:dio/dio.dart';
import '../../../../core/params/params.dart';
import '../../business/usecases/product_usecase.dart';
import '../../data/datasources/product_datasource.dart';
import '../../data/repositories/product_respository_impl.dart';
// part 'products_providers.g.dart';

class ProductsProvider {
  List<ProductEntity>? allproducts;
  Failure? failure;
  void getProducts({required int value}) async {
    final respository = ProductRespositoryImpl(
        remoteDataSource: ProductRemoteDataSourceImpl(dio: Dio()));
    final getData = await GetProducts(respository: respository)
        .getData(params: ProductParams(params: value));

    return getData.fold((failure) {
      failure = failure;
      allproducts = null;
    }, (products) {
      allproducts = products;
      failure = null;
    });
  }
}

// final productsProviderNotifier =
//     NotifierProvider<ProductsProvider, List<ProductEntity>>(
//   () {
//     return ProductsProvider();
//   },
// );
final productsProvider =
    FutureProvider.family<List<ProductEntity>, int>((ref, value) async {
  final respository = ProductRespositoryImpl(
      remoteDataSource: ProductRemoteDataSourceImpl(dio: Dio()));
  final getData = await GetProducts(respository: respository)
      .getData(params: ProductParams(params: value));

  return getData.fold((failure) => throw failure, (products) => products);
});
