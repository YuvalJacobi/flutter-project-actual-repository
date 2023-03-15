import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_complete_guide/model/user.dart' as UserModel;

import '../model/dish.dart';

class Auth extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  String uid;

  UserModel.User user;

  void submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    if (isLogin) {
      authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user.uid)
          .set({
        'username': username,
        'email': email,
        'age': 0,
        'height': 0,
        'weight': 0,
        'following': 0,
        'followers': 0,
        'weekly_plans': 0,
        'daily_plans': 0,
      });
    }

    uid = authResult.user.uid;
    notifyListeners();
  }

  Future<void> setData(UserModel.User user) {
    FirebaseFirestore.instance.collection('users').doc(user.user_id).set({
      'first_name': user.first_name,
      'last_name': user.last_name,
      'email': user.daily_plans,
      'age': user.age,
      'height': user.height,
      'weight': user.weight,
      'following': user.following,
      'followers': user.followers,
      'weekly_plans': user.weekly_plans,
      'daily_plans': user.daily_plans,
      'username': user.username,
    });
  }

  Future<void> fetchData(UserModel.User user) {
    FirebaseFirestore.instance.collection('users').doc(user.user_id).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        user = UserModel.User(first_name: doc['first_name'], last_name: doc['last_name'], username: doc['username']);
      });
  }
}
