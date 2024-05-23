import 'package:dartz/dartz.dart';
import 'package:riverpod_files/core/error/failure.dart';
import 'package:riverpod_files/core/params/params.dart';
import 'package:riverpod_files/features/home/business/entities/product_entity.dart';
import 'package:riverpod_files/features/home/business/repositories/product_repository.dart';
import 'package:riverpod_files/features/home/data/model/product_model.dart';

class Products {
  final ProductRespository respository;
  Products({required this.respository});
  Future<Either<Failure, List<ProductEntity>>> getData(
      {required ProductParams params}) async {
    return await respository.getProducts(params: params);
  }

  Future<Either<Failure, String>> postProducts(
      {required Set<ProductEntity> postProducts}) async {
    return await respository.postProducts(postProducts: postProducts);
  }
}
