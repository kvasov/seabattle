import 'package:flutter/material.dart';
import 'package:seabattle/app/styles/media.dart';

TextStyle isolateDescriptionTextStyle(BuildContext context) {
  return TextStyle(
    fontSize: deviceType(context) == DeviceType.phone ? 14 : 18,
    fontWeight: FontWeight.w400,
  );
}