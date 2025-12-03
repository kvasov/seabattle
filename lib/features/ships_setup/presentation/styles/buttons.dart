import 'package:flutter/material.dart';
import 'package:seabattle/app/styles/media.dart';
import 'package:seabattle/app/styles/widgets/simple_button.dart';

ButtonStyle shipTypeButtonStyle(BuildContext context, {bool selected = false}) {
  return simpleButtonStyle(context).copyWith(
    padding: WidgetStateProperty.all(
      deviceType(context) == DeviceType.tablet
          ? EdgeInsets.symmetric(vertical: 16, horizontal: 32)
          : EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    backgroundColor: WidgetStateProperty.all(selected ? Colors.blue : null),
    foregroundColor: WidgetStateProperty.all(selected ? Colors.white : null),
  );
}

TextStyle shipTypeButtonTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: deviceType(context) == DeviceType.phone ? 12 : 24,
    fontWeight: FontWeight.w600,
  );
}

ButtonStyle startGameButtonStyle(BuildContext context) {
  return simpleButtonStyle(context).copyWith(
    padding: WidgetStateProperty.all(
      deviceType(context) == DeviceType.tablet
          ? EdgeInsets.symmetric(vertical: 16, horizontal: 32)
          : EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    textStyle: WidgetStateProperty.all(TextStyle(
      fontSize: deviceType(context) == DeviceType.phone ? 14 : 24,
      fontWeight: FontWeight.w600,
    )),
  );
}

ButtonStyle cancelGameButtonStyle(BuildContext context) {
  return simpleButtonStyle(context).copyWith(
    padding: WidgetStateProperty.all(
      deviceType(context) == DeviceType.tablet
          ? EdgeInsets.symmetric(vertical: 16, horizontal: 32)
          : EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
  );
}

TextStyle cancelGameButtonTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: deviceType(context) == DeviceType.phone ? 14 : 24,
    fontWeight: FontWeight.w600,
  );
}

ButtonStyle isolateButtonStyle(BuildContext context) {
  return simpleButtonStyle(context).copyWith(
    padding: WidgetStateProperty.all(
      deviceType(context) == DeviceType.tablet
          ? EdgeInsets.symmetric(vertical: 16, horizontal: 32)
          : EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    textStyle: WidgetStateProperty.all(TextStyle(
      fontSize: deviceType(context) == DeviceType.phone ? 14 : 24,
      fontWeight: FontWeight.w600,
    )),
  );
}
