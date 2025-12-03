import 'package:flutter/material.dart';
import 'package:seabattle/app/styles/theme_extension/simple_button.dart';
import 'package:seabattle/app/styles/media.dart';

ButtonStyle simpleButtonStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).extension<ButtonColors>()?.backgroundColor,
    foregroundColor: Theme.of(context).extension<ButtonColors>()?.textColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    textStyle: TextStyle(
      color: Theme.of(context).extension<ButtonColors>()?.textColor,
      fontFamily: 'Roboto',
      fontSize: 16,
      height: 1.2,
      fontWeight: FontWeight.bold,
    ),
  );
}

ButtonStyle simpleButtonTextStyle(BuildContext context) {
  return TextButton.styleFrom(
    foregroundColor: Theme.of(context).extension<ButtonColors>()?.textColor,
    textStyle: TextStyle(
      fontSize: deviceType(context) == DeviceType.phone ? 14.0 : 24.0,
      fontWeight: FontWeight.w600,
    ),
  );
}