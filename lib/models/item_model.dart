// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Item {
  final String id;
  final String name;
  final String categoryId;
  final String companyId;
  final String companyName;
  final String categoryName;
  Item({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.companyId,
    required this.companyName,
    required this.categoryName,
  });

  Item copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? companyId,
    String? companyName,
    String? categoryName,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      categoryName: categoryName ?? this.categoryName,
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
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      categoryId: map['categoryId'] ?? '',
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      categoryName: map['categoryName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Item(id: $id, name: $name, categoryId: $categoryId, companyId: $companyId, companyName: $companyName, categoryName: $categoryName)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.categoryId == categoryId &&
        other.companyId == companyId &&
        other.companyName == companyName &&
        other.categoryName == categoryName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        categoryId.hashCode ^
        companyId.hashCode ^
        companyName.hashCode ^
        categoryName.hashCode;
  }
}
