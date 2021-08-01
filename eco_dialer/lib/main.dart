import 'package:eco_dialer/providers/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'screens/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => HomePageProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Color textMainColor = Color(0xFFCDCDCD);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EcoDialer',
        theme: ThemeData(
            primaryColor: Color(0xFF010A18),
            accentColor: Color(0xFF111A29),
            dividerColor: Color(0xFF707070),
            primarySwatch: Colors.grey,
            textTheme: TextTheme(
                headline1: GoogleFonts.montserrat(
                    color: textMainColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                headline2: GoogleFonts.montserrat(
                  color: textMainColor,
                  fontSize: 15,
                ),
                headline3: GoogleFonts.montserrat(
                    color: textMainColor, fontSize: 12))),
        home: HomePage(
          title: 'ecoDialer',
        ));
  }
}
