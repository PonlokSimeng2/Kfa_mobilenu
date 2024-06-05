// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class UserModel {
  final int id;
  final String username;
  final String first_name;
  final String last_name;
  final String email;
  final String gender;
  final String from;
  final String tel;

  const UserModel({
    required this.id,
    required this.username,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.gender,
    required this.from,
    required this.tel,
  });

  UserModel copyWith({
    int? id,
    String? username,
    String? first_name,
    String? last_name,
    String? email,
    String? gender,
    String? from,
    String? tel,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      from: from ?? this.from,
      tel: tel ?? this.tel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'gender': gender,
      'known_from': from,
      'tel_num': tel,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      username: map['username'] as String,
      first_name: map['first_name'] as String,
      last_name: map['last_name'] as String,
      email: map['email'] as String,
      gender: map['gender'] as String,
      from: map['known_from'] as String,
      tel: map['tel_num'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, first_name: $first_name, last_name: $last_name, email: $email, gender: $gender, from: $from, tel: $tel)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.email == email &&
        other.gender == gender &&
        other.from == from &&
        other.tel == tel;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        email.hashCode ^
        gender.hashCode ^
        from.hashCode ^
        tel.hashCode;
  }
}
