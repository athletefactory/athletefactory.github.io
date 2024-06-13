import 'package:flutter/material.dart';
import 'dimensions.dart';

bool isDesktop(BuildContext context) => screenWidth(context) >= 800;

bool isMobile(BuildContext context) => screenWidth(context) < 800;