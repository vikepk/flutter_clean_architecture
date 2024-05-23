import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_files/features/home/business/entities/product_entity.dart';
import 'package:riverpod_files/features/home/business/usecases/product_usecase.dart';
import 'package:riverpod_files/features/home/data/datasources/product_datasource.dart';
import 'package:riverpod_files/features/home/data/repositories/product_respository_impl.dart';
import 'package:dio/dio.dart';

// @riverpod
class CartNotifier extends StateNotifier<Set<ProductEntity>> {
  CartNotifier(this.ref) : super(Set<ProductEntity>.new());

  final Ref ref;
  @override
  Set<ProductEntity> build() {
    return const {};
  }

  void addProduct(ProductEntity product) {
    if (!state.contains(product)) {
      state = {...state, product};
    }
  }

  void removeProduct(ProductEntity product) {
    if (state.contains(product)) {
      state = state.where((e) => e.id != product.id).toSet();
    }
  }

  int totalCart(ref) {
    final products = ref.watch(cartNotifierProvider);
    int total = 0;
    for (ProductEntity product in products) {
      total += product.price;
    }
    return total;
  }
}

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, Set<ProductEntity>>((ref) {
  return CartNotifier(ref);
});

final boughtStateProvider = StateProvider<bool>((ref) => false);
final responseStateProvider = StateProvider<String?>((ref) => null);

final buyProductProvider = FutureProvider.autoDispose
    .family<String, Set<ProductEntity>>((ref, postProducts) async {
  final respository = ProductRespositoryImpl(
      remoteDataSource: ProductRemoteDataSourceImpl(dio: Dio()));
  final result = await Products(respository: respository)
      .postProducts(postProducts: postProducts);

  return result.fold((failure) => throw failure, (result) => result);
});

// // @riverpod
// // int totalCart(ref) {
// //   final products = ref.watch(cartNotifierProvider);
// //   int total = 0;
// //   for (ProductEntity product in products) {
// //     total += product.price;
// //   }
// //   return total;
// // }

class BuyProductsNotifier extends StateNotifier<AsyncValue<String?>> {
  BuyProductsNotifier(this.ref) : super(const AsyncValue.data(''));

  final Ref ref;

  Future<void> buyProducts(Set<ProductEntity> products) async {
    state = const AsyncValue.loading();
    try {
      final repository = ProductRespositoryImpl(
          remoteDataSource: ProductRemoteDataSourceImpl(dio: Dio()));
      final result = await Products(respository: repository)
          .postProducts(postProducts: products);
      state = AsyncValue.data(
          result.fold((failure) => throw failure, (result) => result));
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}

final buyProductsProvider =
    StateNotifierProvider<BuyProductsNotifier, AsyncValue<String?>>((ref) {
  return BuyProductsNotifier(ref);
});
