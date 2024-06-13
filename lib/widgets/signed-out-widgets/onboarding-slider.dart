import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/dimensions.dart';
import 'onboarding-steps-widgets.dart';


Widget onBoardingSlider(BuildContext context){
  return Container(
    alignment: Alignment.topCenter,
    height: screenHeight(context) - AppBar().preferredSize.height  - (1*(Config.logoSize)),
    width: screenWidth(context) / 2.2,
    margin: EdgeInsets.only(right: 20),
    child: AnotherCarousel(
      autoplayDuration: const Duration(seconds: 5),
      images: [
        ClipRRect(
            borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
            child: Image.asset('assets/images/Max01.jpeg', width: screenWidth(context) / 2.2, height: screenHeight(context) - AppBar().preferredSize.height - (1*(Config.logoSize)), fit: BoxFit.fill,)
        ),
        step(context, 0),
        step(context, 1),
        step(context, 2),
      ],
      showIndicator: false,
      dotSize: 4,
    ),
  );
}