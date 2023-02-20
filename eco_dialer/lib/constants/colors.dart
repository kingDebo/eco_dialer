import 'package:eco_dialer/domains/shared_preferences/shared_preferences.dart';
import 'package:eco_dialer/models/my_observer_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Constants {
  Constants({required this.currentTheme});

  late ThemeMode currentTheme;

  static Color red = Color(0xFFFF5D5D);
  static Color green = Color(0xFF89BB8C);
  static BorderRadius borderRadius = BorderRadius.circular(25);

  get blackOpacity => currentTheme == ThemeMode.light ? 0.35 : 0.6;
  get whiteOpacity => currentTheme == ThemeMode.light ? 1 : 0.15;
}

class Pallete extends MyObserver with ChangeNotifier {
  Pallete() {
    _setThemeMode();
  }

  SharedPrefs sharedPrefs = SharedPrefs.getInstance();

  ThemeMode currentTheme = ThemeMode.system;

  static const Color textColorLight = Color(0xFF54606F);
  static const Color textColorDark = Color(0xFF9BA5B5);
  static TextStyle fontStyle = GoogleFonts.nunitoSans();

  final lightDialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    backgroundColor: Color(0xFFE5EBF3),
  );

  final darkDialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    backgroundColor: Color(0xFF111A29),
  );

  NeumorphicThemeData lightTheme = NeumorphicThemeData(
    baseColor: Color(0xFFE5EBF3),
    textTheme: TextTheme(
      displayLarge: fontStyle.copyWith(
          fontSize: 60, fontWeight: FontWeight.normal, color: textColorLight),
      displayMedium: fontStyle.copyWith(
          fontSize: 18, fontWeight: FontWeight.bold, color: textColorLight),
      bodyLarge: fontStyle.copyWith(
          fontSize: 15, fontWeight: FontWeight.normal, color: textColorLight),
    ),
  );

  NeumorphicThemeData darkTheme = NeumorphicThemeData(
    baseColor: Color(0xFF111A29),
    textTheme: TextTheme(
        displayLarge: fontStyle.copyWith(
            fontSize: 60, fontWeight: FontWeight.normal, color: textColorDark),
        displayMedium: fontStyle.copyWith(
            fontSize: 18, fontWeight: FontWeight.bold, color: textColorDark),
        bodyLarge: fontStyle.copyWith(
            fontSize: 15, fontWeight: FontWeight.normal, color: textColorDark)),
  );

  void _setThemeMode([String? themeMode]) async {
    if (themeMode == null) {
      themeMode = await sharedPrefs.getThemeMode();
    }

    switch (themeMode) {
      case 'System':
        currentTheme = ThemeMode.system;
        break;

      case 'Dark':
        currentTheme = ThemeMode.dark;
        break;

      case 'Light':
        currentTheme = ThemeMode.light;
        break;

      default:
        currentTheme = ThemeMode.system;
        break;
    }
    notifyListeners();
  }

  void toggleThemeMode(String mode) {
    switch (mode) {
      case 'Light':
        currentTheme = ThemeMode.light;
        sharedPrefs.setThemeMode('Light');
        break;

      case 'Dark':
        currentTheme = ThemeMode.dark;
        sharedPrefs.setThemeMode('Dark');
        break;

      default:
        break;
    }

    notifyListeners();
  }

  @override
  void update({updatedInfo}) {
    _setThemeMode();
  }
}
