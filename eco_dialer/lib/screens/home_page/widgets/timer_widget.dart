import 'dart:async';

import 'package:eco_dialer/constants/colors.dart';
import 'package:eco_dialer/domains/shared_preferences/shared_preferences.dart';
import 'package:eco_dialer/embossed_container.dart';
import 'package:eco_dialer/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    var themeData = NeumorphicTheme.of(context)!;
    Constants constants = Constants(
        currentTheme: themeData.isUsingDark ? ThemeMode.dark : ThemeMode.light);

    final devHeight = MediaQuery.of(context).size.height;
    final devWidth = MediaQuery.of(context).size.width;

    Duration timeLeft = timerProvider.timeLeft;
    bool red = timeLeft < Duration(minutes: 10) && timeLeft != Duration.zero;

    return EmbossedContainer(
      height: timeLeft != Duration.zero ? devHeight * 0.35 : devHeight * 0.3,
      padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text('Last plan activated with ecoDialer expires in:',
                  style: themeData.current!.textTheme.bodyText1),
            ),
            Expanded(
                flex: 5,
                child: Container(
                  // color: Colors.red,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _timeSquare(timeLeft, 'Hours', themeData, red),
                        Spacer(flex: 1),
                        _colonSeparator(),
                        Spacer(
                          flex: 1,
                        ),
                        _timeSquare(timeLeft, 'Minutes', themeData, red),
                        Spacer(flex: 1),
                        _colonSeparator(),
                        Spacer(
                          flex: 1,
                        ),
                        _timeSquare(timeLeft, 'Seconds', themeData, red)
                      ]),
                )),
            SizedBox(
              height: 10,
            ),
            if (timeLeft != Duration.zero)
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      timerActionButton(
                          themeData,
                          constants.blackOpacity,
                          constants.whiteOpacity,
                          Icons.calendar_today,
                          Constants.green, callBack: () {
                        _showDate(context, themeData, constants.blackOpacity,
                            constants.whiteOpacity);
                      }),
                      timerActionButton(
                          themeData,
                          constants.blackOpacity,
                          constants.whiteOpacity,
                          Icons.stop,
                          Constants.red, callBack: () async {
                        try {
                          bool confirmed = await _confirmCancel(
                              context,
                              themeData,
                              constants.blackOpacity,
                              constants.whiteOpacity);
                          if (confirmed) {
                            SharedPrefs.getInstance().clearExpTime();
                          }
                        } catch (e) {
                          _showToastMessage('User Cancelled operation');
                        }
                      })
                    ],
                  ))
          ],
        ),
      ),
    );
  }

  NeumorphicButton timerActionButton(NeumorphicThemeInherited themeData,
      double blackOpacity, double whiteOpacity, IconData icon, Color color,
      {VoidCallback? callBack}) {
    return NeumorphicButton(
        padding: EdgeInsets.all(10),
        style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            color: themeData.current!.baseColor,
            intensity: 5,
            depth: 6,
            shadowDarkColor: Colors.black.withOpacity(blackOpacity),
            shadowLightColor: Colors.white.withOpacity(whiteOpacity)),
        onPressed: callBack ??
            () {
              print('hello');
            },
        child: FittedBox(
          child: Icon(
            icon,
            color: color,
          ),
        ));
  }

  Widget _timeSquare(Duration timeLeft, String unit,
      NeumorphicThemeInherited themeData, bool red) {
    late String displayText;
    Constants constants = Constants(
        currentTheme: themeData.isUsingDark ? ThemeMode.dark : ThemeMode.dark);

    switch (unit) {
      case 'Hours':
        displayText = timeLeft.inHours.toString().padLeft(2, '0');
        break;

      case 'Minutes':
        displayText =
            timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0');
        break;

      case 'Seconds':
        displayText =
            timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
        break;
    }

    return Expanded(
      flex: 6,
      child: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                displayText,
                style: red
                    ? themeData.current!.textTheme.headline1!
                        .copyWith(color: Constants.red, fontSize: 30)
                    : themeData.current!.textTheme.headline1!
                        .copyWith(fontSize: 50),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                unit,
                style: red
                    ? themeData.current!.textTheme.bodyText1!
                        .copyWith(color: Constants.red)
                    : themeData.current!.textTheme.bodyText1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _colonSeparator() {
    return Text(
      ':',
      style: TextStyle(color: Colors.white),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _confirmCancel(
      BuildContext context,
      NeumorphicThemeInherited themeData,
      double blackOpacity,
      double whiteOpacity) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: themeData.current!.baseColor,
            title: Text(
              'Confirm Reset',
              style: themeData.current!.textTheme.headline2,
            ),
            content: Text(
              'Are you sure that you want to reset the timer? \n\n(If you have an active plan this will not cancel auto-renewal)',
              style: themeData.current!.textTheme.bodyText1,
            ),
            actionsPadding: EdgeInsets.only(bottom: 20, left: 13, right: 13),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              NeumorphicButton(
                  padding: EdgeInsets.all(10),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      color: themeData.current!.baseColor,
                      intensity: 5,
                      depth: 6,
                      shadowDarkColor: Colors.black.withOpacity(blackOpacity),
                      shadowLightColor: Colors.white.withOpacity(whiteOpacity)),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'No',
                    style: themeData.current!.textTheme.bodyText1,
                  )),
              NeumorphicButton(
                  padding: EdgeInsets.all(10),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      color: themeData.current!.baseColor,
                      intensity: 5,
                      depth: 6,
                      shadowDarkColor: Colors.black.withOpacity(blackOpacity),
                      shadowLightColor: Colors.white.withOpacity(whiteOpacity)),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Yes',
                    style: themeData.current!.textTheme.bodyText1,
                  ))
            ],
          );
        });
  }

  Future<void> _showDate(
    BuildContext context,
    NeumorphicThemeInherited themeData,
    double blackOpacity,
    double whiteOpacity,
  ) async {
    SharedPrefs sharedPrefs = SharedPrefs.getInstance();
    String result = await sharedPrefs.getPlanExpTime();
    DateTime expTime = DateTime.parse(result);

    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: themeData.current!.baseColor,
            title: Text(
              'Expiry Date',
              style: themeData.current!.textTheme.headline2,
            ),
            content: RichText(
              text: TextSpan(
                  style: themeData.current!.textTheme.bodyText1,
                  children: [
                    TextSpan(
                        text:
                            'The last plan that you activated with ecoDialer expires on '),
                    TextSpan(
                        text: '${_weekday(expTime.weekday)} ${expTime.day}'),
                    TextSpan(text: ' at '),
                    TextSpan(
                        text:
                            '${expTime.hour}:${expTime.minute.toStringAsFixed(2)}')
                  ]),
            ),
            actionsPadding: EdgeInsets.only(bottom: 20, left: 13, right: 13),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              NeumorphicButton(
                  padding: EdgeInsets.all(10),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      color: themeData.current!.baseColor,
                      intensity: 5,
                      depth: 6,
                      shadowDarkColor: Colors.black.withOpacity(blackOpacity),
                      shadowLightColor: Colors.white.withOpacity(whiteOpacity)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Ok',
                    style: themeData.current!.textTheme.bodyText1,
                  ))
            ],
          );
        });
  }

  String _weekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';

      case 2:
        return 'Tuesday';

      case 3:
        return 'Wednesday';

      case 4:
        return 'Thursday';

      case 5:
        return 'Fiday';

      case 6:
        return 'Saturday';

      case 7:
        return 'Sunday';

      default:
        return 'Error';
    }
  }

  void _showToastMessage(String message) =>
      Fluttertoast.showToast(msg: message, fontSize: 13);
}
