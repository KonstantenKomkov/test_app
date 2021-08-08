// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@override
Widget buildTextElement(
  BuildContext context,
  String text,
  double _fontSize, [
  _fontWeight = FontWeight.normal,
  double paddingLeft = 0.0,
  double paddingTop = 0.0,
  double paddingRight = 0.0,
  double paddingBottom = 0.0,
]) {
  return Padding(
    padding: EdgeInsets.only(
      top: paddingTop,
      left: paddingLeft,
      right: paddingRight,
      bottom: paddingBottom,
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: _fontWeight,
      ),
      softWrap: true,
    ),
  );
}
