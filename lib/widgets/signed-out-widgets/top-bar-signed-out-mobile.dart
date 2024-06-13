import 'package:flutter/material.dart';

import '../../config.dart';


Widget topBarSignedOutMobile(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text("athlete", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
      Text("factory", style: TextStyle(color: Config.secondaryColor, fontSize: 20, fontWeight: FontWeight.bold),),          ],
  );
}