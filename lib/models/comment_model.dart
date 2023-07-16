// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gurme/models/user_model.dart';

class Comment {
  final String id;
  final UserModel user;
  final String itemId;
  final int rating;
  final String userRef;
  final String? text;
  Comment({
    required this.id,
    required this.user,
    required this.itemId,
    required this.rating,
    required this.userRef,
    this.text,
  });

  Comment copyWith({
    String? id,
    UserModel? user,
    String? itemId,
    int? rating,
    String? userRef,
    String? text,
  }) {
    return Comment(
      id: id ?? this.id,
      user: user ?? this.user,
      itemId: itemId ?? this.itemId,
      rating: rating ?? this.rating,
      userRef: userRef ?? this.userRef,
      text: text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'itemId': itemId,
      'rating': rating,
      'userRef': userRef,
      'text': text,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      user: UserModel.fromMap(map['user']),
      itemId: map['itemId'] ?? '',
      rating: map['rating'] ?? 0,
      userRef: map['userRef'] ?? '',
      text: map['text'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, user: $user, itemId: $itemId, rating: $rating, userRef: $userRef, text: $text)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.itemId == itemId &&
        other.rating == rating &&
        other.userRef == userRef &&
        other.text == text;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        itemId.hashCode ^
        rating.hashCode ^
        userRef.hashCode ^
        text.hashCode;
  }
}
