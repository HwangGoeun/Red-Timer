import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redtimer/screens/home_screen.dart';

class TimeInput extends StatefulWidget {
  String hint, timeType;
  int totalTime, minTime, secTime;
  double fontSize, boxSize;
  Color fontColor;
  FontWeight fontWeight;

  TimeInput({
    super.key,
    required this.timeType,
    required this.totalTime,
    required this.minTime,
    required this.secTime,
    required this.boxSize,
    required this.hint,
    required this.fontColor,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.boxSize,
      // decoration: const BoxDecoration(color: Colors.red),
      child: TextField(
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
              widget.timeType == "min"
                  ? widget.minTime = 0
                  : widget.secTime = 0;
            });
          } else {
            if (widget.timeType == "min") {
              minTime = int.parse(value);
              print("min : $widget.minTime");
              setState(() {
                totalSeconds = minTime * 60 + secTime;
              });
            } else {
              secTime = int.parse(value);
              print("sec : $widget.secTime");
              setState(() {
                totalSeconds = minTime * 60 + secTime;
              });
            }
          }
        },

        // onTap: () {
        //   // 포커스 잃으면 키보드 없어지게 하기
        //   FocusScope.of(context).unfocus();
        //   // 텍스트 필드 입력 시 기존 값 없애기
        //   _controller1.clear();
        // },
      ),
    );
  }
}
