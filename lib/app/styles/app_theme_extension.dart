import 'package:flutter/material.dart';

/// Расширение темы с кастомными цветами для Switch
class AppSwitchColors extends ThemeExtension<AppSwitchColors> {
  const AppSwitchColors({
    required this.thumbOn,
    required this.thumbOff,
    required this.trackOn,
    required this.trackOff,
  });

  final Color thumbOn;
  final Color thumbOff;
  final Color trackOn;
  final Color trackOff;

  @override
  AppSwitchColors copyWith({
    Color? thumbOn,
    Color? thumbOff,
    Color? trackOn,
    Color? trackOff,
  }) {
    return AppSwitchColors(
      thumbOn: thumbOn ?? this.thumbOn,
      thumbOff: thumbOff ?? this.thumbOff,
      trackOn: trackOn ?? this.trackOn,
      trackOff: trackOff ?? this.trackOff,
    );
  }

  @override
  AppSwitchColors lerp(ThemeExtension<AppSwitchColors>? other, double t) {
    if (other is! AppSwitchColors) return this;
    return AppSwitchColors(
      thumbOn: Color.lerp(thumbOn, other.thumbOn, t)!,
      thumbOff: Color.lerp(thumbOff, other.thumbOff, t)!,
      trackOn: Color.lerp(trackOn, other.trackOn, t)!,
      trackOff: Color.lerp(trackOff, other.trackOff, t)!,
    );
  }
}


