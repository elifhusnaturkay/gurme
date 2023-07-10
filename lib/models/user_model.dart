// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String profilePic;
  final String uid;
  final bool isAuthenticated;
  final String bannerPic;
  final List<String> favoriteCompanyIds;
  UserModel({
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.isAuthenticated,
    required this.bannerPic,
    required this.favoriteCompanyIds,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? uid,
    bool? isAuthenticated,
    String? bannerPic,
    List<String>? favoriteCompanyIds,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      bannerPic: bannerPic ?? this.bannerPic,
      favoriteCompanyIds: favoriteCompanyIds ?? this.favoriteCompanyIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'bannerPic': bannerPic,
      'favoriteCompanyIds': favoriteCompanyIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      uid: map['uid'] ?? '',
      isAuthenticated: map['isAuthenticated'] ?? false,
      bannerPic: map['bannerPic'] ?? '',
      favoriteCompanyIds: List<String>.from(map['favoriteCompanyIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, uid: $uid, isAuthenticated: $isAuthenticated, bannerPic: $bannerPic, favoriteCompanyIds: $favoriteCompanyIds)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profilePic == profilePic &&
        other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.bannerPic == bannerPic &&
        listEquals(other.favoriteCompanyIds, favoriteCompanyIds);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePic.hashCode ^
        uid.hashCode ^
        isAuthenticated.hashCode ^
        bannerPic.hashCode ^
        favoriteCompanyIds.hashCode;
  }
}
