import 'dart:async';

import 'package:eco_dialer/domains/shared_preferences/shared_preferences.dart';
import 'package:eco_dialer/models/my_observer_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class TimerProvider extends MyObserver with ChangeNotifier {
  late SharedPrefs _sharedPrefs;
  late String expTime;
  late Timer? _timer;
  Duration timeLeft = Duration(seconds: 0);

  TimerProvider() {
    _sharedPrefs = SharedPrefs.getInstance();
    _sharedPrefs.addObserver(this, ObserverTag.time);

    initiateTimer();
  }

  void initiateTimer() async {
    expTime = await _sharedPrefs.getPlanExpTime();

    if (expTime == 'none' || DateTime.parse(expTime).isBefore(DateTime.now())) {
      timeLeft = Duration(seconds: 0);
    } else {
      DateTime expDate = DateTime.parse(expTime);

      timeLeft = expDate.difference(DateTime.now());
      _startTimer();
    }
  }

  void _startTimer() async {
    if (timeLeft == Duration.zero) {
      notifyListeners();
      return;
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int secondsLeft = timeLeft.inSeconds;

      secondsLeft == 0
          ? _timer!.cancel()
          : timeLeft = Duration(seconds: secondsLeft - 1);
      notifyListeners();
    });
  }

  void _updateTimer() {
    _timer?.cancel();
    _startTimer();
  }

  void _updatePlanExpiryTime(String updatedInfo) {
    expTime = updatedInfo;

    if (expTime == 'none' || DateTime.parse(expTime).isBefore(DateTime.now())) {
      timeLeft = Duration.zero;
      notifyListeners();
      return;
    } else {
      timeLeft = DateTime.parse(expTime).difference(DateTime.now());
      _updateTimer();
    }
  }

  @override
  void update({updatedInfo}) {
    _updatePlanExpiryTime(updatedInfo as String);
  }
}
