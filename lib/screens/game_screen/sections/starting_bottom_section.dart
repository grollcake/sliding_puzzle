import 'package:flutter/material.dart';

class StartingBottomSection extends StatefulWidget {
  const StartingBottomSection({Key? key}) : super(key: key);

  @override
  State<StartingBottomSection> createState() => _StartingBottomSectionState();
}

class _StartingBottomSectionState extends State<StartingBottomSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(); // 시작하는 동안에는 아무것도 안 보여주는게 제일 좋겠다.
  }
}
