class HospitalModel {
  String uid;
  String name;
  String email;
  String imageUrl;

  HospitalModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  static HospitalModel fromMap(Map<String, dynamic> map) {
    return HospitalModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      imageUrl: map['imageUrl'],
    );
  }
}
