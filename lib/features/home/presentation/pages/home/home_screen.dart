import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/core/error/failure.dart';
import 'package:riverpod_files/features/home/business/entities/product_entity.dart';
import 'package:riverpod_files/features/home/presentation/providers/cart_notifier.dart';
import 'package:riverpod_files/features/home/presentation/providers/products_providers.dart';

import '../../widgets/cart_icon.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(productsProviderNotifier.notifier).getProducts(value: 5);
    // List<ProductEntity>? allProducts =
    //     ref.watch(productsProviderNotifier.notifier).allproducts;
    // Failure? failure = ref.watch(productsProviderNotifier.notifier).failure;
    // AsyncValue<List<ProductEntity>> products = ref.watch(productsProvider(5));
    // final List<ProductEntity> allProducts = products.when(
    //   data: (products) => products,
    //   loading: () => [],
    //   error: (error, stackTrace) => [],
    // );
    final cartProducts = ref.watch(cartNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Sale Products'),
        actions: const [CartIcon()],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(productsProvider(5));
        },
        child: ref.watch(productsProvider(5)).when(
              data: (allProducts) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    itemCount: allProducts!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        color: Colors.blueGrey.withOpacity(0.05),
                        child: Column(
                          children: [
                            Image.asset(allProducts[index].image,
                                height: 60, width: 60),
                            Text(allProducts[index].title),
                            Text("Rs ${allProducts[index].price}"),
                            if (cartProducts.contains(allProducts[index]))
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(cartNotifierProvider.notifier)
                                      .removeProduct(allProducts[index]);
                                },
                                child: const Text('Remove'),
                              ),
                            if (!cartProducts.contains(allProducts[index]))
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(cartNotifierProvider.notifier)
                                      .addProduct(allProducts[index]);
                                },
                                child: const Text('Add to Cart'),
                              ),
                          ],
                        ),
                      );
                    },
                  )),
              error: (error, stackTrance) => Center(
                child: GestureDetector(
                    onTap: () {
                      print("object");
                      ref.refresh(productsProvider(5));
                    },
                    child: const Text("Try Again Later")),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
      ),
    );
  }
}
