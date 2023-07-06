// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Comment {
  final String id;
  final String userId;
  final String itemId;
  final int rating;
  final String? text;

  Comment({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.rating,
    this.text,
  });

  Comment copyWith({
    String? id,
    String? userId,
    String? itemId,
    int? rating,
    String? text,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      rating: rating ?? this.rating,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'itemId': itemId,
      'rating': rating,
      'text': text,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      itemId: map['itemId'] ?? '',
      rating: map['rating'] ?? 0,
      text: map['text'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, userId: $userId, itemId: $itemId, rating: $rating, text: $text)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.itemId == itemId &&
        other.rating == rating &&
        other.text == text;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        itemId.hashCode ^
        rating.hashCode ^
        text.hashCode;
  }
}
