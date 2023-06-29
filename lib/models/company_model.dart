// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Company {
  final String id;
  final String name;
  final String bannerPic;
  final List<String> categoryIds;
  Company({
    required this.id,
    required this.name,
    required this.bannerPic,
    required this.categoryIds,
  });

  Company copyWith({
    String? id,
    String? name,
    String? bannerPic,
    List<String>? categoryIds,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      bannerPic: bannerPic ?? this.bannerPic,
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bannerPic': bannerPic,
      'categoryIds': categoryIds,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bannerPic: map['bannerPic'] ?? '',
      categoryIds: List<String>.from(map['categoryIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) =>
      Company.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Company(id: $id, name: $name, bannerPic: $bannerPic, categoryIds: $categoryIds)';
  }

  @override
  bool operator ==(covariant Company other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.bannerPic == bannerPic &&
        listEquals(other.categoryIds, categoryIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        bannerPic.hashCode ^
        categoryIds.hashCode;
  }
}
