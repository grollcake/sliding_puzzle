import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
        final textColor =
            gameDimension == gameController.puzzleDimension ? ThemeManager.textColor : ThemeManager.inactiveColor;
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

    // number??? ???????????? ??? ????????? ???????????? early return ??????
    if (gameController.gameMode == GameMode.number) return SizedBox();

    // ?????? ????????? 2?????? ????????? ???????????? ????????????
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...buildDefaultImages(gameController),
        buildUserPhoto(context),
      ],
    );
  }

  /// ?????? ????????? 3?????? ????????????.
  List<Widget> buildDefaultImages(GameController gameController) {
    return List.generate(_images.length, (index) {
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
                    margin: EdgeInsets.all(8),
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
    });
  }

  /// ??? ???????????? ????????? ????????????.
  Expanded buildUserPhoto(BuildContext context) {
    final gameController = context.read<GameController>();
    final File? userImage = context.select((GameController controller) => controller.userImage);
    final isSelected = gameController.gameMode == GameMode.image &&
        gameController.gameImage.isEmpty &&
        gameController.userImage != null;

    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if (userImage == null || isSelected) {
            File? userImage = await _pickPhotoFromAlbum();
            if (userImage != null) {
              gameController.userImage = userImage;
              gameController.gameImage = '';
            }
          } else {
            gameController.gameImage = '';
          }
        },
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.3,
          child: AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(
              builder: (_, constraints) {
                return Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(constraints.maxHeight * .1),
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: userImage == null
                      ? Stack(
                          children: [
                            Positioned.fill(
                              child: Icon(Icons.add),
                            ),
                          ],
                        )
                      : Image.file(userImage, fit: BoxFit.cover),
                );
              },
            ),
          ),
        ),
      ),
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

  Future<File?> _pickPhotoFromAlbum() async {
    final selected = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selected == null) return null;
    final cropped = await ImageCropper()
        .cropImage(sourcePath: selected.path, aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), uiSettings: [
      AndroidUiSettings(
        toolbarTitle: '?????? ?????? ?????? ??????',
        hideBottomControls: true,
      ),
    ]);
    return cropped == null ? null : File(cropped.path);
  }
}
