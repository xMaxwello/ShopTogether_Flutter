import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserCardService {

  static Future<String> getUserName(String uid) async {
    if (uid.isEmpty) {
      return "Nicht angemeldet";
    }

    try {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        var userData = userDoc.data();
        return "${userData?['prename'] ?? ''} ${userData?['surname'] ?? ''}";
      }
      return "Nicht angemeldet";
    } catch (e) {
      return "Fehler: $e";
    }
  }
}
