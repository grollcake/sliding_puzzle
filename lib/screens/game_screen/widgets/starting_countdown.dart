import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_puzzle/managers/game_controller.dart';

class StartingCountdown extends StatefulWidget {
  const StartingCountdown({Key? key}) : super(key: key);

  @override
  State<StartingCountdown> createState() => _StartingCountdownState();
}

class _StartingCountdownState extends State<StartingCountdown> {
  final _animationDuration = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _animateCountdown());
  }

  _animateCountdown() async {
    final gameController = context.read<GameController>();

    for (int i = 0; i < 3; i++) {
      gameController.shuffle();
      await Future.delayed(_animationDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Center(
        child: SizedBox(
          width: constraints.maxWidth * .7,
          height: constraints.maxHeight * .7,
          child: FittedBox(
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic),
              child: AnimatedTextKit(
                animatedTexts: [
                  ScaleAnimatedText('2', duration: _animationDuration),
                  ScaleAnimatedText('1', duration: _animationDuration),
                  ScaleAnimatedText('Go', duration: _animationDuration),
                ],
                pause: Duration.zero,
                isRepeatingAnimation: false,
                onFinished: () {
                  final gameController = context.read<GameController>();
                  gameController.startGame();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
