import 'package:flutter/material.dart';
import 'package:seabattle/app/styles/media.dart';
import 'package:seabattle/app/styles/widgets/simple_button.dart';

EdgeInsets btnPadding(BuildContext context) {
  return deviceType(context) == DeviceType.tablet
      ? .symmetric(vertical: 32, horizontal: 48)
      : deviceType(context) == DeviceType.phone
          ? .symmetric(vertical: 16, horizontal: 24)
          : .symmetric(vertical: 10, horizontal: 16);
}

ButtonStyle createGameBtnStyle(BuildContext context) {
  return simpleButtonStyle(context).copyWith(
    padding: WidgetStateProperty.all(
      btnPadding(context),
    ),
  );
}

TextStyle createGameBtnTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: deviceType(context) == DeviceType.tablet ? 26 : 16,
  );
}

ButtonStyle cancelGameBtnTextStyle(BuildContext context) {
  return ButtonStyle(
    textStyle: WidgetStateProperty.all(TextStyle(
      fontSize: deviceType(context) == DeviceType.tablet ? 26 : 16,
      decoration: TextDecoration.underline,
    )),
  );
}