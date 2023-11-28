
import '../firestore/MyFirestoreService.dart';

class MyMembersRequestService {

  late final MyFirestoreService myFirestoreService;

  MyMembersRequestService() {

    myFirestoreService = MyFirestoreService();
  }

  void createRequestCodeForSession() {

  }
}