import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthScreen> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = "";
  var _userName = "";
  var _userPassword = "";

  void trySubmit() {
    // validate input.
    final isValid = _formKey.currentState!.validate();

    // remove focus
    FocusScope.of(context).unfocus();

    // if inpit is valid then try logging in or signing up (depending on which mode the user is currently in)
    if (isValid) {
      _formKey.currentState!.save();
      Provider.of<UserProvider>(context, listen: false).submitAuthForm(
          _userEmail.trim(),
          _userPassword.trim(),
          _userName.trim(),
          _isLogin,
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return authForm visual representation
    return authForm();
  }

  Widget authForm() {
    // return visual representation of screen.
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication screen'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                      ),
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter at least 4 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value!;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                    ),
                    SizedBox(height: 12),
                    if (_isLoading) CircularProgressIndicator(),
                    if (!_isLoading)
                      TextButton(
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'I already have an account'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      ),
                    if (!_isLoading)
                      ElevatedButton(
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                          onPressed: (() {
                            trySubmit();
                          })),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
