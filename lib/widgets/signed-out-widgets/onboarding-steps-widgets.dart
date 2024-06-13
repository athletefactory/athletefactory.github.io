import 'package:athlete_factory/functions/dimensions.dart';
import 'package:flutter/material.dart';

import '../../config.dart';


Widget step(BuildContext context, int stepIndex){
  return Container(
    alignment: Alignment.topCenter,
    decoration: BoxDecoration(
      color: Colors.greenAccent.shade700.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    height: screenHeight(context) - AppBar().preferredSize.height - (1*(Config.logoSize)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Config.buttonColor,
          radius: 50,
          child: Text("${stepIndex+1}", style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
        ),
        SizedBox(
          height: 50,
        ),
        steps[stepIndex],
        SizedBox(height: 1*(Config.logoSize),),
      ],
    ),
  );
}

List<Widget> steps = [

  RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: 'Whether you are a ',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(
          text: 'Parent ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: 'or ',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextSpan(
          text: 'Youth Athlete ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: '\nClick on ',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextSpan(
          text: 'Get Started ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Config.buttonColor),
        ),
        const TextSpan(
          text: 'to sign up',
        ),
      ],
    ),
  ),

  RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: 'If you are looking to ',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(
          text: 'Receive Mentorship, ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: '\nPick the ',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextSpan(
          text: 'Sport ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: 'or ',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextSpan(
          text: 'Mentorship Service ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: 'that you desire, and ',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextSpan(
          text: 'book an appointment ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: 'with an ',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextSpan(
          text: 'NCAA Athlete!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Config.buttonColor),
        ),
      ],
    ),
  ),

  RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: 'If you are looking to ',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(
          text: 'Provide Mentorship, ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: '\n Follow the ',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextSpan(
          text: 'Registration Process',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: ', setup your ',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextSpan(
          text: 'Timing Availability, ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextSpan(
          text: ' and ',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextSpan(
          text: 'Your All Set!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Config.buttonColor),
        ),
      ],
    ),
  ),

];