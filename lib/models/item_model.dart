// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Item {
  final String id;
  final String name;
  final String categoryId;
  final String companyId;
  final String companyName;
  final String categoryName;
  final double rating;
  final int ratingCount;
  Item({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.companyId,
    required this.companyName,
    required this.categoryName,
    required this.rating,
    required this.ratingCount,
  });

  Item copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? companyId,
    String? companyName,
    String? categoryName,
    double? rating,
    int? ratingCount,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      categoryName: categoryName ?? this.categoryName,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'companyId': companyId,
      'companyName': companyName,
      'categoryName': categoryName,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as String,
      name: map['name'] as String,
      categoryId: map['categoryId'] as String,
      companyId: map['companyId'] as String,
      companyName: map['companyName'] as String,
      categoryName: map['categoryName'] as String,
      rating: map['rating'] as double,
      ratingCount: map['ratingCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Item(id: $id, name: $name, categoryId: $categoryId, companyId: $companyId, companyName: $companyName, categoryName: $categoryName, rating: $rating, ratingCount: $ratingCount)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.categoryId == categoryId &&
        other.companyId == companyId &&
        other.companyName == companyName &&
        other.categoryName == categoryName &&
        other.rating == rating &&
        other.ratingCount == ratingCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        categoryId.hashCode ^
        companyId.hashCode ^
        companyName.hashCode ^
        categoryName.hashCode ^
        rating.hashCode ^
        ratingCount.hashCode;
  }
}
