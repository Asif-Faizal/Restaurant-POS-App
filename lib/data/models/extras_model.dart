class Extra {
  final int id;
  final int foodId;
  final String name;
  final double price;

  Extra(
      {required this.id,
      required this.foodId,
      required this.name,
      required this.price});

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(
      id: json['id'],
      foodId: json['foodid'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}
