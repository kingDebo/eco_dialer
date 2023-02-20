import 'package:eco_dialer/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ContactNumberDialog extends StatefulWidget {
  const ContactNumberDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ContactNumberDialogState createState() => _ContactNumberDialogState();
}

class _ContactNumberDialogState extends State<ContactNumberDialog> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.unfocus();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = NeumorphicTheme.of(context)!;
    final constants = Constants(
        currentTheme: themeData.isUsingDark ? ThemeMode.dark : ThemeMode.light);

    final textColor =
        themeData.isUsingDark ? Pallete.textColorDark : Pallete.textColorLight;

    return AlertDialog(
      backgroundColor: themeData.current!.baseColor,
      title: Text(
        'Please Enter Receiver\'s Number: +1(767)',
        style: themeData.current!.textTheme.bodyText1,
      ),
      content: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border:
                UnderlineInputBorder(borderSide: BorderSide(color: textColor))),
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
                shadowDarkColor:
                    Colors.black.withOpacity(constants.blackOpacity),
                shadowLightColor:
                    Colors.white.withOpacity(constants.whiteOpacity)),
            onPressed: () {
              Navigator.pop(context, controller.value.text);
            },
            child: Text(
              'ok',
              style: themeData.current!.textTheme.bodyText1,
            ))
      ],
    );
  }
}
