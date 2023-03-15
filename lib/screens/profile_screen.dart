import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/user.dart' as UserModel;
import 'package:flutter_complete_guide/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  Widget profileForm() {
    UserModel.User user = Provider.of<UserModel.User>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          title: Text('Profile Screen'),
        ),
        body: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text('Username'),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty || value.length > 12) {
                    return 'Invalid username';
                  }
                  return null;
                },
                initialValue: user.username,
              ),
            )
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return profileForm();
  }
}
