import 'package:flutter/material.dart';

class TimerElapsing extends ChangeNotifier {
  int remaining_interval = 0;

  void decrease() {
    remaining_interval--;
  }
}
