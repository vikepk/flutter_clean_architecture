import 'package:dartz/dartz.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/business/repositories/pokemon_image_repository.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/data/datasources/pokemon_image_local_data_source.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/data/models/pokemon_image_model.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../datasources/pokemon_image_remote_data_source.dart';

class PokemonImageRespoitoryImpl implements PokemonImageRepository {
  final PokemonImageRemoteDataSource remoteDataSource;
  final PokemonImageLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PokemonImageRespoitoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PokemonImageModel>> getPokemonImage(
      {required PokemonImageParams pokemonImageParams}) async {
    if (await networkInfo.isConnected!) {
      try {
        PokemonImageModel remotePokemonIamge = await remoteDataSource
            .getPokemonImage(pokemonImageParams: pokemonImageParams);

        localDataSource.cachePokemonImage(
            pokemonImageToCache: remotePokemonIamge);

        return Right(remotePokemonIamge);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      try {
        PokemonImageModel localPokeonImage =
            await localDataSource.getLastPokemonImage();
        return Right(localPokeonImage);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'This is a cache exception'));
      }
    }
  }
}
