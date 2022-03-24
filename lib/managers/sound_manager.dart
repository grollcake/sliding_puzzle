import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class SoundManager {
  final _player = AudioPlayer();
  static const _moveSoundFile = 'assets/audio/move.wav';

  SoundManager() {
    _init();
  }

  void _init() {
    if (kIsWeb) {}
  }

  void moveSound() async {
    await _player.setAsset(_moveSoundFile);
    _player.play();
  }

  void dispose() {
    _player.dispose();
  }
}
