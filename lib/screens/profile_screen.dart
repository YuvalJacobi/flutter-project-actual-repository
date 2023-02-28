import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileScreen> {
  Widget authForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
      ),
      // body:
    );
  }

  @override
  Widget build(BuildContext context) {
    return authForm();
  }
}
