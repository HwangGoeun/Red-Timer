import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:redtimer/widgets/plus_minus.dart';
import 'package:redtimer/widgets/time.dart';
import 'package:redtimer/widgets/time_input.dart';

int tenMinutes = 600;
int totalSeconds = 0;
int limitSecond = tenMinutes;
int minTime = 0;
int secTime = 0;
int minLimitTime = 0;
int secLimitTime = 0;
bool homeScreen = true;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          // const NotificationButton(id: 'stop', text: 'STOP'),
          // const NotificationButton(id: 'reset', text: 'RESET'),
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
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool isRunning = false;
  bool reset = false;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == limitSecond) {
      setState(() {
        isRunning = false;
        totalSeconds = totalSeconds;
        minTime = int.parse(formatMin(totalSeconds));
        secTime = int.parse(formatSecond(totalSeconds));
        reset = false;
      });
      timer.cancel();
    } else {
      if (isRunning == true) {
        setState(() {
          totalSeconds = totalSeconds + 1;
          minTime = int.parse(formatMin(totalSeconds));
          secTime = int.parse(formatSecond(totalSeconds));
          reset = false;
        });
      } else {
        setState(() {
          minTime = int.parse(formatMin(totalSeconds));
          secTime = int.parse(formatSecond(totalSeconds));
          reset = false;
        });
      }
      FlutterForegroundTask.updateService(
          notificationText: format(totalSeconds));
    }
  }

  void onStartPressed() {
    noticeStart(format(totalSeconds));
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
      minTime = int.parse(formatMin(totalSeconds));
      secTime = int.parse(formatSecond(totalSeconds));
      minLimitTime = int.parse(formatMin(limitSecond));
      secLimitTime = int.parse(formatSecond(limitSecond));
      reset = false;
    });
  }

  void onPausePreesed() {
    timer.cancel();
    setState(() {
      isRunning = false;
      minTime = int.parse(formatMin(totalSeconds));
      secTime = int.parse(formatSecond(totalSeconds));
      minLimitTime = int.parse(formatMin(limitSecond));
      secLimitTime = int.parse(formatSecond(limitSecond));
      reset = false;
    });
  }

  void onReset() {
    noticeStop();
    setState(() {
      isRunning = false;
      totalSeconds = 0;
      limitSecond = tenMinutes;
      reset = true;
      minTime = int.parse(formatMin(totalSeconds));
      secTime = int.parse(formatSecond(totalSeconds));
    });
    timer.cancel();
    reset = false;
  }

  // 알림창 관련 함수
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

  void noticeStop() async {
    await FlutterForegroundTask.clearAllData();
    await FlutterForegroundTask.stopService();

    setState(() {
      isRunning = false;
      minTime = int.parse(formatMin(totalSeconds));
      secTime = int.parse(formatSecond(totalSeconds));
    });
  }

  // 시간 출력 관련 함수
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
    Color fontColor = Theme.of(context).textTheme.displayLarge!.color!;

    return WithForegroundTask(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            // 여백
            Flexible(
              flex: 1,
              child: Container(
                height: double.infinity,
              ),
            ),

            // 플러스 / 마이너스 버튼
            Flexible(
              flex: 2,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.bottomCenter,
                // decoration: const BoxDecoration(color: Colors.amber),
                child: const PlusMinus(),
              ),
            ),

            // 시간 보여지는 곳
            Flexible(
              flex: 2,
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
                    // 리셋 버튼을 클릭했을 때
                    reset == true
                        ? Time.plusTime(
                            value: formatMin(totalSeconds),
                            fontColor: fontColor,
                          )
                        // 리셋 버튼을 클릭하지 않았을 때 시간 보여주기
                        : Time.plusTime(
                            value: formatMin(totalSeconds),
                            fontColor: fontColor,
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
                    // 리셋 버튼을 클릭했을 때
                    reset == true
                        ? Time.plusTime(
                            value: formatSecond(totalSeconds),
                            fontColor: fontColor,
                          )
                        // 리셋 버튼을 클릭하지 않았을 때 시간 보여주기
                        : Time.plusTime(
                            value: secTime.toString(),
                            fontColor: fontColor,
                          )
                  ],
                ),
              ),
            ),

            // 제한 시간 부분
            Flexible(
              flex: 1,
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                    // color: Colors.amber,
                    ),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 분
                    // 타이머가 실행중이면 제한시간 보여주기
                    isRunning == true
                        ? Time.limitedTime(
                            value: formatMin(limitSecond),
                            fontColor: fontColor,
                          )
                        // 실행 중이 아니라면 제한시간 입력할 수 있게 하기
                        : TimeInput.limitedTime(
                            timeType: "minLimit",
                            hint: formatMin(limitSecond),
                            fontColor: fontColor,
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
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // 초
                    // 타이머가 실행중이면 제한시간 보여주기
                    isRunning == true
                        ? Time.limitedTime(
                            value: formatSecond(limitSecond),
                            fontColor: fontColor,
                          )
                        // 실행 중이 아니라면 제한시간 입력할 수 있게 하기
                        : TimeInput.limitedTime(
                            timeType: "secLimit",
                            hint: formatSecond(limitSecond),
                            fontColor: fontColor,
                          ),
                  ],
                ),
              ),
            ),

            // 시작 / 리셋 버튼 있는 곳
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
