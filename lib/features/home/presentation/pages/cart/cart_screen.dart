import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_files/features/home/business/entities/product_entity.dart';
import 'package:riverpod_files/features/home/presentation/providers/cart_notifier.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? result; // Change type to String? to allow for null values
    final allProducts = ref.watch(cartNotifierProvider);
    final totalCart = ref.watch(cartNotifierProvider.notifier).totalCart(ref);
    bool test = ref.watch(boughtStateProvider);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Your Cart'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Column(
                children: allProducts.map((product) {
                  return Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Image.asset(product.image, width: 60, height: 60),
                        const SizedBox(width: 10),
                        Text('${product.title}...'),
                        const Expanded(child: SizedBox()),
                        Text('£${product.price}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Text("Total Rs $totalCart"),
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, _) {
                  // final buyProductsState =
                  //     ref.watch(buyProductProvider(allProducts));

                  return TextButton(
                    onPressed: () {
                      ref.watch(buyProductProvider(allProducts)).when(
                            data: (data) {
                              ref.refresh(boughtStateProvider.state).state =
                                  true;
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stackTrace) => Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    ref.refresh(
                                        buyProductProvider(allProducts));
                                  },
                                  child: const Text("Retry"),
                                ),
                                Text(
                                  'Error: $error',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          );
                    },
                    child: const Text("Buy Now"),
                  );
                },
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
