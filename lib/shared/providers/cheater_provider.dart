import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seabattle/features/battle/providers/battle_provider.dart';

class CheaterState {
  final bool isCheater;
  final bool isSetCheaterMode;
  final bool isStartCheaterMode;
  final int countTaps;
  final Duration duration;

  CheaterState({
    required this.isCheater,
    required this.isSetCheaterMode,
    required this.isStartCheaterMode,
    required this.countTaps,
    required this.duration,
  });

  CheaterState copyWith({
    bool? isCheater,
    bool? isSetCheaterMode,
    bool? isStartCheaterMode,
    int? countTaps,
    Duration? duration,
  }) {
    return CheaterState(
      isCheater: isCheater ?? this.isCheater,
      isSetCheaterMode: isSetCheaterMode ?? this.isSetCheaterMode,
      isStartCheaterMode: isStartCheaterMode ?? this.isStartCheaterMode,
      countTaps: countTaps ?? this.countTaps,
      duration: duration ?? this.duration,
    );
  }
}

class CheaterNotifier extends Notifier<CheaterState> {
  @override
  CheaterState build() {
    return CheaterState(
      isCheater: false,
      isSetCheaterMode: false,
      isStartCheaterMode: false,
      countTaps: 0,
      duration: Duration(seconds: 0),
    );
  }

  // вызывается при тапе
  void trySetCheaterMode() {
    if (state.isCheater == true) {
      return;
    }

    state = state.copyWith(countTaps: state.countTaps + 1);

    if (state.isStartCheaterMode == false) {
      // debugPrint('🟢 Таймер запущен');
      state = state.copyWith(isStartCheaterMode: true);
      Future.delayed(const Duration(seconds: 3), () {
        state = state.copyWith(isStartCheaterMode: false);
      });
    } else {
      if (state.countTaps >= 3) {
        // debugPrint('🟢 Читер включен');
        state = state.copyWith(isCheater: true);
        final battleViewModelNotifier = ref.read(battleViewModelProvider.notifier);
        battleViewModelNotifier.showFirework();
      }
    }
  }

  void resetCheaterMode() {
    state = state.copyWith(isCheater: false);
  }
}

final cheaterProvider = NotifierProvider<CheaterNotifier, CheaterState>(() {
  return CheaterNotifier();
});
