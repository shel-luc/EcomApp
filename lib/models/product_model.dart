import '../models/category_model.dart';
import 'dart:convert';

class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String? description;
  Category? category;

  Product(
      {required this.id,
      required this.title,
      required this.price,
      required this.image,
      this.description,
      this.category});

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
      description: map['description'],
      category:
          map['category'] != null ? Category.fromMap(map['category']) : null,
    );
  }

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': title,
      'price': price,
      'image': image,
      'description': description,
      'category': category?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}
