import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  String? _userId;
  String? _username;
  // ... other user properties

  String? get userId => _userId;
  String? get username => _username;

  void updateUsername(String newUsername) {
    // Update the username in Firestore
    // ...

    // Update the local state
    _username = newUsername;
    
    // Notify the listeners that the data has changed
    notifyListeners();
  }


  Future<void> loginWithEmail(String email) async {
    // Assuming you have a "users" collection in Firestore
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('Email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      _userId = snapshot.docs.first.id;
      notifyListeners();
    }
    
  }
}
