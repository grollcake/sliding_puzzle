import 'package:flutter/material.dart';
import 'package:sliding_puzzle/managers/game_controller.dart';
import 'package:sliding_puzzle/managers/sound_manager.dart';
import 'package:sliding_puzzle/models/enums.dart';
import 'package:sliding_puzzle/screens/game_screen/widgets/starting_countdown.dart';
import 'package:sliding_puzzle/screens/game_screen/widgets/puzzle_piece.dart';
import 'package:sliding_puzzle/settings/constants.dart';
import 'package:provider/provider.dart';

class PuzzleSection extends StatefulWidget {
  const PuzzleSection({Key? key}) : super(key: key);

  @override
  State<PuzzleSection> createState() => _PuzzleSectionState();
}

class _PuzzleSectionState extends State<PuzzleSection> {
  late SoundManager _soundManager;

  @override
  void initState() {
    super.initState();
    _soundManager = SoundManager();
  }

  @override
  void dispose() {
    super.dispose();
    _soundManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: double.infinity,
        // decoration: BoxDecoration(
        //   color: AppStyle.bgColor,
        // ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final gameController = context.watch<GameController>();

            double pieceWidth = (constraints.maxWidth - (gameController.puzzleDimension - 1) * kPuzzlePieceSpace) /
                gameController.puzzleDimension;
            double pieceHeight = (constraints.maxHeight - (gameController.puzzleDimension - 1) * kPuzzlePieceSpace) /
                gameController.puzzleDimension;

            return Stack(
              children: [
                ...List.generate(gameController.piecesCount, (index) {
                  int positionNo = gameController.getPiecePosition(index);
                  Widget pieceName = gameController.getPieceContent(index);

                  return PuzzlePiece(
                    pieceId: index,
                    positionNo: positionNo,
                    width: pieceWidth,
                    height: pieceHeight,
                    content: pieceName,
                    onTap: _movePiece,
                  );
                }),
                if (gameController.gameStatus == GameStatus.starting) StartingCountdown(),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 조각을 탭하면 이동처리
  _movePiece(int pieceId) {
    final gameController = context.read<GameController>();
    int oldPosition = gameController.getPiecePosition(pieceId);
    int? newPosition = gameController.movePiece(pieceId);
    if (newPosition != null) {
      _soundManager.moveSound();
    }
  }
}
