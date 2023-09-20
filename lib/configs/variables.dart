import 'package:flutter/material.dart';

class Variables {
  static const primaryColor = Color.fromARGB(255, 144, 106, 250);
  static const secondaryColor = Color.fromRGBO(207, 189, 255, 1);
  static final getSecondaryColorWithOpacity =
      (opacity) => Color.fromRGBO(207, 189, 255, opacity);
}
