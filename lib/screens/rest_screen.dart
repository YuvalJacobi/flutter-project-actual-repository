import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  int _countdown = 10; // Change this to the desired countdown time
  Color _backgroundColor = Color.fromARGB(255, 144, 49, 47);

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
          _showNotification();
          _changeBackgroundColor();
        }
      });
    });
  }

  void _showNotification() {
    print('Rest time ended!');
  }

  void _changeBackgroundColor() {
    setState(() {
      _backgroundColor = Colors.green;
    });
  }

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  Text countdown_to_text() {
    int minutes = (_countdown / 60) as int;
    int seconds = (_countdown % 60);

    String minutes_str = minutes < 10 ? '0$minutes' : '$minutes';
    String seconds_str = seconds < 10 ? '0$seconds' : '$seconds';
    String time = '$minutes_str:$seconds_str';

    return Text(
      time,
      style: TextStyle(fontSize: 48, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(child: countdown_to_text()),
    );
  }
}
