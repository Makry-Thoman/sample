import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session{
  static const String _emailKey ='email';
  static const _uuidkey = 'uid';
  static const _modekey= 'mode';

  // email and Uuid save cheyan
  static Future<void> saveSession(String email, String uuid , String Mode) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_uuidkey, uuid);
    await prefs.setString(_modekey, Mode);
  }


  // Get session data
  static Future<Map<String, String?>> getSession() async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    return{
      'email' : prefs.getString(_emailKey),
      'uid' : prefs.getString(_uuidkey),
      'mode' : prefs.getString(_modekey),
    };
  }

  // get user details from firestore using email
  static Future<Map<String, dynamic>?> getUserDetails() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uuid = prefs.getString(_uuidkey);

    if (uuid==null)
      {
        return null;
      }

    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('uid',isEqualTo: uuid)
          .limit(1)
          .get();
      if(snapshot.docs.isNotEmpty){
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }else{
        return null;
      }
    }
    catch(e){
      print("Error fetching user details: $e");
      return null;
    }
  }

  // get Hospital details from firestore using email
  static Future<Map<String, dynamic>?> getHospitalDetails() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uuid = prefs.getString(_uuidkey);

    if (uuid==null)
    {
      return null;
    }

    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Hospital')
          .where('uid',isEqualTo: uuid)
          .limit(1)
          .get();
      if(snapshot.docs.isNotEmpty){
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }else{
        return null;
      }
    }
    catch(e){
      print("Error fetching user details: $e");
      return null;
    }
  }

  static Future<void> clearSession() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_uuidkey);
  }
}

