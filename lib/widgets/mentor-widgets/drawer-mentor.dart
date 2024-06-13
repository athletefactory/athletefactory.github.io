import 'dart:ui';

import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/widgets/mentor-widgets/top-bar-mentor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../config.dart';
import '../../functions/check_user_type.dart';


Container drawerMentorWidget(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey){

  return Container(
    color: Colors.white,
    width: 255,
    child: Drawer(
      child: ListView(
        children: [

          SizedBox(height: 20,),

          TextButton(
              onPressed: (){
                currentMentorPage = "Home";
                Navigator.popAndPushNamed(context, '/mentor-home');
                scaffoldKey.currentState?.closeDrawer();
              },
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("athlete", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                  Text("factory", style: TextStyle(color: Config.secondaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              )),
          SizedBox(height: 40,),

          ListTile(
            leading: Image.asset("assets/images/${currentMentorPage != "Home"?'home':'home-selected'}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Home",style: TextStyle(
              fontSize: currentMentorPage == "Home"?15:14,
              color: currentMentorPage == "Home"?Config.secondaryColor:Colors.black,
              fontWeight: currentMentorPage == "Home"?FontWeight.bold:FontWeight.normal,
            ),),
            onTap: (){
              currentMentorPage = "Home";
              Navigator.popAndPushNamed(context, '/mentor-home');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentMentorPage != "About"?"about":"about-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("About",style: TextStyle(
              fontSize: currentMentorPage == "About"?15:14,
              fontWeight: currentMentorPage == "About"?FontWeight.bold:FontWeight.normal,
              color: currentMentorPage == "About"?Config.secondaryColor:Colors.black,
            ),),
            onTap: (){
              currentMentorPage = "About";
              Navigator.popAndPushNamed(context, '/about-mentor');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentMentorPage != "Contact"?"contact":"contact-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Contact",style: TextStyle(
              fontSize: currentMentorPage == "Contact"?15:14,
              fontWeight: currentMentorPage == "Contact"?FontWeight.bold:FontWeight.normal,
              color: currentMentorPage == "Contact"?Config.secondaryColor:Colors.black,
            ),),
            onTap: (){
              currentMentorPage = "Contact";
              Navigator.popAndPushNamed(context, '/contact-mentor');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentMentorPage != "Profile"?"profile":"profile-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Profile",style: TextStyle(
              fontSize: currentMentorPage == "Profile"?15:14,
              color: currentMentorPage == "Profile"?Config.secondaryColor:Colors.black,
              fontWeight: currentMentorPage == "Profile"?FontWeight.bold:FontWeight.normal,
            ),),
            onTap: (){
              currentMentorPage = "Profile";
              Navigator.popAndPushNamed(context, '/mentor-profile');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentMentorPage != "Register"?"signin":"signin-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Sign out",style: TextStyle(
              fontSize: currentMentorPage == "Register"?15:14,
              fontWeight: currentMentorPage == "Register"?FontWeight.bold:FontWeight.normal,
              color: currentMentorPage == "Register"?Config.secondaryColor:Colors.black,
            ),),
            onTap: () async {
              currentMentorPage = "Register";
              try {
                userType = "";
                MentorUser.resetInstance();
                await FirebaseAuth.instance.signOut();
                // Navigate to login or home screen
              } catch (e) {
                print("Error signing out: $e");
              }
              if (!context.mounted) return;
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pushNamed(context, '/sign-in');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),
        ],
      ),
    ),
  );

}