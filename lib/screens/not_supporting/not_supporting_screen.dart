import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_puzzle/managers/theme_manager.dart';

class NotSupportingScreen extends StatelessWidget {
  const NotSupportingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Insufficient height',
              style: TextStyle(fontSize: 16, color: ThemeManager.textColor),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          Lottie.asset('assets/animations/landscape-to-portrait-view.json'),
        ],
      ),
    );
  }
}
