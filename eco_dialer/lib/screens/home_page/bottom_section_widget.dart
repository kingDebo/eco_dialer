import 'dart:async';

import 'package:eco_dialer/constants/colors.dart';
import 'package:eco_dialer/domains/shared_preferences/shared_preferences.dart';
import 'package:eco_dialer/embossed_container.dart';
import 'package:eco_dialer/providers/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'widgets/contactNumber_dialog.dart';

class NumberList extends StatefulWidget {
  const NumberList({
    Key? key,
  }) : super(key: key);

  @override
  State<NumberList> createState() => _NumberListState();
}

class _NumberListState extends State<NumberList> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final themeData = NeumorphicTheme.of(context)!;
    final constants = Constants(
        currentTheme: themeData.isUsingDark ? ThemeMode.dark : ThemeMode.light);

    final arrowColor = themeData.isUsingDark == ThemeMode.light
        ? Pallete.textColorLight
        : Pallete.textColorDark;

    var homePageProvider = Provider.of<HomePageProvider>(context);
    String serviceProvider = homePageProvider.serviceProvider;
    String selectedCategory = homePageProvider.selectedCategory;
    List numbers = homePageProvider.numbers[serviceProvider]![
        selectedCategory]!; //list of numbers depends on the selected service provider and selected category

    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return Column(children: [
      ...homePageProvider.categories[homePageProvider.serviceProvider]!
          .map((category) {
        return Column(
          children: [
            NumberCards(
              key: UniqueKey(),
              category: category,
            ),
            SizedBox(
              height: 40,
            )
          ],
        );
      }).toList()
    ]);
  }
}

class NumberCards extends StatefulWidget {
  NumberCards({Key? key, required this.category}) : super(key: key);
  late String category;
  @override
  _NumberCardsState createState() => _NumberCardsState();
}

class _NumberCardsState extends State<NumberCards> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);

    final themeData = NeumorphicTheme.of(context)!;
    Constants constants = Constants(
        currentTheme: themeData.isUsingDark ? ThemeMode.dark : ThemeMode.light);

    final iconColor = constants.currentTheme == ThemeMode.dark
        ? Pallete.textColorDark
        : Pallete.textColorLight;

    var devHeight = MediaQuery.of(context).size.height;
    var devWidth = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints:
          BoxConstraints.tightFor(height: isOpen ? devHeight * 0.8 : 125),
      child: Container(
        width: devWidth,
        child: Stack(
          fit: StackFit.expand,
          children: [
            EmbossedContainer(
              constraints: BoxConstraints.expand(),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.fromLTRB(20, isOpen ? 90 : 50, 20, 15),
                child: Column(
                  mainAxisAlignment: isOpen
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (isOpen) ...[
                      ...homePageProvider.numbers[homePageProvider
                              .serviceProvider]![widget.category]!
                          .map((number) => EmbossedContainer(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${number['action']}'),
                                    NeumorphicButton(
                                      style: NeumorphicStyle(
                                          shape: NeumorphicShape.flat,
                                          color: themeData.current!.baseColor,
                                          intensity: 5,
                                          depth: 6,
                                          shadowDarkColor: Colors.black
                                              .withOpacity(
                                                  constants.blackOpacity),
                                          shadowLightColor: Colors.white
                                              .withOpacity(
                                                  constants.whiteOpacity)),
                                      padding: EdgeInsets.all(5),
                                      onPressed: () {
                                        _callNumber(
                                            number['number'],
                                            widget.category,
                                            number['action'],
                                            context,
                                            number['cost'],
                                            number['duration']);
                                      },
                                      child: Icon(
                                        Icons.call,
                                        color: iconColor,
                                      ),
                                    )
                                  ],
                                ),
                              )))
                          .toList()
                    ],
                    Icon(
                      Icons.apps,
                      size: 30,
                      color: iconColor.withOpacity(0.2),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              top: 0,
              child: NeumorphicButton(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                onPressed: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.category}',
                      style: themeData.current!.textTheme.headline2,
                    ),
                    Icon(
                      isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 40,
                      color: iconColor,
                    )
                  ],
                ),
                style: NeumorphicStyle(
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                    shape: NeumorphicShape.flat,
                    color: themeData.current!.baseColor,
                    intensity: 5,
                    depth: 6,
                    shadowDarkColor:
                        Colors.black.withOpacity(constants.blackOpacity),
                    shadowLightColor:
                        Colors.white.withOpacity(constants.whiteOpacity)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callNumber(String number, String selectedCategory, String action,
      BuildContext context,
      [String? cost, int? duration]) async {
    if (selectedCategory == 'Combo Plans' || selectedCategory == 'Data Plans') {
      try {
        bool shouldContinue = await _confirmContinue(context, cost!, action);
        if (!shouldContinue) return;
        FlutterPhoneDirectCaller.callNumber(number);

        SharedPrefs sharedPrefs = SharedPrefs.getInstance();
        String expTime =
            DateTime.now().add(Duration(hours: duration!)).toString();
        sharedPrefs.setPlanExpTime(expTime);
      } catch (e) {
        _showToastMessage('User Cancelled Operation');
      }
    } else if (action == 'Please call me') {
      try {
        String contactNumber = await _getContactNumber(context);
        FlutterPhoneDirectCaller.callNumber('*126*1767$contactNumber#');
      } catch (e) {
        _showToastMessage('User Cancelled Operation');
      }
    } else {
      FlutterPhoneDirectCaller.callNumber(number);
    }
    // print('Number Dialed');
    // await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<bool> _confirmContinue(
      BuildContext context, String cost, String action) async {
    final themeData = NeumorphicTheme.of(context)!;
    Constants constants = Constants(
        currentTheme: themeData.isUsingDark ? ThemeMode.dark : ThemeMode.light);
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: NeumorphicTheme.of(context)!.current!.baseColor,
            content: Text(
                'Are you sure you want to purchase a $action plan for $cost?',
                style: NeumorphicTheme.of(context)!
                    .current!
                    .textTheme
                    .headline2!
                    .copyWith(height: 1.5)),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              NeumorphicButton(
                  padding: EdgeInsets.all(10),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      color: themeData.current!.baseColor,
                      intensity: 5,
                      depth: 6,
                      shadowDarkColor:
                          Colors.black.withOpacity(constants.blackOpacity),
                      shadowLightColor:
                          Colors.white.withOpacity(constants.whiteOpacity)),
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
                      shadowDarkColor:
                          Colors.black.withOpacity(constants.blackOpacity),
                      shadowLightColor:
                          Colors.white.withOpacity(constants.whiteOpacity)),
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

  Future<String> _getContactNumber(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return ContactNumberDialog();
        });
  }

  void _showToastMessage(String message) =>
      Fluttertoast.showToast(msg: message, fontSize: 13);
}
