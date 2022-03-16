import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sliding_puzzle/managers/game_controller.dart';
import 'package:sliding_puzzle/managers/theme_manager.dart';
import 'package:sliding_puzzle/models/enums.dart';

class UpperSection extends StatelessWidget {
  const UpperSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameStatue = context.select((GameController controller) => controller.gameStatus);
    Widget contents;

    switch (gameStatue) {
      case GameStatus.ready:
        contents = buildReadyContents();
        break;
      case GameStatus.starting:
        contents = buildStartingContents();
        break;
      case GameStatus.playing:
        contents = buildPlayingContents(context);
        break;
      case GameStatus.completed:
        contents = buildCompletedContents();
        break;
    }

    return SizedBox.expand(
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        // color: Colors.blueGrey,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: contents,
        ),
      ),
    );
  }

  Widget buildReadyContents() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'SLIDING PUZZLE',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildStartingContents() {
    return SizedBox(); // 시작하는 동안에는 아무것도 안 보여주는게 제일 좋겠다.
  }

  Widget buildPlayingContents(BuildContext context) {
    return Container(
      // child: Lottie.asset('assets/animations/girl-tapping-phone.json'),
      child: Lottie.asset('assets/animations/lurking-cat.json'),
    );
  }

  Widget buildCompletedContents() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Completed!', style: TextStyle(fontSize: 20, color: ThemeManager.textColor, fontWeight: FontWeight.bold)),
        Expanded(
          child: Lottie.asset('assets/animations/clapping.json'),
        ),
      ],
    );
  }
}
