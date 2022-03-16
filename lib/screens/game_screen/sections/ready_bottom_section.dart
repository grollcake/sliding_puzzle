import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_puzzle/common_widgets/primary_button.dart';
import 'package:sliding_puzzle/managers/game_controller.dart';
import 'package:sliding_puzzle/managers/theme_manager.dart';
import 'package:sliding_puzzle/models/enums.dart';
import 'package:sliding_puzzle/utils/utils.dart';

class ReadyBottomSection extends StatelessWidget {
  ReadyBottomSection({Key? key}) : super(key: key);

  final _gameDimensions = [3, 4, 5];
  final _gameModes = ['Number', 'Image'];
  final _images = ['assets/images/image1.png', 'assets/images/image2.png', 'assets/images/image3.png'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 1, child: buildDimensionSelection(context)),
        Expanded(flex: 1, child: buildTypeSelection(context)),
        Expanded(flex: 3, child: buildImageSelection(context)),
        Expanded(flex: 2, child: buildStartButton(context)),
      ],
    );
  }

  Widget buildDimensionSelection(BuildContext context) {
    final theme = Theme.of(context);
    final gameController = context.watch<GameController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_gameDimensions.length, (index) {
        final gameDimension = _gameDimensions[index];
        final textColor = gameDimension == gameController.puzzleDimension
            ? ThemeManager.textColor
            : ThemeManager.inactiveColor;
        final weight = gameDimension == gameController.puzzleDimension ? FontWeight.w700 : FontWeight.w400;

        return GestureDetector(
          onTap: () {
            gameController.setPuzzleDimension(gameDimension);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$gameDimension x $gameDimension',
              style: TextStyle(fontSize: 16, color: textColor, fontWeight: weight),
            ),
          ),
        );
      }),
    );
  }

  Widget buildTypeSelection(BuildContext context) {
    final gameController = context.watch<GameController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_gameModes.length, (index) {
        final gameMode = GameMode.values[index];
        final textColor = gameMode == gameController.gameMode ? ThemeManager.textColor : ThemeManager.inactiveColor;
        final weight = gameMode == gameController.gameMode ? FontWeight.w700 : FontWeight.w400;

        return GestureDetector(
          onTap: () {
            gameController.gameMode = gameMode;
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(gameMode.name, style: TextStyle(fontSize: 16, color: textColor, fontWeight: weight)),
          ),
        );
      }),
    );
  }

  Widget buildImageSelection(BuildContext context) {
    final gameController = context.read<GameController>();

    // number일 경우에는 빈 화면만 나오도록 early return 처리
    if (gameController.gameMode == GameMode.number) return SizedBox();

    // 기본 이미지 2개와 사용자 선택박스 보여주기
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_images.length, (index) {
        final image = _images[index];
        return Expanded(
          child: GestureDetector(
            onTap: () {
              gameController.gameImage = image;
            },
            child: Opacity(
              opacity: image == gameController.gameImage ? 1.0 : 0.3,
              child: AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    return Container(
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(constraints.maxHeight * .1),
                        image: DecorationImage(image: AssetImage(getPreviewImagePath(image))),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildStartButton(BuildContext context) {
    final gameController = context.read<GameController>();
    return Center(
      child: PrimaryButton(
        label: 'START',
        onPressed: () {
          gameController.startingGame();
        },
      ),
    );
  }
}