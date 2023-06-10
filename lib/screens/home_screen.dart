import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise.dart';
import 'package:flutter_complete_guide/provider/exercise_in_plan_provider.dart';
import 'package:flutter_complete_guide/provider/exercise_provider.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/plans_screen.dart';
import 'package:flutter_complete_guide/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;

  List<String> backgrounds = [
    'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/ef3a4158-e0e0-418a-9e74-d273edb3a686/dfv0lfh-9a609923-a8e9-4469-af6e-6ec20504c069.png/v1/fill/w_622,h_350,q_70,strp/ruthless_world_by_wopgnop_dfv0lfh-350t.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjE2MCIsInBhdGgiOiJcL2ZcL2VmM2E0MTU4LWUwZTAtNDE4YS05ZTc0LWQyNzNlZGIzYTY4NlwvZGZ2MGxmaC05YTYwOTkyMy1hOGU5LTQ0NjktYWY2ZS02ZWMyMDUwNGMwNjkucG5nIiwid2lkdGgiOiI8PTM4NDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.fy2nSuhJ83rwagG9ETuCO-fh0rJNWGTunxFkCqZ4liU',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      try {
        Provider.of<PlanProvider>(context, listen: false)
            .fetchPlans(context)
            .then((_) => Provider.of<ExerciseProvider>(context, listen: false)
                .fetchExercises()
                .then((_) => Provider.of<UserProvider>(context, listen: false)
                    .fetchUserData(context)))
            .then((_) =>
                Provider.of<ExerciseInPlanProvider>(context, listen: false)
                    .fetchData()
                    .then((_) => setState(() => {_isInit = false})));
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  String name = 'Seated Weighted Dip';
  String level = 'Beginner';
  String category = 'Compound';
  List<String> active_muscles = ['Triceps', 'Chest'];
  String image_url =
      'https://static.strengthlevel.com/images/illustrations/seated-dip-machine-1000x1000.jpg';

  @override
  Widget build(BuildContext context) {
    /// return visual representation of screen
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Our Fitness"),
          backgroundColor: Colors.redAccent,
        ),
        drawer: myDrawer(),
        body: _isInit
            ? Center(child: CircularProgressIndicator())
            : Center(
                // child: ElevatedButton(
                //   child: Text('add'),
                //   onPressed: () {
                //     Provider.of<ExerciseProvider>(context, listen: false)
                //         .addNewExercise(
                //             name, level, category, active_muscles, image_url);
                //   },
                // ),
                ));
  }

  Image imageFromExercise(Exercise exercise) {
    /// returns image of exercise if the image_url is non-null.
    if (exercise.image_url.isEmpty) {
      // return white square
      return Image.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHFAD6nG4GX5NHYwDsmB8a_vwVY4DOxMqwPOiMVro&s');
    }

    /// return image of exercise from the network.
    return Image.network(
      exercise.image_url,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  Widget myExerciseWidget(Exercise exercise) {
    /// return a Container which represents the visualization of a single exercise.
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageFromExercise(exercise),
          SizedBox(height: 10),
          Text(
            exercise.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            exercise.category,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            exercise.level,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  NetworkImage randomBackground() {
    /// return random background
    int rnd = Random.secure().nextInt(backgrounds.length);
    return new NetworkImage(backgrounds[rnd]);
  }

  Widget myDrawer() {
    /// return drawer widget
    return new Drawer(
      child: Column(
        children: [
          Expanded(
            child: new ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: new Text(
                      Provider.of<UserProvider>(context, listen: false)
                          .myUser
                          .username),
                  accountEmail: new Text(
                      Provider.of<UserProvider>(context, listen: false)
                          .myUser
                          .email),
                  currentAccountPicture: new GestureDetector(
                    child: new CircleAvatar(
                      backgroundImage: new NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                    ),
                    onTap: () => print("This is your current account."),
                  ),
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: randomBackground(), fit: BoxFit.fill)),
                ),
                new ListTile(
                    title: new Text("View Profile"),
                    leading: new Icon(Icons.person),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new ProfileScreen()));
                    }),
                new Divider(),
                new ListTile(
                    title: new Text("View Plans"),
                    leading: new Icon(Icons.calendar_view_day),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new PlanScreen()));
                    }),
                new Divider(),
                new ListTile(
                  title: new Text("Cancel"),
                  leading: new Icon(Icons.cancel),
                  onTap: () => Navigator.pop(context),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 280, 0, 0),
                  alignment: Alignment.bottomCenter,
                  child: ListTile(
                    title: Text("Sign out"),
                    leading: Transform.scale(
                      child: new Icon(Icons.exit_to_app),
                      scaleX: -1,
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => AuthScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
