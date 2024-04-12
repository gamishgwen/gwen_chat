import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gwen_chat/User.dart';

class UserProvider with ChangeNotifier{
  late UserDetails? currentUser;

  Future<void> fetchCurrentUser(String userId) async{
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final userDetails = UserDetails.fromJson(userDoc.data()!);
    currentUser=userDetails;
    notifyListeners();
  }

  void resetCurrentUser() {
    currentUser = null;
    notifyListeners();
  }
}