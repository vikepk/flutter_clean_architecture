import 'package:dartz/dartz.dart';
import 'package:riverpod_files/core/error/exceptions.dart';
import 'package:riverpod_files/features/home/business/repositories/product_repository.dart';
import 'package:riverpod_files/features/home/data/datasources/product_datasource.dart';
import 'package:riverpod_files/features/home/data/model/product_model.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/params/params.dart';

class ProductRespositoryImpl implements ProductRespository {
  final ProductRemoteDataSourceImpl remoteDataSource;
  ProductRespositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts(
      {required ProductParams params}) async {
    try {
      final allproducts = await remoteDataSource.getProducts(params: params);
      return Right(allproducts);
    } on ServerException {
      return Left(ServerFailure(errorMessage: 'This is a server exception'));
    }
  }
}
