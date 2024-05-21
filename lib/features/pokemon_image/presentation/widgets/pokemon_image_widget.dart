import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon/business/entities/pokemon_entity.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/business/entities/pokemon_image_entity.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/presentation/providers/pokemon_image_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../core/errors/failure.dart';

class PokemonImageWidget extends StatelessWidget {
  const PokemonImageWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    PokemonImageEntity? pokemonImageEntity =
        Provider.of<PokemonImageProvider>(context).pokemonImageEntity;
    Failure? failure = Provider.of<PokemonImageProvider>(context).failure;
    late Widget widget;
    if (pokemonImageEntity != null) {
      widget = Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.orange,
            image: DecorationImage(
              image: FileImage(File(pokemonImageEntity.path)),
            ),
          ),
          child: child,
        ),
      );
      return widget;
    } else if (failure != null) {
      widget = Expanded(
          child: Center(
        child: Text(
          failure.errorMessage,
          style: TextStyle(fontSize: 20),
        ),
      ));
      return widget;
    } else {
      widget = const Expanded(
          child: Center(
        child: CircularProgressIndicator(),
      ));
      return widget;
    }
  }
}
