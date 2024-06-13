import 'package:flutter/material.dart';
import '../af-logo.dart';


Widget mobileTopBar(){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      afLogo(),
    ],
  );
}