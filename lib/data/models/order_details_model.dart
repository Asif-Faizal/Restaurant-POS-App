class Order {
  final int id;
  final String orderNumber;
  final String userId;
  final String userName;
  final String customerId;
  final String customerName;
  final String tableName;
  final String startDateTime;
  final String itemCode;
  final String itemName;
  final double salePrice;
  final int qty;
  final double totalSalePrice;
  final double gst;
  final double gstAmount;
  final double inclusiveSalePrice;
  final String activeInactive;
  final String kotNo;

  Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.userName,
    required this.customerId,
    required this.customerName,
    required this.tableName,
    required this.startDateTime,
    required this.itemCode,
    required this.itemName,
    required this.salePrice,
    required this.qty,
    required this.totalSalePrice,
    required this.gst,
    required this.gstAmount,
    required this.inclusiveSalePrice,
    required this.activeInactive,
    required this.kotNo,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['Id'],
      orderNumber: json['OrderNumber'],
      userId: json['UserId'],
      userName: json['UserName'],
      customerId: json['CustomerId'],
      customerName: json['CustomerName'],
      tableName: json['TableName'],
      startDateTime: json['StartDateTime'],
      itemCode: json['ItemCode'],
      itemName: json['ItemName'],
      salePrice: json['salePrice'].toDouble(),
      qty: int.parse(json['Qty']),
      totalSalePrice: json['TotalsalePrice'].toDouble(),
      gst: json['GST'].toDouble(),
      gstAmount: json['GSTAmount'].toDouble(),
      inclusiveSalePrice: json['inclusiceSaleprice'].toDouble(),
      activeInactive: json['ActiveInnactive'],
      kotNo: json['KOTNo'],
    );
  }
}
