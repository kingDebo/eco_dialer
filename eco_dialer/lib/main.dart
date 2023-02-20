import 'package:eco_dialer/constants/colors.dart';
import 'package:eco_dialer/providers/homepage_provider.dart';
import 'package:eco_dialer/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'screens/home_page/home_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => HomePageProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => TimerProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => Pallete(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Color textMainColor = Color(0xFFCDCDCD);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    var colorProvider = Provider.of<Pallete>(context);

    return NeumorphicApp(
        debugShowCheckedModeBanner: false,
        title: 'EcoDialer',
        theme: colorProvider.lightTheme,
        darkTheme: colorProvider.darkTheme,
        themeMode: colorProvider.currentTheme,
        home: HomePage(
          title: 'Eco Dialer',
        ));
  }
}
