import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_complete_guide/provider/exercise_in_plan_provider.dart';
import 'package:flutter_complete_guide/provider/exercise_provider.dart';
import 'package:flutter_complete_guide/provider/plan_in_progress_provider.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:flutter_complete_guide/screens/home_screen.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/widgets/timer_elapsing.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return multi provider fed with all providers and screen.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerElapsing()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PlanInProgressProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseInPlanProvider()),
      ],
      child: MaterialApp(
        title: 'Our Fitness',
        theme: ThemeData(
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.pink,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
              .copyWith(background: Colors.blueGrey)
              .copyWith(secondary: Colors.deepPurple)
              .copyWith(brightness: Brightness.dark),
        ),
        home: formToOpen(),
      ),
    );
  }

  // return home screen if user is connected, if not then refer to auth screen.
  Widget formToOpen() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, usersnapshot) {
        if (usersnapshot.hasData) {
          User user = usersnapshot.data! as User;

          Provider.of<UserProvider>(context, listen: false).myUser.user_id =
              user.uid;

          return HomeScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
