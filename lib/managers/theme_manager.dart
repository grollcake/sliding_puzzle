import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  static int _themeId = 0; // 0-light, 1-dark

  /// 기본 컬러셋. 0번은 밝은거, 1번은 어두운거
  static const List<Color> _primaryColors = [Color(0xFF5C8DF7), Color(0xFF5C8DF7)];
  static const List<Color> _secondaryColors = [Color(0xFF188581), Color(0xFF00C6C0)];
  static const List<Color> _bgColors = [Color(0xFFF9F9F9), Color(0xFF292D3E)];
  static const List<Color> _accentBgColors = [Colors.green, Colors.green];
  static const List<Color> _textColors = [Colors.black54, Colors.white];
  static const List<Color> _inactiveColors = [Colors.black26, Colors.white30];
  
  // 현재 컬러셋
  static Color get primaryColor => _primaryColors[_themeId];
  static Color get secondaryColor => _secondaryColors[_themeId];
  static Color get bgColor => _bgColors[_themeId];
  static Color get accentBgColor => _accentBgColors[_themeId];
  static Color get textColor => _textColors[_themeId];
  static Color get inactiveColor => _inactiveColors[_themeId];

  ///
  static ThemeData lightTheme = ThemeData.light().copyWith(
    backgroundColor: _bgColors[0],
    scaffoldBackgroundColor: _bgColors[0],
    iconTheme: IconThemeData(
      color: _inactiveColors[0],
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: _textColors[0]),
      bodyText2: TextStyle(color: _textColors[0]),
    ),
  );
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    backgroundColor: _bgColors[1],
    scaffoldBackgroundColor: _bgColors[1],
    iconTheme: IconThemeData(
      color: _inactiveColors[1],
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: _textColors[1]),
      bodyText2: TextStyle(color: _textColors[1]),
    ),
  );

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleThemeMode() {
    if (_themeMode == ThemeMode.light) {
      _themeId = 1;
      _themeMode = ThemeMode.dark;
    } else {
      _themeId = 0;
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}
