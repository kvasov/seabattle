import 'package:flutter/material.dart';

import 'package:seabattle/app/styles/media.dart';

TextStyle dialogTitleStyle(BuildContext context) {
  return TextStyle(
    fontSize: deviceType(context) == DeviceType.phone ? 16 : 26,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

TextStyle dialogButtonStyle(BuildContext context) {
  return TextStyle(
    fontSize: deviceType(context) == DeviceType.phone ? 16 : 24,
    fontWeight: FontWeight.w400,
  );
}

TextStyle dialogContentStyle(BuildContext context) {
  return TextStyle(
    fontSize: deviceType(context) == DeviceType.phone ? 14 : 18,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}