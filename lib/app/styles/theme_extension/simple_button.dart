import 'package:flutter/material.dart';

class ButtonColors extends ThemeExtension<ButtonColors> {
  const ButtonColors({
    required this.backgroundColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color textColor;

  @override
  ButtonColors copyWith({
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ButtonColors(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  ButtonColors lerp(ThemeExtension<ButtonColors>? other, double t) {
    if (other is! ButtonColors) return this;
    return ButtonColors(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
    );
  }
}


