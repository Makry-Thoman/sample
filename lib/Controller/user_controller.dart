class UserModel {
  final String uid;
  final String name;
  final String email;
  final String password;
  // final String phone;

  UserModel({required this.uid, required this.name, required this.email, required this.password});

  // Convert UserModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password':password,
      // 'phone':phone,
    };
  }

  // Convert Firestore document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      // phone: map['phone'] ?? '',
    );
  }
}