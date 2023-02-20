
import 'package:eco_dialer/models/my_observer_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs extends ChangeNotifier with MyObservable {
  static SharedPrefs? _mysharedPrefs;

  SharedPrefs._privateConstructor();

  static SharedPrefs getInstance() {
    return _mysharedPrefs ??= SharedPrefs._privateConstructor();
  }

  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

  final String _planExp = 'planExp';
  final String _themeMode = 'themeMode';

//Getter for Plan Expiry
  Future<String> getPlanExpTime() async {
    try {
      String? result =
          await sharedPrefs.then((prefs) => prefs.getString(_planExp));
      return result ?? 'none'; //returns none if no date is found
    } catch (e) {
      print('error: $e');
      return 'none'; //returns none if an error occured
    }
  }

//Say no expTime
  Future<void> clearExpTime() async {
    try {
      await sharedPrefs.then((prefs) => prefs.setString('$_planExp', 'none'));
      await notifyAllTime();
    } catch (e) {
      return;
    }
  }

//Setter for Plan Expiry
  Future<void> setPlanExpTime(String value) async {
    try {
      await sharedPrefs.then((prefs) => prefs.setString('$_planExp', value));
      await notifyAllTime();
    } catch (e) {}
  }

  Future<String> getThemeMode() async {
    try {
      String? result =
          await sharedPrefs.then((prefs) => prefs.getString(_themeMode));
      return result ?? 'System'; //returns System if no Thememode is found
    } catch (e) {
      return 'System'; //returns System if an error occured
    }
  }

//Get the current saved theme mode
  Future<void> setThemeMode(String value) async {
    if (value != 'System' || value != 'Dark' || value != 'Light')
      value = 'System';

    try {
      await sharedPrefs.then((prefs) => prefs.setString('$_themeMode', value));
      await notifyAllColor();
    } catch (e) {
      print('found error $e');
    }
  }

  @override
  void addObserver(observer, tag) {
    switch (tag) {
      case ObserverTag.color:
        this.colorObservers.add(observer);
        break;

      case ObserverTag.time:
        this.timeObservers.add(observer);
        break;

      default:
        break;
    }
  }

  @override
  Future<void> notifyAllTime() async {
    String updatedInfo = await getPlanExpTime();
    this.timeObservers.forEach((observer) {
      observer.update(updatedInfo: updatedInfo);
    });
  }

  @override
  Future<void> notifyAllColor() async {
    String updatedInfo = await getThemeMode();
    this.colorObservers.forEach((observer) {
      observer.update(updatedInfo: updatedInfo);
    });
  }

  @override
  void removeObserver(observer) {
    if (colorObservers.contains(observer)) {
      colorObservers.remove(observer);
    } else if (timeObservers.contains(observer)) {
      timeObservers.remove(observer);
    }
  }
}
