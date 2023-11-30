import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const tenMinutes = 600;
  int totalSeconds = tenMinutes;
  bool isRunning = false;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isRunning = false;
        totalSeconds = totalSeconds;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePreesed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onReset() {
    setState(() {
      isRunning = false;
      totalSeconds = tenMinutes;
    });
    timer.cancel();
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(),
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).textTheme.displayLarge!.color,
                  fontSize: 68,
                  fontWeight: FontWeight.w600,
                ),
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
          // Flexible(
          //   flex: 1,
          //   child: Container(
          //     decoration: const BoxDecoration(),
          //     height: double.infinity,
          //     child: const Icon(Icons.home),
          //   ),
          // ),
        ],
      ),
    );
  }
}
