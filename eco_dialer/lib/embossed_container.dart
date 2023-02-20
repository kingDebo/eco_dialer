import 'package:eco_dialer/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class EmbossedContainer extends StatelessWidget {
  EmbossedContainer(
      {required this.child,
      this.height,
      this.width,
      this.constraints,
      this.shape,
      this.radius,
      this.padding});
  late Widget child;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
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

    return ClipRRect(
      borderRadius: borderRadius,
      child: Neumorphic(
        style: NeumorphicStyle(
            color: themeData.current!.baseColor,
            intensity: 5,
            depth: -10,
            shadowDarkColorEmboss:
                Colors.black.withOpacity(constants.blackOpacity),
            shadowLightColorEmboss:
                Colors.white.withOpacity(constants.whiteOpacity)),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: constraints == null ? height : null,
            width: constraints == null ? width : null,
            padding: padding,
            constraints: constraints,
            decoration: BoxDecoration(
              shape: shape ?? BoxShape.rectangle,
              borderRadius: borderRadius,
            ),
            child: child),
      ),
    );
  }
}
