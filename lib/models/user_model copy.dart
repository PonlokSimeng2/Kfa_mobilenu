// // ignore_for_file: non_constant_identifier_names

// import 'dart:convert';

// class UserModel {
//   final int id;
//   final String controlUser;
//   final String oTPCode;
//   final String firstName;
//   final String lastName;
//   final String username;
//   final String gender;
//   final String telNum;
//   final String knownFrom;
//   final String email;
//   final String emailVerifiedAt;
//   final int deleted;
//   final String createdAt;
//   final String updatedAt;

//   const UserModel(
//       {required this.id,
//       required this.controlUser,
//       required this.oTPCode,
//       required this.firstName,
//       required this.lastName,
//       required this.username,
//       required this.gender,
//       required this.telNum,
//       required this.knownFrom,
//       required this.email,
//       required this.emailVerifiedAt,
//       required this.deleted,
//       required this.createdAt,
//       required this.updatedAt});

//   UserModel copyWith(
//       {int? id,
//       String? controlUser,
//       String? oTPCode,
//       String? firstName,
//       String? lastName,
//       String? username,
//       String? gender,
//       String? telNum,
//       String? knownFrom,
//       String? email,
//       String? emailVerifiedAt,
//       int? deleted,
//       String? createdAt,
//       String? updatedAt}) {
//     return UserModel(
//       id: id ?? this.id,
//       username: username ?? this.username,
//       firstName: firstName ?? this.firstName,
//       lastName: lastName ?? this.lastName,
//       email: email ?? this.email,
//       gender: gender ?? this.gender,
//       knownFrom: knownFrom ?? this.knownFrom,
//       telNum: telNum ?? this.telNum,
//       controlUser: controlUser ?? this.controlUser,
//       createdAt: createdAt ?? this.createdAt,
//       deleted: deleted ?? this.deleted,
//       emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
//       oTPCode: oTPCode ?? this.oTPCode,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'username': username,
//       'first_name': firstName,
//       'last_name': lastName,
//       'email': email,
//       'gender': gender,
//       'known_from': knownFrom,
//       'tel_num': telNum,
//       'control_user': controlUser,
//       'created_at': createdAt,
//       'deleted': deleted,
//       'email_verified_at': emailVerifiedAt,
//       'OTP_Code': oTPCode,
//       'updated_at': updatedAt,
//     };
//   }

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       id: map['id'] as int,
//       username: map['username'] as String,
//       firstName: map['first_name'] as String,
//       lastName: map['last_name'] as String,
//       email: map['email'] as String,
//       gender: map['gender'] as String,
//       knownFrom: map['known_from'] as String,
//       telNum: map['tel_num'] as String,
//       controlUser: map['control_user'] as String,
//       createdAt: map['created_at'] as String,
//       deleted: map['deleted'] as int,
//       emailVerifiedAt: map['email_verified_at'] as String,
//       oTPCode: map['OTP_Code'] as String,
//       updatedAt: map['updated_at'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory UserModel.fromJson(String source) =>
//       UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'User(id: $id, username: $username, first_name: $firstName, last_name: $lastName, email: $email, gender: $gender, from: $knownFrom, tel: $telNum,control_user:$controlUser,created_at:$createdAt,email_verified_at:$emailVerifiedAt.OTP_Code:$oTPCode,updated_at:$updatedAt)';
//   }

//   @override
//   bool operator ==(covariant UserModel other) {
//     if (identical(this, other)) return true;

//     return other.id == id &&
//         other.username == username &&
//         other.firstName == firstName &&
//         other.lastName == lastName &&
//         other.email == email &&
//         other.gender == gender &&
//         other.knownFrom == knownFrom &&
//         other.telNum == telNum &&
//         other.controlUser == controlUser &&
//         other.createdAt == createdAt &&
//         other.deleted == deleted &&
//         other.emailVerifiedAt == emailVerifiedAt &&
//         other.oTPCode == oTPCode &&
//         other.updatedAt == updatedAt;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         username.hashCode ^
//         firstName.hashCode ^
//         lastName.hashCode ^
//         email.hashCode ^
//         gender.hashCode ^
//         knownFrom.hashCode ^
//         telNum.hashCode ^
//         controlUser.hashCode ^
//         createdAt.hashCode ^
//         deleted.hashCode ^
//         emailVerifiedAt.hashCode ^
//         oTPCode.hashCode ^
//         updatedAt.hashCode;
//   }
// }
