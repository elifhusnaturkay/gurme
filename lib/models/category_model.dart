// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryModel {
  final String name;
  final String id;
  final String picture;
  final String icon;
  CategoryModel({
    required this.name,
    required this.id,
    required this.picture,
    required this.icon,
  });

  CategoryModel copyWith({
    String? name,
    String? id,
    String? picture,
    String? icon,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      id: id ?? this.id,
      picture: picture ?? this.picture,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'picture': picture,
      'icon': icon,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      picture: map['picture'] ?? '',
      icon: map['icon'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryModel(name: $name, id: $id, picture: $picture, icon: $icon)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.id == id &&
        other.picture == picture &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return name.hashCode ^ id.hashCode ^ picture.hashCode ^ icon.hashCode;
  }
}
