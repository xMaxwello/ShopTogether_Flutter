import 'package:cloud_firestore/cloud_firestore.dart';

///TODO: In MyFirestoreService die funktion => es gibt kein MyUserCardServices
///TODO: Das mit dem UserCardService ist nett gemeint. Allerdings muss du aufpassen, man kann nicht einfach für alles ein neuen Service erstellen. Da du dort auf die Datenbank zugreifst, müsstest du die Funktion unter MyFirestoreService unterbringen. Da der Service sich komplett darum kümmert. Guck immer welche Services es gibt und für welche Logiken diese Gedacht sind. Sonst hat man keine Übersicht mehr und verliert sich im Projekt zu schnell bzw. schreibt Funktionen doppelt.
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
