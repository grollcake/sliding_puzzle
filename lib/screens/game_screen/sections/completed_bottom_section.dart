import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_puzzle/common_widgets/primary_button.dart';
import 'package:sliding_puzzle/managers/game_controller.dart';
import 'package:sliding_puzzle/managers/share_manager.dart';
import 'package:sliding_puzzle/screens/game_screen/game_screen.dart';
import 'package:sliding_puzzle/screens/game_screen/widgets/playing_info.dart';

class CompletedBottomSection extends StatelessWidget {
  const CompletedBottomSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PlayingInfo(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PrimaryButton(
                label: 'SHARE',
                onPressed: () async {
                  // 화면 캡처
                  final screenshot = await screenshotController.capture(delay: Duration(milliseconds: 10));
                  debugPrint('captured');
                  // 공유하기
                  if (screenshot != null) {
                    ShareManager().screenshotShare(screenshot, 'Checkout. I finished it!');
                  }
                }),
            PrimaryButton(
              label: 'Restart',
              onPressed: () {
                context.read<GameController>().resetGame();
              },
            ),
          ],
        ),
      ],
    );
  }
}
