import 'package:flutter/material.dart';
import 'package:redtimer/screens/home_screen.dart';
import '../screens/minus_screen.dart';

class PlusMinus extends StatefulWidget {
  const PlusMinus({super.key});

  @override
  State<PlusMinus> createState() => _PlusMinusState();
}

class _PlusMinusState extends State<PlusMinus> {
  @override
  Widget build(BuildContext context) {
    Color fontColor = Theme.of(context).textTheme.displayLarge!.color!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // plus
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const HomeScreen();
                },
                transitionDuration: Duration.zero,
              ),
            );
            homeScreen = true;
          },
          icon: const Icon(Icons.add),
          color: homeScreen == true ? fontColor : fontColor.withOpacity(0.5),
          iconSize: 30,
        ),

        // minus
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const MinusScreen();
                },
                transitionDuration: Duration.zero,
              ),
            );
            homeScreen = false;
          },
          icon: const Icon(Icons.remove),
          color: homeScreen == false ? fontColor : fontColor.withOpacity(0.5),
          iconSize: 30,
        )
      ],
    );
  }
}
