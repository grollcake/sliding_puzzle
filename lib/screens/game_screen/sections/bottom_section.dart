import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_puzzle/managers/game_controller.dart';
import 'package:sliding_puzzle/models/enums.dart';
import 'package:sliding_puzzle/screens/game_screen/sections/completed_bottom_section.dart';
import 'package:sliding_puzzle/screens/game_screen/sections/playing_bottom_section.dart';
import 'package:sliding_puzzle/screens/game_screen/sections/ready_bottom_section.dart';
import 'package:sliding_puzzle/screens/game_screen/sections/starting_bottom_section.dart';

class BottomSection extends StatelessWidget {
  const BottomSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget contents;

    final gameStatus = context.select((GameController controller) => controller.gameStatus);
    switch (gameStatus) {
      case GameStatus.ready:
        contents = ReadyBottomSection();
        break;
      case GameStatus.starting:
        contents = StartingBottomSection();
        break;
      case GameStatus.playing:
        contents = PlayingBottomSection();
        break;
      case GameStatus.completed:
        contents = CompletedBottomSection();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      // color: Colors.purple.shade200,
      child: contents,
    );
  }
}
