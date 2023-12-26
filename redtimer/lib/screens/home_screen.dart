import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  final FocusNode _focusNode = FocusNode();

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [
          const NotificationButton(id: 'stop', text: 'STOP'),
          const NotificationButton(id: 'reset', text: 'RESET'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    // noticeStart(format(totalSeconds));
  }

  @override
  void initState() {
    super.initState();
    _initForegroundTask();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  static const tenMinutes = 600;
  int totalSeconds = tenMinutes;
  int minTime = 10;
  int secTime = 00;
  bool isRunning = false;
  bool reset = false;
  late Timer timer;

  void onTick(Timer timer) {
    print("reset = $reset");
    print("total = $totalSeconds");
    print("min = $minTime");
    print("sec = $secTime");
    if (totalSeconds == 0) {
      setState(() {
        isRunning = false;
        totalSeconds = totalSeconds;
        minTime = int.parse(formatMin(totalSeconds));
        secTime = int.parse(formatSecond(totalSeconds));
        reset = false;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
        minTime = int.parse(formatMin(totalSeconds));
        secTime = int.parse(formatSecond(totalSeconds));
        reset = false;
      });
      FlutterForegroundTask.updateService(
          notificationText: format(totalSeconds));
    }
  }

  void onStartPressed() {
    print("start!");
    print("reset = $reset");
    print("total = $totalSeconds");
    print("min = $minTime");
    print("sec = $secTime");
    noticeStart(format(totalSeconds));
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
      minTime = int.parse(formatMin(totalSeconds));
      secTime = int.parse(formatSecond(totalSeconds));
      reset = false;
    });
  }

  void noticeStart(String initialText) async {
    await FlutterForegroundTask.startService(
      notificationTitle: 'Red Timer',
      notificationText: initialText,
      callback: startCallback,
    );
    setState(() {
      isRunning = true;
      minTime = int.parse(formatMin(totalSeconds));
      secTime = int.parse(formatSecond(totalSeconds));
      reset = false;
    });
  }

  void onPausePreesed() {
    print("Pause!");
    print("reset = $reset");
    print("total = $totalSeconds");
    print("min = $minTime");
    print("sec = $secTime");
    timer.cancel();
    setState(() {
      isRunning = false;
      minTime = int.parse(formatMin(totalSeconds));
      secTime = int.parse(formatSecond(totalSeconds));
      reset = false;
    });
  }

  void onReset() {
    print("Reset!");
    print("reset = $reset");
    print("total = $totalSeconds");
    print("min = $minTime");
    print("sec = $secTime");
    noticeStop();
    setState(() {
      isRunning = false;
      totalSeconds = tenMinutes;
      reset = true;
      minTime = int.parse(formatMin(totalSeconds));
      secTime = int.parse(formatSecond(totalSeconds));
    });
    timer.cancel();
  }

  void noticeStop() async {
    await FlutterForegroundTask.clearAllData();
    await FlutterForegroundTask.stopService();

    setState(() {
      isRunning = false;
      minTime = int.parse(formatMin(totalSeconds));
      secTime = int.parse(formatSecond(totalSeconds));
    });
  }

  String formatMin(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split(".").first.substring(2, 4);
  }

  String formatSecond(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split(".").first.substring(5, 7);
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Flexible(
              flex: 3,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                    // color: Colors.amber,
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 분
                    reset == true
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              formatMin(totalSeconds),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                                fontSize: 68,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : isRunning == false
                            ? SizedBox(
                                width: 100,
                                child: TextField(
                                  // controller: _controller1,

                                  // 숫자 키패드 보여주기
                                  keyboardType: TextInputType.number,

                                  // 숫자 2자리만 입력받을 수 있도록
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],

                                  // 스타일 설정
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .color!,
                                    fontSize: 68,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    // default value
                                    hintText:
                                        minTime.toString().padLeft(2, '0'),
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .color,
                                      fontSize: 68,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  textAlign: TextAlign.center,

                                  // 입력 완료되었을 때만 변수 값이 업데이트 되도록 설정
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        minTime = 0;
                                      });
                                    } else {
                                      minTime = int.parse(value);
                                      print("min : $minTime");
                                      setState(() {
                                        totalSeconds = minTime * 60 + secTime;
                                      });
                                    }
                                  },

                                  onTap: () {
                                    // 포커스 잃으면 키보드 없어지게 하기
                                    FocusScope.of(context).unfocus();
                                    // 텍스트 필드 입력 시 기존 값 없애기
                                    _controller1.clear();
                                  },
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  formatMin(totalSeconds),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .color,
                                    fontSize: 68,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                    // :
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Text(
                          ":",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                            fontSize: 68,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // 초
                    reset == true
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              formatSecond(totalSeconds),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                                fontSize: 68,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : isRunning == false
                            ? SizedBox(
                                width: 100,
                                child: TextField(
                                  // controller: _controller2,

                                  // 숫자 키패드 보여주기
                                  keyboardType: TextInputType.number,

                                  // 숫자 2자리만 입력받을 수 있도록
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],

                                  // 스타일 설정
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .color,
                                    fontSize: 68,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    // default value
                                    hintText:
                                        secTime.toString().padLeft(2, '0'),
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .color,
                                      fontSize: 68,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  textAlign: TextAlign.center,

                                  // 입력 완료되었을 때만 변수 값이 업데이트 되도록 설정
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        secTime = 0;
                                      });
                                    } else {
                                      secTime = int.parse(value);
                                      print("secTime : $secTime");
                                      setState(() {
                                        totalSeconds = minTime * 60 + secTime;
                                      });
                                    }
                                  },

                                  onTap: () {
                                    // 포커스 잃으면 키보드 없어지게 하기
                                    FocusScope.of(context).unfocus();
                                    // 텍스트 필드 입력 시 기존 값 없애기
                                    _controller2.clear();
                                  },
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  formatSecond(totalSeconds),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .color,
                                    fontSize: 68,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Flexible(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: isRunning ? onPausePreesed : onStartPressed,
                      icon: Icon(
                        isRunning ? Icons.pause : Icons.play_arrow,
                      ),
                      iconSize: 60,
                      color: Theme.of(context).textTheme.displayLarge!.color,
                    ),
                    IconButton(
                      onPressed: onReset,
                      icon: const Icon(
                        Icons.square,
                      ),
                      iconSize: 39,
                      color: Theme.of(context).textTheme.displayLarge!.color,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {
  SendPort? _sendPort;

  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    sendPort?.send(timestamp);
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {}

  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed >> $id');
    if (id == 'stop') {
      // onPausePreesed();
    } else if (id == 'reset') {
      // onReset();
    }
  }

  @override
  void onNotificationPressed() {
    // FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}
