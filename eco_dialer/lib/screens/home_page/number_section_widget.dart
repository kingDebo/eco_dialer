import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eco_dialer/constants/colors.dart';
import 'package:eco_dialer/providers/homepage_provider.dart';
import 'package:eco_dialer/screens/home_page/bottom_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';


class NumberSection extends StatelessWidget {
  const NumberSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = NeumorphicTheme.of(context)!;
    final constants = Constants(
        currentTheme: themeData.isUsingDark ? ThemeMode.dark : ThemeMode.light);
    var homePageProvider = Provider.of<HomePageProvider>(context);

    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Align(
            alignment: Alignment.centerLeft,
            child: NeumorphicButton(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              onPressed: () {},
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
              child: DropdownButton<String>(
                onChanged: (String? text) {
                  homePageProvider.setServiceProvider(text!);
                },
                value: homePageProvider.serviceProvider,
                iconEnabledColor: Constants.green,
                dropdownColor: themeData.current!.baseColor,
                underline: Offstage(),
                items: [
                  ...homePageProvider.serviceProviders
                      .map((provider) => DropdownMenuItem(
                            child: Text(provider,
                                style: themeData.current!.textTheme.headline2),
                            value: provider,
                          ))
                      .toList()
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          NumberList()
        ]));
  }
}
