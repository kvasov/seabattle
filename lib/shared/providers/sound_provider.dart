import 'package:seabattle/features/settings/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class SoundNotifier extends Notifier<void> {
  late final AudioPlayer _playerHit;
  late final AudioPlayer _playerMiss;
  late final AudioPlayer _playerWin;

  @override
  void build() {
    _playerHit = AudioPlayer()..setAsset('assets/sounds/shot.mp3');
    _playerMiss = AudioPlayer()..setAsset('assets/sounds/bulk.mp3');
    _playerWin = AudioPlayer()..setAsset('assets/sounds/win.mp3');

    ref.onDispose(() {
      _playerHit.dispose();
      _playerMiss.dispose();
      _playerWin.dispose();
    });
  }

  Future<void> playHitSound() async {
    await _playerHit.seek(Duration.zero);
    await _playerHit.play();
  }

  Future<void> playMissSound() async {
    await _playerMiss.seek(Duration.zero);
    await _playerMiss.play();
  }

  Future<void> playWinSound() async {
    await Future.delayed(Duration(seconds: 1));
    await _playerWin.seek(Duration.zero);
    await _playerWin.play();
  }

  Future<void> playSound(String type) async {
    final isSoundEnabled = ref.read(settingsViewModelProvider).value?.settings?.isSoundEnabled ?? false;
    if (!isSoundEnabled) return;
    switch (type) {
      case 'hit':
        await playHitSound();
        break;
      case 'miss':
        await playMissSound();
        break;
      case 'win':
        await playWinSound();
        break;
    }
  }
}







final soundNotifierProvider = NotifierProvider<SoundNotifier, void>(() {
  return SoundNotifier();
});