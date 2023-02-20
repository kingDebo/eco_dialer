import 'package:eco_dialer/constants/colors.dart';
import 'package:eco_dialer/domains/shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class RenewalOptions extends StatelessWidget {
  const RenewalOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = NeumorphicTheme.of(context)!;
    final constants = Constants(
        currentTheme: themeData.isUsingDark ? ThemeMode.dark : ThemeMode.light);

    return NeumorphicButton(
        padding: EdgeInsets.all(20),
        style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
            shape: NeumorphicShape.flat,
            color: themeData.current!.baseColor,
            intensity: 5,
            depth: 6,
            shadowDarkColor: Colors.black.withOpacity(constants.blackOpacity),
            shadowLightColor: Colors.white.withOpacity(constants.whiteOpacity)),
        onPressed: () {
          FlutterPhoneDirectCaller.callNumber('*363*1#');
          SharedPrefs.getInstance().clearExpTime();
        },
        child: Center(
          child: Text('Cancel Auto Renewal',
              style: themeData.current!.textTheme.headline2!
                  .copyWith(color: Constants.green)),
        ));
  }
}
