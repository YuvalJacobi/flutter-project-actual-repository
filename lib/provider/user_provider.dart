import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  late List<User> _users;

  List<User> get users {
    return [..._users];
  }

  User getUserById(String user_id) {
    return _users.firstWhere((element) => element.user_id == user_id);
  }

  Future<void> setData(User user) async {
    FirebaseFirestore.instance.collection('users').doc(user.user_id).set({
      'first_name': user.first_name,
      'last_name': user.last_name,
      'email': user.email,
      'age': user.age,
      'height': user.height,
      'weight': user.weight,
      'username': user.username,
    });
  }

  Future<void> addData(User user) async {
    FirebaseFirestore.instance.collection('users').add({
      'first_name': user.first_name,
      'last_name': user.last_name,
      'email': user.email,
      'age': user.age,
      'height': user.height,
      'weight': user.weight,
      'username': user.username,
    }).then((DocumentReference docref) {
      user.user_id = docref.id;
    });
  }

  Future<void> fetchData() async {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _users.add(User(doc['first_name'], doc['last_name'], doc['email'],
            doc['age'], doc['height'], doc['weight'], doc['username'], doc.id));
      });
    });
  }

  bool isValidEmail(String email_address) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email_address);
  }

  bool isValidUser(User user) {
    if (user.first_name.isEmpty || user.first_name == "") return false;

    if (user.last_name.isEmpty || user.last_name == "") return false;

    if (user.username.isEmpty || user.username == "") return false;

    if (user.age <= 0) return false;

    if (user.height <= 0) return false;

    if (user.weight <= 0) return false;

    if (isValidEmail(user.email) == false) return false;

    return true;
  }

  String stringify(User user) {
    if (isValidUser(user) == false) return '';

    String t = '';

    t += 'First name: ${user.first_name}\n';

    t += 'Last name: ${user.last_name}\n';

    t += 'Username: ${user.username}';

    t += 'Age: ${user.age}\n';

    t += 'Height: ${user.height}\n';

    t += 'Weight: ${user.weight}\n';

    return t;
  }
}
