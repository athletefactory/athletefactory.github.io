import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/widgets/signed-out-widgets/top-bar-signed-out.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';
import '../af-logo.dart';

String currentMentorPage = "";


Widget topBarMentor(BuildContext context) {

  print("MENTOR PAGE: $currentMentorPage");

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        margin: EdgeInsets.only(top: 10,bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(onPressed: () {

              currentMentorPage = "Home";
              Navigator.popAndPushNamed(context, '/mentor-home');

            },
              child: afLogo(),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: (){
            currentMentorPage = "Home";
            Navigator.popAndPushNamed(context, '/mentor-home');

          }, child: Text('Home',style: TextStyle(color: currentMentorPage == "Home"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold, fontSize: currentMentorPage == "Home"?15:14),),),
          SizedBox(width: 20,),
          TextButton(onPressed: (){
            currentMentorPage = "About";
            Navigator.popAndPushNamed(context, '/about-mentor');
          }, child: Text('About',style: TextStyle(color: currentMentorPage == "About"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold,fontSize: currentMentorPage == "About"?15:14),),),
          SizedBox(width: 20,),
          TextButton(onPressed: (){
            currentMentorPage = "Contact";
            Navigator.popAndPushNamed(context, '/contact-mentor');
          }, child: Text('Contact',style: TextStyle(color: currentMentorPage == "Contact"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold, fontSize: currentMentorPage == "Contact"?15:14),),),
          SizedBox(width: 20,),
          TextButton(onPressed: (){
            currentMentorPage = "Profile";
            Navigator.popAndPushNamed(context, '/mentor-profile');
          }, child: Text('Profile',style: TextStyle(color: currentMentorPage == "Profile"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold,fontSize: currentMentorPage == "Profile"?15:14),),)
              ,

          SizedBox(width: 20,),
          TextButton(onPressed: () async {
            currentMentorPage = "Register";
            try {
              await FirebaseAuth.instance.signOut();
              MentorUser.resetInstance();
              userType = "";
              // Navigate to login or home screen
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pushNamed(context, '/sign-in');
            } catch (e) {
              print("Error signing out: $e");
            }

            currentSignedOutPage = "Register";

            Navigator.pushNamed(context, '/sign-in');

          },
            child: Text('Sign out',style: TextStyle(color: currentMentorPage == "Register"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold,fontSize: currentMentorPage == "Register"?15:14),),),

        ],
      ),
    ],
  );
}