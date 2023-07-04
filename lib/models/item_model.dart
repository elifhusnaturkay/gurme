// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Item {
  final String id;
  final String name;
  final String lowercaseName;
  final String categoryId;
  final String companyId;
  final String companyName;
  final String categoryName;
  final double rating;
  final int ratingCount;
  final int commentCount;
  Item({
    required this.id,
    required this.name,
    required this.lowercaseName,
    required this.categoryId,
    required this.companyId,
    required this.companyName,
    required this.categoryName,
    required this.rating,
    required this.ratingCount,
    required this.commentCount,
  });

  Item copyWith({
    String? id,
    String? name,
    String? lowercaseName,
    String? categoryId,
    String? companyId,
    String? companyName,
    String? categoryName,
    double? rating,
    int? ratingCount,
    int? commentCount,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      lowercaseName: lowercaseName ?? this.lowercaseName,
      categoryId: categoryId ?? this.categoryId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      categoryName: categoryName ?? this.categoryName,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'lowercaseName': lowercaseName,
      'categoryId': categoryId,
      'companyId': companyId,
      'companyName': companyName,
      'categoryName': categoryName,
      'rating': rating,
      'ratingCount': ratingCount,
      'commentCount': commentCount,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      lowercaseName: map['lowercaseName'] ?? '',
      categoryId: map['categoryId'] ?? '',
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      categoryName: map['categoryName'] ?? '',
      rating: map['rating'] ?? 0.0,
      ratingCount: map['ratingCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Item(id: $id, name: $name, lowercaseName: $lowercaseName, categoryId: $categoryId, companyId: $companyId, companyName: $companyName, categoryName: $categoryName, rating: $rating, ratingCount: $ratingCount, commentCount: $commentCount)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.lowercaseName == lowercaseName &&
        other.categoryId == categoryId &&
        other.companyId == companyId &&
        other.companyName == companyName &&
        other.categoryName == categoryName &&
        other.rating == rating &&
        other.ratingCount == ratingCount &&
        other.commentCount == commentCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        lowercaseName.hashCode ^
        categoryId.hashCode ^
        companyId.hashCode ^
        companyName.hashCode ^
        categoryName.hashCode ^
        rating.hashCode ^
        ratingCount.hashCode ^
        commentCount.hashCode;
  }
}
