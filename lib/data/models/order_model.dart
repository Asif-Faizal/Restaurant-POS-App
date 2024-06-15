class Order {
  final int orderId;
  final int tableId;
  final String customerName;
  final String customerNumber;
  final int totalAmount;
  final bool isDelivered;
  final DateTime orderTime;

  Order({
    required this.orderId,
    required this.tableId,
    required this.customerName,
    required this.customerNumber,
    required this.totalAmount,
    required this.isDelivered,
    required this.orderTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      tableId: json['table_id'],
      customerName: json['customer_name'],
      customerNumber: json['customer_number'],
      totalAmount: json['total_amount'],
      isDelivered: json['is_delivered'],
      orderTime: DateTime.parse(json['order_time']),
    );
  }
}
