import 'dart:convert';

class Toy {
  final String brand;
  final String? type;
  final String year;
  final String modelName;
  final String? modelNumber;
  final String? castingNumber;
  final double? price;
  final String? description;
  final List images;

  Toy({required this.brand, this.type, required this.year, required this.modelName, this.modelNumber, this.castingNumber, this.price, this.description, required this.images});

  factory Toy.fromJson(Map<String, dynamic> json) => Toy(
        brand: json["brand"],
        type: json["type"],
        year: json["year"],
        modelName: json["modelName"],
        modelNumber: json["modelNumber"],
        castingNumber: json["castingNumber"],
        price: json["price"],
        description: json["description"],
        images: json['images'],
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
        "type": type,
        "year": year,
        "modelName": modelName,
        "modelNumber": modelNumber,
        "castingNumber": castingNumber,
        "price": price,
        "description": description,
        "images": images,
      };

  Toy toyFromJson(String str) => Toy.fromJson(jsonDecode(str));
  String toyToJson(Toy data) => jsonEncode(data.toJson());
}
