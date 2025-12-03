import 'package:flutter/material.dart';

enum DeviceType { smallPhone, phone, tablet }

DeviceType deviceType(BuildContext context) {
  final w = MediaQuery.of(context).size.width;

  if (w < 360) return DeviceType.smallPhone;
  if (w < 600) return DeviceType.phone;
  return DeviceType.tablet;
}