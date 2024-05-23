import 'package:riverpod_files/features/home/business/entities/product_entity.dart';

import '../../../../core/constants/constants.dart';

class ProductModel extends ProductEntity {
  const ProductModel(
      {required this.id,
      required this.title,
      required this.price,
      required this.image})
      : super(id: id, title: title, price: price, image: image);

  final int id;
  final String title;
  final int price;
  final String image;
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json[Kid],
        title: json[Ktitle],
        price: json[Kprice],
        image: json[Kimage]);
  }
  Map<String, dynamic> toJson() {
    return {
      Kid: id,
      Ktitle: title,
      Kprice: price,
      Kimage: image,
    };
  }
}
