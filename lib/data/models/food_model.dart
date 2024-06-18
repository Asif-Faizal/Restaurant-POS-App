class Food {
  final int id;
  final String codeOrSKU;
  final String category;
  final String pdtName;
  final double? purAmtWithTax;
  final double saleAmt;
  final double tax;
  final int totalStock;
  final DateTime date;
  final String serOrGoods;
  final double itemMRP;
  final String image;

  Food({
    required this.id,
    required this.codeOrSKU,
    required this.category,
    required this.pdtName,
    this.purAmtWithTax,
    required this.saleAmt,
    required this.tax,
    required this.totalStock,
    required this.date,
    required this.serOrGoods,
    required this.itemMRP,
    required this.image,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['Id'],
      codeOrSKU: json['codeorSKU'],
      category: json['category'],
      pdtName: json['pdtname'],
      purAmtWithTax: json['puramntwithtax'] != null
          ? double.parse(json['puramntwithtax'])
          : null,
      saleAmt: double.parse(json['saleamnt'].toString()),
      tax: double.parse(json['tax'].toString()),
      totalStock: json['totalstock'],
      date: DateTime.parse(json['Date']),
      serOrGoods: json['SERorGOODS'],
      itemMRP: double.parse(json['itemMRP'].toString()),
      image: json['image'],
    );
  }
}
