import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redtimer/screens/home_screen.dart';
import '../screens/minus_screen.dart';

class TimeInput extends StatefulWidget {
  String hint, timeType;
  double fontSize, boxSize;
  Color fontColor;
  FontWeight fontWeight;

  TimeInput({
    super.key,
    required this.timeType,
    required this.boxSize,
    required this.hint,
    required this.fontColor,
    required this.fontSize,
    required this.fontWeight,
  });

  TimeInput.mainTime({
    super.key,
    required this.timeType,
    required this.hint,
    required this.fontColor,
  })  : boxSize = 90,
        fontSize = 68,
        fontWeight = FontWeight.w600;

  TimeInput.limitedTime({
    super.key,
    required this.timeType,
    required this.hint,
    required this.fontColor,
  })  : boxSize = 50,
        fontSize = 30,
        fontWeight = FontWeight.w500;

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  FocusNode textFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.boxSize,
      // decoration: const BoxDecoration(color: Colors.red),
      child: TextField(
        focusNode: textFocus,

        // 숫자 키패드 보여주기
        keyboardType: TextInputType.number,

        // 숫자 2자리만 입력받을 수 있도록
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],

        // 스타일 설정
        // 기본으로 보여질 때
        style: TextStyle(
          color: widget.fontColor,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
        ),

        // 입력할 때
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(bottom: 12),
          // default value
          hintText: widget.hint.padLeft(2, '0'),
          hintStyle: TextStyle(
            color: widget.fontColor,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
          ),
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,

        // 입력 완료되었을 때만 변수 값이 업데이트 되도록 설정
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              // plus screen
              widget.timeType == "minLimit"
                  ? minLimitTime = 0
                  : secLimitTime = 0;

              // minus screen
              widget.timeType == "minMain"
                  ? minMinusTime = 0
                  : secMinusTime = 0;
            });
          } else {
            // plus screen
            if (widget.timeType == "minLimit") {
              minLimitTime = int.parse(value);
              setState(() {
                limitSecond = minLimitTime * 60 + secLimitTime;
                totalSeconds = 0;
              });
            } else {
              secLimitTime = int.parse(value);
              setState(() {
                limitSecond = minLimitTime * 60 + secLimitTime;
                totalSeconds = 0;
              });
            }

            // minus screen
            if (widget.timeType == "minMain") {
              minMinusTime = int.parse(value);
              setState(() {
                totalMinusSeconds = minMinusTime * 60 + secMinusTime;
              });
            } else {
              secMinusTime = int.parse(value);
              setState(() {
                totalMinusSeconds = minMinusTime * 60 + secMinusTime;
              });
            }
          }
        },
      ),
    );
  }
}
