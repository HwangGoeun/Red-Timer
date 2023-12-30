import 'package:flutter/material.dart';

class Time extends StatelessWidget {
  String value;
  double fontSize, bottomPadding;
  late double leftPadding, rightPadding, boxWidth;
  Color fontColor;
  FontWeight fontWeight;

  Time({
    super.key,
    required this.bottomPadding,
    required this.value,
    required this.fontColor,
    required this.fontSize,
    required this.fontWeight,
  });

  Time.plusTime({
    super.key,
    required this.value,
    required this.fontColor,
  })  : fontSize = 68,
        fontWeight = FontWeight.w600,
        bottomPadding = 12,
        leftPadding = 6,
        rightPadding = 4,
        boxWidth = 80;

  Time.limitedTime({
    super.key,
    required this.value,
    required this.fontColor,
  })  : fontSize = 30,
        fontWeight = FontWeight.w500,
        bottomPadding = 12,
        leftPadding = 7.8,
        rightPadding = 3,
        boxWidth = 39;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        left: leftPadding,
        right: rightPadding,
      ),
      child: SizedBox(
        width: boxWidth,
        // decoration: const BoxDecoration(color: Colors.amber),
        child: Text(
          value.padLeft(2, '0'),
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
