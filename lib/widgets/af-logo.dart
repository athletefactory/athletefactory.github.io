import 'package:flutter/material.dart';
import '../config.dart';

Widget afLogo(){
  return  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("athlete", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
      Text("factory", style: TextStyle(color: Config.secondaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
    ],
  );
}