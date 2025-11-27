import 'package:flutter/material.dart';

final ButtonStyle gameBtnStyle = ElevatedButton.styleFrom(
  padding: EdgeInsets.only(top: 20),
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);

final TextStyle gameBtnTextStyle = TextStyle(
  color: Colors.blue.shade400,
  fontFamily: 'Roboto',
  fontSize: 16,
  height: 1.2,
  fontWeight: FontWeight.bold,
);