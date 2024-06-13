import 'dart:ui';

import 'package:athlete_factory/widgets/customer-widgets/top-bar-customer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../functions/check_user_type.dart';
import '../../models/user.dart';
import '../../config.dart';

Container drawerCustomerWidget(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey){

  return Container(
    color: Colors.white,
    width: 255,
    child: Drawer(
      child: ListView(
        children: [

          SizedBox(height: 20,),

          TextButton(
              onPressed: (){
                currentCustomerPage = "Home";
                Navigator.popAndPushNamed(context, '/customer-home');
                scaffoldKey.currentState?.closeDrawer();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("athlete", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                  Text("factory", style: TextStyle(color: Config.secondaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              )),
          SizedBox(height: 40,),

          ListTile(
            leading: Image.asset("assets/images/${currentCustomerPage != "Home"?'home':'home-selected'}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Home",style: TextStyle(
              color: currentCustomerPage == "Home"?Config.secondaryColor:Colors.black,
              fontWeight: currentCustomerPage == "Home"?FontWeight.bold:FontWeight.normal,
              fontSize: currentCustomerPage == "Home"?15:14,
            ),),
            onTap: (){
              currentCustomerPage = "Home";
              Navigator.popAndPushNamed(context, '/customer-home');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentCustomerPage != "About"?"about":"about-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("About",style: TextStyle(
            color: currentCustomerPage == "About"?Config.secondaryColor:Colors.black,
              fontWeight: currentCustomerPage == "About"?FontWeight.bold:FontWeight.normal,
              fontSize: currentCustomerPage == "About"?15:14,
            ),),
            onTap: (){
              currentCustomerPage = "About";
              Navigator.popAndPushNamed(context, '/about-customer');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentCustomerPage != "Contact"?"contact":"contact-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Contact",style: TextStyle(
              color: currentCustomerPage == "Contact"?Config.secondaryColor:Colors.black,
              fontSize: currentCustomerPage == "Contact"?15:14,
              fontWeight: currentCustomerPage == "Contact"?FontWeight.bold:FontWeight.normal,
            ),),
            onTap: (){
              currentCustomerPage = "Contact";
              Navigator.popAndPushNamed(context, '/contact-customer');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),


          ListTile(
            leading: Image.asset("assets/images/${currentCustomerPage != "Profile"?"profile":"profile-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Profile",style: TextStyle(
              fontSize: currentCustomerPage == "Profile"?15:14,
              color: currentCustomerPage == "Profile"?Config.secondaryColor:Colors.black,
              fontWeight: currentCustomerPage == "Profile"?FontWeight.bold:FontWeight.normal,
            ),),
            onTap: (){
              currentCustomerPage = "Profile";
              Navigator.popAndPushNamed(context, '/customer-profile');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),


          ListTile(
            leading: Image.asset("assets/images/${currentCustomerPage != "My Bookings"?"booking":"booking-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("My Bookings",style: TextStyle(
              fontSize: currentCustomerPage == "My Bookings"?15:14,
              color: currentCustomerPage == "My Bookings"?Config.secondaryColor:Colors.black,
              fontWeight: currentCustomerPage == "My Bookings"?FontWeight.bold:FontWeight.normal,
            ),),
            onTap: (){
              currentCustomerPage = "My Bookings";
              Navigator.popAndPushNamed(context, '/customer-bookings');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentCustomerPage != "Register"?"signin":"signin-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Sign out",style: TextStyle(
              fontSize: currentCustomerPage == "Register"?15:14,
              color: currentCustomerPage == "Register"?Config.secondaryColor:Colors.black,
              fontWeight: currentCustomerPage == "Register"?FontWeight.bold:FontWeight.normal,
            ),),
            onTap: () async {
              currentCustomerPage = "Register";
              try {
                userType = "";
                CustomerUser.resetInstance();
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