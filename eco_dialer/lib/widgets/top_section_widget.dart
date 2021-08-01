import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eco_dialer/providers/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopSection extends StatelessWidget {
  const TopSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    var homePageProvider = Provider.of<HomePageProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        AnimatedTextKit(
          animatedTexts: [
            RotateAnimatedText(
              'Dial Service Numbers Quickly!',
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFCDCDCD)),
              //  speed: const Duration(milliseconds: 100),
            ),
            RotateAnimatedText(
              'Autoumatically Cancel Auto Renew!',
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFCDCDCD)),
              //  speed: const Duration(milliseconds: 100),
            ),
            TypewriterAnimatedText(
              'Save Money With ecoDialer!',
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFCDCDCD)),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 10,
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
        Row(children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                primary: _themeData.accentColor, elevation: 10),
            child: DropdownButton<String>(
              onChanged: (String? text) {
                homePageProvider.setServiceProvider(text!);
              },
              value: homePageProvider.serviceProvider,
              iconEnabledColor: Colors.green,
              dropdownColor: _themeData.accentColor,
              underline: Offstage(),
              items: [
                ...homePageProvider.serviceProviders
                    .map((provider) => DropdownMenuItem(
                          child: Text(provider,
                              style: _themeData.textTheme.headline2),
                          value: provider,
                        ))
                    .toList()
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                primary: _themeData.accentColor, elevation: 10),
            child: DropdownButton<String>(
              onChanged: (String? text) {
                homePageProvider.setSelectedCategory(text!);
              },
              value: homePageProvider.selectedCategory,
              iconEnabledColor: Colors.green,
              dropdownColor: _themeData.accentColor,
              underline: Offstage(),
              items: [
                ...homePageProvider.categories
                    .map((provider) => DropdownMenuItem(
                          child: Text(provider,
                              style: _themeData.textTheme.headline2),
                          value: provider,
                        ))
                    .toList()
              ],
            ),
          ),
        ])
      ]),
    );
  }
}
