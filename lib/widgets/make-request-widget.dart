import 'package:athlete_factory/config.dart';
import 'package:flutter/material.dart';
import '../functions/dimensions.dart';
import '../functions/platform-type.dart';

Widget makeRequestWidget(BuildContext context){
  return Container(
    margin: const EdgeInsets.only(top: 20),
    width: isDesktop(context)?screenWidth(context) / 1.5:screenWidth(context),
    height: isDesktop(context)?150:170,
    decoration: BoxDecoration(
      color: Colors.lightGreenAccent.shade700.withOpacity(0.05),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: !isDesktop(context)?makeRequestMobileSlider():makeRequestDesktopSlider(),
        ),
        SizedBox(height: 5,),
        Container(
          width: 300,
          height: 40,
          margin: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: (){
              Navigator.popAndPushNamed(context, '/make-request');
            },
            child: Text('Make a request',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),),),
        ),
      ],
    ),
  );
}

Widget makeRequestMobileSlider(){

  return RichText(
      text: TextSpan(
        text: "Tell us what you are looking for, we will ",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        children: <TextSpan>[
          const TextSpan(
            text: 'find the right ',
          ),
          TextSpan(
            text: 'NCAA Athlete ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Config.secondaryColor),
          ),
          const TextSpan(
            text: 'for you ',
          ),
          TextSpan(
            text: 'instantly',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
  );

}
Widget makeRequestDesktopSlider(){
  return Row(
    children: [
      const Text("Tell us what you are looking for, and we'll find the right athlete ", style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.normal,
      ),),
      Text("NCAA Athlete ", style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Config.secondaryColor,
      ),),
      const Text("for you instantly", style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.normal,
      ),),
    ],
  );
}

