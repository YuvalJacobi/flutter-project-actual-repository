// import 'package:flutter/material.dart';

// class AuthForm extends StatefulWidget {
//   AuthForm(
//     this.submitFn,
//     this.isLoading,
//   );

//   final bool isLoading;

//   @override
//   _AuthFormState createState() => _AuthFormState();
// }

// class _AuthFormState extends State<AuthForm> {
//   final _formKey = GlobalKey<FormState>();
//   var _isLogin = true;
//   var _userEmail = '';
//   var _userName = '';
//   var _userPassword = '';

//   void _trySubmit() {
//     final isValid = _formKey.currentState.validate();
//     FocusScope.of(context).unfocus();

//     if (isValid) {
//       _formKey.currentState.save();
//       widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
//           _isLogin, context);
//     }
//   }
// }
