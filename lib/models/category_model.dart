import 'dart:convert';

class Category {
  final int id;
  final String name;
  String? image;

  Category({
    required this.id,
    required this.name,
    this.image,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      image: map['image'],
    );
  }

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  String toJson() => json.encode(toMap());
}