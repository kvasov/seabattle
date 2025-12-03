import 'package:flutter/material.dart';

import 'package:seabattle/app/styles/media.dart';
import 'package:seabattle/app/styles/widgets/simple_button.dart';

TextStyle cancelGameBtnTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: deviceType(context) == DeviceType.phone ? 16 : 24,
    fontWeight: FontWeight.w500,
  );
}

ButtonStyle cancelGameBtnStyle(BuildContext context) {
  return simpleButtonStyle(context).copyWith(
    padding: WidgetStateProperty.all(
      deviceType(context) == DeviceType.tablet
          ? EdgeInsets.symmetric(vertical: 16, horizontal: 36)
          : EdgeInsets.symmetric(vertical: 8, horizontal: 24),
    ),
  );
}