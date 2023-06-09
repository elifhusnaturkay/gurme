// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Company {
  final String id;
  final String name;
  final String lowercaseName;
  final String bannerPic;
  final double rating;
  final int ratingCount;
  final int commentCount;
  final GeoPoint location;
  final List<String> categoryIds;
  Company({
    required this.id,
    required this.name,
    required this.lowercaseName,
    required this.bannerPic,
    required this.rating,
    required this.ratingCount,
    required this.commentCount,
    required this.location,
    required this.categoryIds,
  });

  Company copyWith({
    String? id,
    String? name,
    String? lowercaseName,
    String? bannerPic,
    double? rating,
    int? ratingCount,
    int? commentCount,
    GeoPoint? location,
    List<String>? categoryIds,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      lowercaseName: lowercaseName ?? this.lowercaseName,
      bannerPic: bannerPic ?? this.bannerPic,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      commentCount: commentCount ?? this.commentCount,
      location: location ?? this.location,
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'lowercaseName': lowercaseName,
      'bannerPic': bannerPic,
      'rating': rating,
      'ratingCount': ratingCount,
      'commentCount': commentCount,
      'location': location,
      'categoryIds': categoryIds,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      lowercaseName: map['lowercaseName'] ?? '',
      bannerPic: map['bannerPic'] ?? '',
      rating: map['rating'] ?? 0.0,
      ratingCount: map['ratingCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      location: map['location'],
      categoryIds: List<String>.from(map['categoryIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) =>
      Company.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Company(id: $id, name: $name, lowercaseName: $lowercaseName, bannerPic: $bannerPic, rating: $rating, ratingCount: $ratingCount, commentCount: $commentCount, location: $location, categoryIds: $categoryIds)';
  }

  @override
  bool operator ==(covariant Company other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.lowercaseName == lowercaseName &&
        other.bannerPic == bannerPic &&
        other.rating == rating &&
        other.ratingCount == ratingCount &&
        other.commentCount == commentCount &&
        other.location == location &&
        listEquals(other.categoryIds, categoryIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        lowercaseName.hashCode ^
        bannerPic.hashCode ^
        rating.hashCode ^
        ratingCount.hashCode ^
        commentCount.hashCode ^
        location.hashCode ^
        categoryIds.hashCode;
  }
}
