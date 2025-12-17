import 'package:flutter/material.dart';
import 'package:seabattle/app/styles/widgets/simple_button.dart';
import 'package:seabattle/app/styles/media.dart';

double btnWidth(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return deviceType(context) == DeviceType.tablet
      ? 200
      : screenWidth * 0.5 - 24;
}

ButtonStyle gameBtnStyle(BuildContext context) {
  return simpleButtonStyle(context).copyWith(
    padding: WidgetStateProperty.all(
      const .symmetric(vertical: 20),
    ),
  );
}

TextStyle gameBtnTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: deviceType(context) == DeviceType.tablet ? 20 : 16,
  );
}

double gameBtnHeight(BuildContext context) {
  return deviceType(context) == DeviceType.tablet ? 160 : 140;
}

ButtonStyle settingsBtnStyle(BuildContext context) {
  return simpleButtonStyle(context).copyWith(
    padding: WidgetStateProperty.all(
      deviceType(context) == DeviceType.tablet
          ? .symmetric(vertical: 16, horizontal: 24)
          : .symmetric(vertical: 8, horizontal: 16),
    ),
  );
}