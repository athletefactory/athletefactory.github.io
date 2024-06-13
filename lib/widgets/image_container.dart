import 'dart:typed_data';

import 'package:flutter/material.dart';

Container imageContainer(Uint8List imageBytes, double width, double height, double borderRadius){
  return Container(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius), // Adjust the radius as needed
      child: Image.memory(
        imageBytes,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    ),
  );
}