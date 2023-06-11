import 'package:flutter/material.dart';

class TimerElapsing extends ChangeNotifier {
  /// initialize interval's value.
  int remaining_interval = 0;

  void decrease() {
    // decrement interval by 1.
    remaining_interval--;
  }
}
