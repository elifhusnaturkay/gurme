// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryModel {
  final String name;
  final String id;
  final String picture;
  CategoryModel({
    required this.name,
    required this.id,
    required this.picture,
  });

  CategoryModel copyWith({
    String? name,
    String? id,
    String? picture,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      id: id ?? this.id,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'picture': picture,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      picture: map['picture'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoryModel(name: $name, id: $id, picture: $picture)';

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id && other.picture == picture;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ picture.hashCode;
}
