
import 'package:eco_dialer/models/my_observer_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_dialer/domains/shared_preferences/shared_preferences.dart';

class TestObserver extends MyObserver {
  String status = "not updated";

  @override
  void update({updatedInfo}) {
    status = updatedInfo;
  }
}

void main() {
  test('Sharedprefs is singleton', () {
    SharedPrefs sharedPrefs1 = SharedPrefs.getInstance();
    SharedPrefs sharedPrefs2 = SharedPrefs.getInstance();

    expect(sharedPrefs1, sharedPrefs2);
  });

  test('The data passed into the keys should be set and able to be read',
      () async {
    //setting keys
    String planExp = 'planExp';

    //initializing shared preferences
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    //setting value
    await prefs.then((prefs) => prefs.setString(planExp, 'Today'));

    //reading value
    var result = await prefs.then((prefs) => prefs.getString(planExp));

    //assertions
    expect(result, 'Today');
  });

  test('SharedPrefs class Test: Setting and Getting Values', () async {
    //setting key
    String planExp = 'planExp';

    //initializing class
    SharedPrefs sharedPrefs = SharedPrefs.getInstance();

    //setting value
    sharedPrefs.setPlanExpTime('Tomorrow');

    //retrieving value
    var result = await sharedPrefs.getPlanExpTime();

    //assertions
    expect(result, 'Tomorrow');
  });

  test('SharedPrefs Sets formatted DateString', () async {
    SharedPrefs sharedPrefs = SharedPrefs.getInstance();

    DateTime date = DateTime.now().add(Duration(days: 2));
    sharedPrefs.setPlanExpTime(date.toString());

    String? expected = date.toString();
    String? actual = await sharedPrefs.getPlanExpTime();

    expect(actual, expected);

    //test to see if the date parsed gives the same result
    expect(date, DateTime.parse(actual));
  });

  group('Observers registering and unregistering', () {
    SharedPrefs sharedPrefs = SharedPrefs.getInstance();

    TestObserver myObserver = new TestObserver();
    TestObserver myObserver2 = new TestObserver();
    test(': Observers registering correctly', () {
      sharedPrefs.addObserver(myObserver, ObserverTag.time);
      sharedPrefs.addObserver(myObserver2, ObserverTag.color);

      expect(sharedPrefs.timeObservers.contains(myObserver), true);
      expect(sharedPrefs.colorObservers.contains(myObserver2), true);

      expect(sharedPrefs.colorObservers.contains(myObserver), false);
      expect(sharedPrefs.timeObservers.contains(myObserver2), false);
    });

    test(': Observers unregistering correctly', () {
      sharedPrefs.removeObserver(myObserver);
      sharedPrefs.removeObserver(myObserver2);

      expect(sharedPrefs.timeObservers.contains(myObserver), false);
      expect(sharedPrefs.colorObservers.contains(myObserver2), false);
    });
  });

  group('Observers are being updated for time: ', () {
    SharedPrefs sharedPrefs = SharedPrefs.getInstance();

    TestObserver myObserver = new TestObserver();
    TestObserver myObserver2 = new TestObserver();
    TestObserver myObserver3 = new TestObserver();
    TestObserver myObserver4 = new TestObserver();

    test('Observers are initially not updated', () {
      expect(myObserver.status, 'not updated');
      expect(myObserver2.status, 'not updated');
      expect(myObserver3.status, 'not updated');
      expect(myObserver4.status, 'not updated');
    });

    sharedPrefs.addObserver(myObserver, ObserverTag.time);
    sharedPrefs.addObserver(myObserver2, ObserverTag.time);
    sharedPrefs.addObserver(myObserver3, ObserverTag.time);
    sharedPrefs.addObserver(myObserver4, ObserverTag.color);

    test('Adding Observers does not update them', () {
      expect(myObserver.status, 'not updated');
      expect(myObserver2.status, 'not updated');
      expect(myObserver3.status, 'not updated');
      expect(myObserver4.status, 'not updated');
    });

    test('update time', () async {
      await sharedPrefs.clearExpTime();
    });

    test('Time observers are updated', () {
      expect(myObserver.status, 'none');
      expect(myObserver2.status, 'none');
      expect(myObserver3.status, 'none');
    });

    test('Color observer is not updated', () {
      expect(myObserver4.status, 'not updated');
    });

    tearDownAll(() {
      sharedPrefs.removeObserver(myObserver);
      sharedPrefs.removeObserver(myObserver2);
      sharedPrefs.removeObserver(myObserver3);
      sharedPrefs.removeObserver(myObserver4);
    });
  });

  group('Observers are being updated for color: ', () {
    SharedPrefs sharedPrefs = SharedPrefs.getInstance();

    TestObserver myObserver = new TestObserver();
    TestObserver myObserver2 = new TestObserver();
    TestObserver myObserver3 = new TestObserver();
    TestObserver myObserver4 = new TestObserver();

    test('Observers are initially not updated', () {
      expect(myObserver.status, 'not updated');
      expect(myObserver2.status, 'not updated');
      expect(myObserver3.status, 'not updated');
      expect(myObserver4.status, 'not updated');
    });

    sharedPrefs.addObserver(myObserver, ObserverTag.color);
    sharedPrefs.addObserver(myObserver2, ObserverTag.color);
    sharedPrefs.addObserver(myObserver3, ObserverTag.color);
    sharedPrefs.addObserver(myObserver4, ObserverTag.time);

    test('Adding Observers does not update them', () {
      expect(myObserver.status, 'not updated');
      expect(myObserver2.status, 'not updated');
      expect(myObserver3.status, 'not updated');
      expect(myObserver4.status, 'not updated');
    });

    test('update time', () async {
      await sharedPrefs.setThemeMode('System');
    });

    test('Color observers are updated', () {
      expect(myObserver.status, 'System');
      expect(myObserver2.status, 'System');
      expect(myObserver3.status, 'System');
    });

    test('Color observer is not updated', () {
      expect(myObserver4.status, 'not updated');
    });

    tearDownAll(() {
      sharedPrefs.removeObserver(myObserver);
      sharedPrefs.removeObserver(myObserver2);
      sharedPrefs.removeObserver(myObserver3);
      sharedPrefs.removeObserver(myObserver4);
    });
  });

  test('Shared Prefs handles error in themeMode name', () async {
    SharedPrefs sharedPrefs = SharedPrefs.getInstance();

    sharedPrefs.setThemeMode('Nonesense');

    var result = await sharedPrefs.getThemeMode();

    expect(result, 'System');
  });
}
