
// ignore_for_file: file_names

import 'package:flutter/material.dart';

String defaultFont = "Righteous";

TextStyle textTitle({color=Colors.black, double font=38}) {
  return TextStyle(fontSize: font, color: color, fontFamily: defaultFont);
}

TextStyle textHighImportance({color=Colors.black, double font=28}) {
  return TextStyle(
    fontSize: font,
    color: color,
    fontFamily: defaultFont,
  );
}

TextStyle textMidImportance({color=Colors.black, double font=24}) {
  return TextStyle(
    fontSize: font,
    color: color,
    fontFamily: defaultFont,
  );
}

TextStyle textLowImportance({ color = Colors.black, double font = 16.0 }) {
  return TextStyle(
    fontSize: font,
    color: color,
    fontFamily: defaultFont,
  );
}
