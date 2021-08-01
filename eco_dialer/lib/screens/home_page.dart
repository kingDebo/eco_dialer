import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eco_dialer/providers/homepage_provider.dart';
import 'package:eco_dialer/widgets/bottom_section_widget.dart';
import 'package:eco_dialer/widgets/top_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  late String title;

  HomePage({Key? key, required title}) : super(key: key) {
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    final _devHeight = MediaQuery.of(context).size.height;
    final _devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _themeData.primaryColor,
      appBar: AppBar(
        title: Text(
          title,
          style: _themeData.textTheme.headline1,
        ),
        centerTitle: true,
        backgroundColor: _themeData.accentColor,
      ),
      body: Column(
        children: [
          Expanded(flex: 2, child: TopSection()),
          Expanded(
            flex: 3,
            child: BottomSection(),
          ),
        ],
      ),
    );
  }
}
