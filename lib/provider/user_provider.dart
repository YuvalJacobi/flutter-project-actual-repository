import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/model/dish.dart';

import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users;

  List<User> get users {
    return [..._users];
  }

  User getUserById(String user_id) {
    return _users.firstWhere((element) => element.user_id == user_id);
  }

  UserProvider();
}
