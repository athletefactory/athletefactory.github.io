import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:athlete_factory/functions/dimensions.dart';
import 'package:flutter/material.dart';
import '../functions/platform-type.dart';
import 'college-recruiting-widget.dart';
import 'make-request-widget.dart';

Widget servicesSlider(BuildContext context){
  return SizedBox(
    height: isDesktop(context)?170:180,
    width: screenWidth(context),
    child: AnotherCarousel(
      autoplayDuration: const Duration(seconds: 5),
      images: [
        collegeRecruitingWidget(context),
        makeRequestWidget(context),
      ],
      showIndicator: false,
      dotSize: 4,
    ),
  );
}