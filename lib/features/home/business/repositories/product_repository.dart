import 'package:dartz/dartz.dart';
import 'package:riverpod_files/core/error/failure.dart';
import 'package:riverpod_files/core/params/params.dart';
import 'package:riverpod_files/features/home/business/entities/product_entity.dart';

abstract class ProductRespository {
  Future<Either<Failure, List<ProductEntity>>> getProducts(
      {required ProductParams params});
}
