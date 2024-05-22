import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_files/features/home/business/entities/product_entity.dart';
// part 'cart_notifier.g.dart';

@riverpod
class CartNotifier extends Notifier<Set<ProductEntity>> {
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
    NotifierProvider<CartNotifier, Set<ProductEntity>>(() {
  return CartNotifier();
});

// @riverpod
// int totalCart(ref) {
//   final products = ref.watch(cartNotifierProvider);
//   int total = 0;
//   for (ProductEntity product in products) {
//     total += product.price;
//   }
//   return total;
// }
