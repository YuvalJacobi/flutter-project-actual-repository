import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/auth_provider.dart';
import 'package:flutter_complete_guide/provider/daily_plan_provider.dart';
import 'package:flutter_complete_guide/provider/dish_provider.dart';
import 'package:flutter_complete_guide/provider/ingredient_provider.dart';
import 'package:flutter_complete_guide/provider/weekly_plan_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthScreen> {
  // final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = "";
  var _userName = "";
  var _userPassword = "";
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      try {
        Provider.of<IngredientProvider>(context, listen: false)
            .fetchData()
            .then((_) {
          Provider.of<DishProvider>(context, listen: false)
              .fetchData()
              .then((_) {
            Provider.of<DailyPlanProvider>(context, listen: false)
                .fetchData()
                .then((_) {
              Provider.of<WeeklyPlanProvider>(context, listen: false)
                  .fetchData()
                  .then((_) {
                _isLoading = false;
                setState(() {
                  _isInit = false;
                });
              });
            });
          });
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      Provider.of<Auth>(context, listen: false).submitAuthForm(
          _userEmail.trim(),
          _userPassword.trim(),
          _userName.trim(),
          _isLoading,
          context);
    }
  }

  Widget authForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication screen'),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () => {
                    if (_isLogin)
                      {
                        FirebaseAuth.instance.signOut(),
                      },
                  },
              child: Text('Sign out'))
        ],
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
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                      ),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Please enter at least 4 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value;
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

  @override
  Widget build(BuildContext context) {
    return authForm();
  }
}
