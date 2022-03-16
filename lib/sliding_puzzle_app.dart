import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_puzzle/managers/game_controller.dart';
import 'package:sliding_puzzle/managers/theme_manager.dart';
import 'package:sliding_puzzle/screens/game_screen/game_screen.dart';

class SlidingPuzzleApp extends StatelessWidget {
  const SlidingPuzzleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameController()),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ],
      child: App(),
    );
  }
}

// provider를 선언 직후에 바로 사용할 수 없기 때문에 MaterialApp을 분리하였다.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliding puzzle',
      debugShowCheckedModeBanner: false,
      theme: ThemeManager.lightTheme,
      darkTheme: ThemeManager.darkTheme,
      themeMode: context.select((ThemeManager themeManager) => themeManager.themeMode),
      home: GameScreen(),
    );
  }
}
