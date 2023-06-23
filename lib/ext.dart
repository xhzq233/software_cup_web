import 'package:flutter/material.dart';

// for debug purposes
extension WidgetExtensions on Widget {
  Widget onTap(void Function() function) => GestureDetector(
    onTap: function,
    child: this,
  );

  Widget centralized() => Center(
    child: this,
  );

  Widget decorated(BoxDecoration boxDecoration) => DecoratedBox(
    decoration: boxDecoration,
    child: this,
  );

  Widget sized({double? width, double? height}) => SizedBox(
    width: width,
    height: height,
    child: this,
  );

  Widget border({EdgeInsets? margin, EdgeInsets? padding, Color color = Colors.blueAccent}) => Container(
    margin: margin,
    padding: padding,
    decoration: BoxDecoration(border: Border.all(color: color,width: 0.5)),
    child: this,
  );

  Widget clipped([BorderRadius? borderRadius]) => ClipRRect(
    borderRadius: borderRadius,
    child: this,
  );

  Widget unconstrained() => UnconstrainedBox(
    child: this,
  );
}