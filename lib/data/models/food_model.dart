class Food {
  final int id;
  final String name;
  final String image;
  final int price;
  final int extraslist;
  final int categoryid;

  Food({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.extraslist,
    required this.categoryid,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
      extraslist: json['extraslist'],
      categoryid: json['categoryid'],
    );
  }
}
