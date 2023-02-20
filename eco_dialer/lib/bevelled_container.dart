import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import 'constants/colors.dart';

class BevelledContainer extends StatelessWidget {
  BevelledContainer(
      {required this.child,
      this.height,
      this.width,
      this.constraints,
      this.padding,
      this.shape,
      this.radius});
  late Widget child;
  double? height;
  double? width;
  BoxConstraints? constraints;
  final EdgeInsets? padding;
  final BoxShape? shape;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final themeData = NeumorphicTheme.of(context)!;
    Constants constants = Constants(
        currentTheme: themeData.isUsingDark ? ThemeMode.dark : ThemeMode.light);

    final BorderRadius borderRadius = radius == null
        ? Constants.borderRadius
        : BorderRadius.circular(radius!);

    return Neumorphic(
      style: NeumorphicStyle(
          color: themeData.current!.baseColor,
          intensity: 5,
          depth: 6,
          shadowDarkColor: Colors.black.withOpacity(constants.blackOpacity),
          shadowLightColor: Colors.white.withOpacity(constants.whiteOpacity)),
      child: Container(
          height: constraints == null ? height : null,
          width: constraints == null ? width : null,
          constraints: constraints,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            shape: shape ?? BoxShape.rectangle,
          ),
          child: child),
    );
  }
}
