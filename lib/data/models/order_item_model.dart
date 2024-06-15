class OrderItem {
  final int foodId;
  final String foodName;
  final String foodImage;
  final int foodPrice;
  final int quantity;
  final String extrasName;
  final int extrasPrice;
  final int tableId;
  final int subTotal;
  final int orderId;

  OrderItem({
    required this.foodId,
    required this.foodName,
    required this.foodImage,
    required this.foodPrice,
    required this.quantity,
    required this.extrasName,
    required this.extrasPrice,
    required this.tableId,
    required this.subTotal,
    required this.orderId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      foodId: json['food_id'],
      foodName: json['food_name'],
      foodImage: json['food_image'],
      foodPrice: json['food_price'],
      quantity: json['quantity'],
      extrasName: json['extras_name'],
      extrasPrice: json['extras_price'],
      tableId: json['table_id'],
      subTotal: json['sub_total'],
      orderId: json['order_id'],
    );
  }
}
