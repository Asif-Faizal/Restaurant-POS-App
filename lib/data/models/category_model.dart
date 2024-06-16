class CategoryModel {
  final int Id;
  final String pdtfilter;
  final String image;
  final String SERorGOODS;

  CategoryModel(
      {required this.Id,
      required this.pdtfilter,
      required this.image,
      required this.SERorGOODS});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      SERorGOODS: json['SERorGOODS'],
      Id: json['Id'],
      pdtfilter: json['pdtfilter'],
      image: json['image'],
    );
  }
}
