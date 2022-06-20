import 'dart:convert';

class Toy {
  final String? documentId;
  final String brand;
  final String? type;
  final String year;
  final String modelName;
  final String? modelNumber;
  final String? castingNumber;
  final String price;
  final String? description;
  final List images;

  Toy({
    this.documentId,
    required this.brand,
    this.type,
    required this.year,
    required this.modelName,
    this.modelNumber,
    this.castingNumber,
    required this.price,
    this.description,
    required this.images,
  });

  factory Toy.fromJson(Map<String, dynamic> json) => Toy(
        documentId: json['documentId'],
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
        "documentId": documentId,
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

  Toy copyWith({required final String documentId}) => Toy(
        documentId: documentId,
        brand: brand,
        type: type ?? this.type,
        year: this.year,
        modelName: this.modelName,
        modelNumber: modelNumber ?? this.modelNumber,
        castingNumber: castingNumber ?? this.castingNumber,
        price: this.price,
        description: description ?? this.description,
        images: this.images,
      );

  Toy toyFromJson(String str) => Toy.fromJson(jsonDecode(str));
  String toyToJson(Toy data) => jsonEncode(data.toJson());
}
