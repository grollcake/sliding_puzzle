import 'package:flutter/material.dart';
import 'package:sliding_puzzle/managers/theme_manager.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({Key? key, required this.label, required this.onPressed}) : super(key: key);

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: ThemeManager.primaryColor,
        minimumSize: Size(100, 46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
