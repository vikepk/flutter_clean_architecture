class ProductEntity {
  const ProductEntity(
      {required this.id,
      required this.title,
      required this.price,
      required this.image});

  final int id;
  final String title;
  final int price;
  final String image;
}
