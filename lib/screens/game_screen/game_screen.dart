import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sliding_puzzle/screens/game_screen/sections/bottom_section.dart';
import 'package:sliding_puzzle/screens/game_screen/sections/puzzle_section.dart';
import 'package:sliding_puzzle/screens/game_screen/sections/top_section.dart';
import 'package:sliding_puzzle/screens/game_screen/sections/upper_section.dart';
import 'package:sliding_puzzle/screens/not_supporting/not_supporting_screen.dart';

ScreenshotController screenshotController = ScreenshotController();

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  /// 가로가 더 긴 화면에서도 하단 컨텐츠가 잘리지 않도록 크기를 계산한다.
  Size _calcContentsSize(BuildContext context) {
    const double aspectRatio = 1 / 2.5; // 가로/세로 비율
    const double minHorizontalPadding = 40.0;
    const double minVerticalPadding = 40.0;
    final Size screenSize = MediaQuery.of(context).size;

    double contentsWidth = screenSize.width - minHorizontalPadding * 2;
    double contentsHeight = screenSize.height - minVerticalPadding * 2;
    contentsHeight -= MediaQuery.of(context).padding.top; // 모바일 상단 상태바 높이만큼 빼준다.

    if (contentsWidth / aspectRatio > contentsHeight) {
      contentsWidth = contentsHeight * aspectRatio;
    } else {
      contentsHeight = contentsWidth / aspectRatio;
    }

    return Size(contentsWidth, contentsHeight);
  }

  @override
  Widget build(BuildContext context) {
    Size contentsSize = _calcContentsSize(context);

    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          width: double.infinity,
          // 상단 상태바 높이만큼 내리고 시작한다.
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          alignment: Alignment.center,
          child: Column(
            children: [
              TopSection(),
              Container(
                // color: Colors.purple.shade200,
                width: contentsSize.width,
                height: contentsSize.height,
                alignment: Alignment.center,
                child: contentsSize.height > 450
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 1,
                            child: UpperSection(),
                          ),
                          PuzzleSection(),
                          Flexible(
                            flex: 2,
                            child: BottomSection(),
                          ),
                        ],
                      )
                    : NotSupportingScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
