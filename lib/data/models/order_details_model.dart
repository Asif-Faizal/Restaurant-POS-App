class Order {
  final int id;
  final String orderNumber;
  final String userName;
  final String customerName;
  final String tableName;
  final String itemCode;
  final String itemName;
  final double salePrice;
  final int quantity;
  final double totalSalePrice;
  final double gst;
  final double gstAmount;
  final String KOTNo;

  Order({
    required this.id,
    required this.orderNumber,
    required this.userName,
    required this.customerName,
    required this.tableName,
    required this.itemCode,
    required this.itemName,
    required this.salePrice,
    required this.quantity,
    required this.totalSalePrice,
    required this.gst,
    required this.gstAmount,
    required this.KOTNo,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['Id'],
      orderNumber: json['OrderNumber'],
      userName: json['UserName'],
      customerName: json['CustomerName'],
      tableName: json['TableName'],
      itemCode: json['ItemCode'],
      itemName: json['ItemName'],
      salePrice: json['salePrice'].toDouble(),
      quantity: int.parse(json['Qty']),
      totalSalePrice: json['TotalsalePrice'].toDouble(),
      gst: json['GST'].toDouble(),
      gstAmount: json['GSTAmount'].toDouble(),
      KOTNo: json['KOTNo'],
    );
  }
}
