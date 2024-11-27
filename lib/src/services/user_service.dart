import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserService {

  UserService(this.context);
  final BuildContext context;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> doesUserExist(String userUid) async {
    try {
      final DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userUid).get();
      return userDoc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userUid) async {
    try {
      final DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userUid).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
