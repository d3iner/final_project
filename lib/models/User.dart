import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? lastName;
  String? email;
  bool isAdmin;
  String? id;
  List<dynamic> gotBooks;

  UserModel(
      {this.name = '',
      this.lastName = '',
      this.email = '',
      this.isAdmin = false,
      this.id = '',
      this.gotBooks = const <dynamic>[]});

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        lastName = json['lastName'] as String,
        email = json['email'] as String,
        isAdmin = json['isAdmin'] as bool,
        id = json['id'] as String,
        gotBooks = json['gotBooks'] as List<dynamic>;

  Map<String, dynamic> toJson() => {
        'name': name,
        'lastName': lastName,
        'email': email,
        'isAdmin': isAdmin,
        'id': id,
        'gotBooks': gotBooks
      };
  
  factory UserModel.fromDocument(DocumentSnapshot doc){
    return UserModel(
      name: doc['name'] as String,
      lastName: doc['lastName'] as String,
      email: doc['email'] as String,
      isAdmin: doc['isAdmin'] as bool,
      id: doc['id'] as String,
      gotBooks: doc['gotBooks'] as List<dynamic>,
    );
  }
}
