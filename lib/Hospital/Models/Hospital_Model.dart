class HospitalModel {
  String uid;
  String hospitalname;
  String email;
  String imageUrl;

  HospitalModel({
    required this.uid,
    required this.hospitalname,
    required this.email,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'Hospitalname': hospitalname,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  static HospitalModel fromMap(Map<String, dynamic> map) {
    return HospitalModel(
      uid: map['uid'],
      hospitalname: map['hospitalname'],
      email: map['email'],
      imageUrl: map['imageUrl'],
    );
  }
}
