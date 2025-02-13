class UserModel {
  late final String uid;
  late final String name;
  late final String email;
  late final String password;


/*
  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }
*/



  // final String phone;

  UserModel(
      {required String uid,
      required String name,
      required String email,
      required String password})
      : password = password,
        email = email,
        name = name,
        uid = uid;

  // Convert UserModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      // 'phone':phone,
    };
  }

  // Convert Firestore document to UserModelz
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      // phone: map['phone'] ?? '',
    );
  }

 /* String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }*/
}
