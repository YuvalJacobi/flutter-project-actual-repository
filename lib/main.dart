import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_complete_guide/provider/daily_plan_provider.dart';
import 'package:flutter_complete_guide/provider/dish_provider.dart';
import 'package:flutter_complete_guide/provider/ingredient_provider.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:flutter_complete_guide/provider/weekly_plan_provider.dart';
import 'package:flutter_complete_guide/screens/MyListScreen.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:provider/provider.dart';
import 'provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => WeeklyPlanProvider()),
        ChangeNotifierProvider(create: (_) => DailyPlanProvider()),
        ChangeNotifierProvider(create: (_) => DishProvider()),
        ChangeNotifierProvider(create: (_) => IngredientProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Proximity Shopping',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          backgroundColor: Colors.blueGrey,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.pink,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        home: formToOpen(),
      ),
    );
  }

  Widget formToOpen() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, usersnapshot) {
        if (usersnapshot.hasData) {
          return MyListScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
