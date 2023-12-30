import 'package:flutter/material.dart';

class Time extends StatelessWidget {
  String value;
  double fontSize, bottomPadding;
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
        bottomPadding = 12;

  Time.limitedTime({
    super.key,
    required this.value,
    required this.fontColor,
  })  : fontSize = 40,
        fontWeight = FontWeight.w600,
        bottomPadding = 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        left: 6,
        right: 4,
      ),
      child: SizedBox(
        width: 80,
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
