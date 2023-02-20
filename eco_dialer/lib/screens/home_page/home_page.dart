import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eco_dialer/constants/colors.dart';
import 'package:eco_dialer/screens/home_page/number_section_widget.dart';
import 'package:eco_dialer/screens/home_page/widgets/renewal_options.dart';
import 'package:eco_dialer/screens/home_page/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  late String title;

  HomePage({Key? key, required title}) : super(key: key) {
    this.title = title;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool lightMode = true;

  @override
  Widget build(BuildContext context) {
    final _themeData = NeumorphicTheme.of(context);
    final _devHeight = MediaQuery.of(context).size.height;
    final _devWidth = MediaQuery.of(context).size.width;

    final themeClass = Provider.of<Pallete>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: _themeData!.current!.baseColor,
        toolbarHeight: _devHeight * 0.10,
        elevation: 0,
        title: Text(
          widget.title,
          style:
              _themeData.current!.textTheme.headline2!.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          // NeumorphicSwitch(
          //     height: 25.0,
          //     value: lightMode,
          //     onChanged: (value) {
          //       setState(() {
          //         lightMode = !lightMode;
          //       });

          //       if (lightMode) {
          //         themeClass.toggleThemeMode('Light');
          //       } else {
          //         themeClass.toggleThemeMode('Dark');
          //       }
          //     })
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(15),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            TimerWidget(),
            SizedBox(height: 30),
            RenewalOptions(),
            SizedBox(
              height: 60,
            ),
            NumberSection(),
          ],
        ),
      ),
    );
  }
}
