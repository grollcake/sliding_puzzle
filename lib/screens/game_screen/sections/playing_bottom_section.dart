import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sliding_puzzle/common_widgets/primary_button.dart';
import 'package:sliding_puzzle/managers/game_controller.dart';
import 'package:sliding_puzzle/managers/theme_manager.dart';
import 'package:sliding_puzzle/models/enums.dart';
import 'package:sliding_puzzle/screens/game_screen/widgets/playing_info.dart';
import 'package:sliding_puzzle/utils/utils.dart';

class PlayingBottomSection extends StatelessWidget {
  const PlayingBottomSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: PlayingInfo()),
        Expanded(flex: 3, child: buildImagePreview(context)),
        Expanded(flex: 1, child: buildRestart(context)),
      ],
    );
  }

  Widget buildImagePreview(BuildContext context) {
    final gameController = context.read<GameController>();

    // number일 경우에는 빈 화면만 나오도록 early return 처리
    if (gameController.gameMode == GameMode.number) return SizedBox();

    final imagePath = context.select((GameController controller) => controller.gameImage);
    final File? userImage = context.select((GameController controller) => controller.userImage);

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(constraints.maxWidth * .1),
            child: imagePath.isNotEmpty
                ? Image.asset(getPreviewImagePath(imagePath), fit: BoxFit.fill)
                : Image.file(userImage!, fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget buildRestart(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Got stuck? ', style: TextStyle(fontSize: 14, color: ThemeManager.inactiveColor)),
          TextButton(
            onPressed: () => reallyRestart(context),
            child: Text(
              'Give up',
              style: TextStyle(fontSize: 14, color: ThemeManager.textColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void reallyRestart(BuildContext context) async {
    final bool? seriouslyRestart = await showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/animations/canceled-state-illustration.json', width: 150),
                  Text(
                    'Really?',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'I belive you can do it',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PrimaryButton(
                          label: 'I CAN',
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          }),
                      PrimaryButton(
                          label: 'Give up',
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          }),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
    if (seriouslyRestart ?? false) {
      context.read<GameController>().resetGame();
    }
  }
}
