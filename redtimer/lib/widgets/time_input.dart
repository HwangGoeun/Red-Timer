import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeInput extends StatefulWidget {
  const TimeInput({super.key});

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  // 텍스트 필드 컨트롤러 선언
  TextEditingController inputController = TextEditingController();
  // 포커스노드 선언
  FocusNode myFocusNode = FocusNode();

  var hour = 10;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => FocusScope.of(context).unfocus(),
      child: TextField(
        focusNode: myFocusNode,
        controller: inputController,

        // 숫자 2자리만 입력받을 수 있도록
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],

        // 스타일 설정
        style: TextStyle(
          color: Theme.of(context).textTheme.displayLarge!.color,
          fontSize: 68,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: "10",
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.displayLarge!.color,
            fontSize: 68,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,

        // 입력 완료되었을 때만 변수 값이 업데이트 되도록 설정
        onSubmitted: (value) {
          hour = int.parse(value);
          print(hour);
        },
      ),
    );
  }
}
