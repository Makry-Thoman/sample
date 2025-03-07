class HospitalModel {
  String uid;
  String hospitalname;
  String email;
  String imageUrl;
  String state;   // Added state field
  String district;
  String description;

  HospitalModel({
    required this.uid,
    required this.hospitalname,
    required this.email,
    required this.imageUrl,
    required this.state,   // Added
    required this.district,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'hospitalname': hospitalname,
      'email': email,
      'imageUrl': imageUrl,
      'state': state,   // Added
      'district': district,
      'description': description,
    };
  }

  static HospitalModel fromMap(Map<String, dynamic> map) {
    return HospitalModel(
      uid: map['uid'],
      hospitalname: map['hospitalname'],
      email: map['email'],
      imageUrl: map['imageUrl'],
      state: map['state'],   // Added
      district: map['district'],
        description: map['description'],
    );
  }
}
