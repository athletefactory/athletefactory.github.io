import 'dart:typed_data';
import 'package:athlete_factory/config.dart';
import 'package:flutter/material.dart';
import '../../functions/dimensions.dart';
import '../../functions/platform-type.dart';
import 'onboarding-slider.dart';


Container signedOutHomeBody(BuildContext context, Uint8List imageBytes){

  if(!isDesktop(context)){
    return Container(
      width: screenWidth(context),
      height: screenHeight(context) - AppBar().preferredSize.height,
      margin: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Get Connected To", style: TextStyle(
            fontSize: screenWidth(context)/16,
            fontWeight: FontWeight.normal,
            //  color: Colors.black,
          ),),
          Row(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("The", style: TextStyle(
                fontSize: screenWidth(context)/16,
                fontWeight: FontWeight.normal,
                // color: Colors.black,
              ),),
              Text(" Top", style: TextStyle(
                fontSize: screenWidth(context)/16,
                fontWeight: FontWeight.bold,
                color: Config.secondaryColor,
                // color: Colors.black,
              ),),
              Text(" NCAA Athletes", style: TextStyle(
                fontSize: screenWidth(context)/16,
                fontWeight: FontWeight.bold,
                // color: Colors.black,
              ),),
            ],
          ),

          Text("Worldwide", style: TextStyle(
            fontSize: screenWidth(context)/16,
            fontWeight: FontWeight.normal,
            // color: Colors.black,
          ),),
          SizedBox(height: 20,),
          Text("Empowering Dreams, Igniting Success", style: TextStyle(
            fontSize: screenWidth(context)/30,
            //color: Colors.black,
          ),),
          Text("Your Athletic Partner", style: TextStyle(
            fontSize: screenWidth(context)/30,
            //color: Colors.black,
          ),),
          const SizedBox(height: 50,),

          Container(
            width: screenWidth(context)/1.5,
            height: 50,
            decoration: BoxDecoration(
              color: Config.buttonColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: (){
                Navigator.pushNamed(context, '/sign-up-process');
              },
              child: Text("Get Started", style: TextStyle(
                color: Colors.white,
              ),),
            ),
          ),
          Container(
            //margin: const EdgeInsets.only(left: 30, right: 30),
            width: screenWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child:  Image.asset('assets/images/georgiatech.png', width: Config.logoSize * 0.7, height: Config.logoSize * 0.7,),
                ),
                SizedBox(width: 20,),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child:  Image.asset('assets/images/create-x.webp', width: Config.logoSize * 0.7, height: Config.logoSize * 0.7,),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
  else{
    return Container(
      width: screenWidth(context),
      height: screenHeight(context) - AppBar().preferredSize.height - 40,
      margin: const EdgeInsets.only(top: 40,left: 50,right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Connecting Youth Athletes", style: TextStyle(
                          fontSize: Config.titleSize,
                          fontWeight: FontWeight.bold,
                          //  color: Colors.black,
                        ),),
                        Row(
                          children: [
                            Text("With", style: TextStyle(
                              fontSize: Config.titleSize,
                              fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            ),),
                            Text(" Top", style: TextStyle(
                              fontSize: Config.titleSize,
                              fontWeight: FontWeight.bold,
                              color: Config.secondaryColor,
                              // color: Colors.black,
                            ),),
                            Text(" NCAA Athletes", style: TextStyle(
                              fontSize: Config.titleSize,
                              fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            ),),
                          ],
                        ),

                        Text("Worldwide", style: TextStyle(
                          fontSize: Config.titleSize,
                          fontWeight: FontWeight.bold,
                          // color: Colors.black,
                        ),),
                        SizedBox(height: 20,),

                        Text(" Get Personalized Athletic Guidance", style: TextStyle(
                          fontSize: 18,
                          //color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),),
                        SizedBox(height: 5,),
                        Text(" By our World Class NCAA Athletes", style: TextStyle(
                          fontSize: 18,
                          //color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),),

                        const SizedBox(height: 50,),

                        TextButton(
                          onPressed: () async {
                            Navigator.pushNamed(context, '/sign-up-process');
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Config.secondaryColor, // Background color
                            minimumSize: Size(screenWidth(context) / 2.5, 55), // Set the minimum size of the button

                          ),
                          child: Text("Get Started", style: TextStyle(
                            color: Colors.white,
                          ),),
                        ),

                        SizedBox(height: 20,),
                        Container(
                          width: screenWidth(context) / 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child:  Image.asset('assets/images/georgiatech.png', width: Config.logoSize, height: Config.logoSize,),
                              ),
                              SizedBox(width: 30,),
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child:  Image.asset('assets/images/create-x.webp', width: Config.logoSize, height: Config.logoSize,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(child: Container()),
          onBoardingSlider(context),
        ],
      ),
    );
  }
}