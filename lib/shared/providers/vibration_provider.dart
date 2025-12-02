import 'package:seabattle/features/settings/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

class VibrationState {
  final bool isVibrating;

  VibrationState({
    required this.isVibrating,
  });

  VibrationState copyWith({
    bool? isVibrating,
  }) {
    return VibrationState(
      isVibrating: isVibrating ?? this.isVibrating,
    );
  }
}

class VibrationNotifier extends Notifier<VibrationState> {
  @override
  VibrationState build() {
    return VibrationState(isVibrating: false);
  }

  vibrate(List<int> pattern) {
    final isVibrationEnabled = ref.read(settingsViewModelProvider).value?.settings?.isVibrationEnabled ?? false;

    if (isVibrationEnabled) {
      Vibration.vibrate(
        pattern: pattern,
        amplitude: 100,
      );
    }
  }

  vibrateHit() {
    final List<int> pattern = [0, 100, 100, 100];
    vibrate(pattern);
  }

  vibrateMiss() {
    final List<int> pattern = [0, 100, 50, 100, 50, 100];
    vibrate(pattern);
  }

  vibrateDeath() {
    final List<int> pattern = [0, 100, 100, 100, 100, 100, 100, 100, 100, 100];
    vibrate(pattern);
  }

}

final vibrationNotifierProvider = NotifierProvider<VibrationNotifier, VibrationState>(() {
  return VibrationNotifier();
});