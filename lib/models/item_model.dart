// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String picture;
  final String name;
  final String lowercaseName;
  final String categoryId;
  final String companyId;
  final String companyName;
  final double rating;
  final int ratingCount;
  final int commentCount;
  final GeoPoint location;
  final int price;
  Item({
    required this.id,
    required this.picture,
    required this.name,
    required this.lowercaseName,
    required this.categoryId,
    required this.companyId,
    required this.companyName,
    required this.rating,
    required this.ratingCount,
    required this.commentCount,
    required this.location,
    required this.price,
  });

  Item copyWith({
    String? id,
    String? picture,
    String? name,
    String? lowercaseName,
    String? categoryId,
    String? companyId,
    String? companyName,
    double? rating,
    int? ratingCount,
    int? commentCount,
    GeoPoint? location,
    int? price,
  }) {
    return Item(
      id: id ?? this.id,
      picture: picture ?? this.picture,
      name: name ?? this.name,
      lowercaseName: lowercaseName ?? this.lowercaseName,
      categoryId: categoryId ?? this.categoryId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      commentCount: commentCount ?? this.commentCount,
      location: location ?? this.location,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'picture': picture,
      'name': name,
      'lowercaseName': lowercaseName,
      'categoryId': categoryId,
      'companyId': companyId,
      'companyName': companyName,
      'rating': rating,
      'ratingCount': ratingCount,
      'commentCount': commentCount,
      'location': location,
      'price': price,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? '',
      picture: map['picture'] ?? '',
      name: map['name'] ?? '',
      lowercaseName: map['lowercaseName'] ?? '',
      categoryId: map['categoryId'] ?? '',
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      rating: map['rating'] ?? 0.0,
      ratingCount: map['ratingCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      location: map['location'],
      price: map['price'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Item(id: $id, picture: $picture, name: $name, lowercaseName: $lowercaseName, categoryId: $categoryId, companyId: $companyId, companyName: $companyName, rating: $rating, ratingCount: $ratingCount, commentCount: $commentCount, location: $location, price: $price)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.picture == picture &&
        other.name == name &&
        other.lowercaseName == lowercaseName &&
        other.categoryId == categoryId &&
        other.companyId == companyId &&
        other.companyName == companyName &&
        other.rating == rating &&
        other.ratingCount == ratingCount &&
        other.commentCount == commentCount &&
        other.location == location &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        picture.hashCode ^
        name.hashCode ^
        lowercaseName.hashCode ^
        categoryId.hashCode ^
        companyId.hashCode ^
        companyName.hashCode ^
        rating.hashCode ^
        ratingCount.hashCode ^
        commentCount.hashCode ^
        location.hashCode ^
        price.hashCode;
  }
}
