import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/exercise_in_plan_provider.dart';
import 'package:flutter_complete_guide/provider/plan_in_progress_provider.dart';
import 'package:flutter_complete_guide/screens/exercise_in_progress_screen.dart';
import 'package:flutter_complete_guide/screens/plan_in_progress_screen.dart';
import 'package:flutter_complete_guide/provider/timer_elapsing.dart';
import 'package:provider/provider.dart';

import '../model/exercise_in_plan.dart';
import '../model/plan.dart';
import 'countdown_timer.dart';

void main() {
  runApp(Countdown());
}

class Countdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rest timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CountdownScreen(),
    );
  }
}

class CountdownScreen extends StatefulWidget {
  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  /// countdown time will be stored in this variable
  int _countdown = 0;

  /// current background color (when timer is active)
  Color _backgroundColor = Color.fromARGB(255, 144, 49, 47);

  void changeBackgroundColor() {
    setState(() {
      _backgroundColor = Colors.green;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Plan plan =
        Provider.of<PlanInProgressProvider>(context, listen: false).plan!;

    int index =
        Provider.of<PlanInProgressProvider>(context, listen: false).index;

    ExerciseInPlan exerciseInPlan =
        Provider.of<ExerciseInPlanProvider>(context, listen: false)
            .getExerciseInPlanById(plan.exercises_in_plan[index]);

    _countdown = exerciseInPlan.rest;

    debugPrint(
        "Countdown of exercise no.${index + 1}:" + _countdown.toString());

    countdown_timer = CountdownTimerWidget(
      durationInSeconds: _countdown,
      onInterval: handleInterval,
      onElapsed: handleElapsed,
    );
  }

  void handleInterval(int time) {
    /// update screen each second that passes
    setState(() {
      _countdown =
          Provider.of<TimerElapsing>(context, listen: false).remaining_interval;
    });

    /// returns after updating the screen with the new time remaining.
  }

  void handleElapsed() {
    /// Entered upon timer ending

    changeBackgroundColor();

    /// returns after changing background color
  }

  Text countdown_to_text() {
    /// convert time remaining to representable form

    /// minutes remaining
    int minutes = _countdown ~/ 60;

    /// seconds remaining
    int seconds = (_countdown % 60);

    /// formatting
    String minutes_str = minutes < 10 ? '0$minutes' : '$minutes';
    String seconds_str = seconds < 10 ? '0$seconds' : '$seconds';
    String time = '$minutes_str:$seconds_str';

    /// return Text which represents the time remaining
    return Text(
      time,
      style: TextStyle(fontSize: 48, color: Colors.white),
    );
  }

  void skipCountdown() {
    /// Called when the skip button is pressed

    /// get current index of set
    int set_index =
        Provider.of<PlanInProgressProvider>(context, listen: false).set_index;

    /// get current plan
    Plan plan =
        Provider.of<PlanInProgressProvider>(context, listen: false).plan!;

    /// get index of plan in progress
    int index =
        Provider.of<PlanInProgressProvider>(context, listen: false).index;

    /// get current exercise being done
    ExerciseInPlan current_exercise_in_plan =
        Provider.of<ExerciseInPlanProvider>(context, listen: false)
            .getExerciseInPlanById(plan.exercises_in_plan[index]);

    /// increment index of set by 1
    set_index += 1;

    /// check if all sets of exercise were completed
    if (set_index >= current_exercise_in_plan.sets) {
      /// navigate to plan in progress screen to proceed to next exercise
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => PlanInProgressScreen(),
        ));
      });
    } else {
      Future.delayed(Duration.zero, () {
        // globally increment set of index by 1
        Provider.of<PlanInProgressProvider>(context, listen: false).set_index +=
            1;

        // navigate to exercise screen without changing the exercise.
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => ExerciseInProgressScreen(),
        ));
      });
    }

    /// After navigator has pushed a new screen depending on the current state of the plan
    /// if last set of last exercise was done => go back to home screen
    /// else => go to next set
  }

  /// Countdown timer
  CountdownTimerWidget? countdown_timer = null;

  @override
  Widget build(BuildContext context) {
    /// returns UI elements which are shown on screen.
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(children: [
        countdown_timer!,
        Container(
            padding: EdgeInsets.only(top: 100),
            alignment: Alignment.center,
            child: Center(child: countdown_to_text())),
        Container(
          width: 150,
          height: 150,
          alignment: Alignment.bottomCenter,
          child: IconButton(
            icon: Icon(Icons.next_plan),
            onPressed: () => skipCountdown(),
          ),
        )
      ]),
    );
  }
}
