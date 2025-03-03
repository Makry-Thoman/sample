import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>?> getPetDetails(String uid) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Pets details')
        .where('petID', isEqualTo: uid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  } catch (e) {
    print("Error fetching user details: $e");
    return null;
  }
}



