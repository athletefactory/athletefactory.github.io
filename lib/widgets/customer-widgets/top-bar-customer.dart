import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/widgets/af-logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';


String currentCustomerPage = "";


Widget topBarCustomer(BuildContext context) {

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        margin: EdgeInsets.only(top: 10,bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(onPressed: () {
              currentCustomerPage = "Home";
              Navigator.popAndPushNamed(context, '/customer-home');
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
            currentCustomerPage = "Home";
            Navigator.popAndPushNamed(context, '/customer-home');
          }, child: Text('Home',style: TextStyle(color: currentCustomerPage == "Home"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold, fontSize: currentCustomerPage == "Home"?15:14),),),
          SizedBox(width: 20,),
          TextButton(onPressed: (){
            currentCustomerPage = "About";
            Navigator.popAndPushNamed(context, '/about-customer');
          }, child: Text('About',style: TextStyle(color: currentCustomerPage == "About"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold,fontSize: currentCustomerPage == "About"?15:14),),),
          SizedBox(width: 20,),
          TextButton(onPressed: (){
            currentCustomerPage = "Contact";
            Navigator.popAndPushNamed(context, '/contact-customer');
          }, child: Text('Contact',style: TextStyle(color: currentCustomerPage == "Contact"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold, fontSize: currentCustomerPage == "Contact"?15:14),),),
          SizedBox(width: 20,),
          TextButton(onPressed: (){
            currentCustomerPage = "Profile";
            Navigator.popAndPushNamed(context, '/customer-profile');
          }, child: Text('Profile',style: TextStyle(color: currentCustomerPage == "Profile"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold,fontSize: currentCustomerPage == "Profile"?15:14),),),
          SizedBox(width: 20,),
          TextButton(onPressed: (){
            currentCustomerPage = "My Bookings";
            Navigator.popAndPushNamed(context, '/customer-bookings');
          }, child: Text('My Bookings',style: TextStyle(color: currentCustomerPage == "My Bookings"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold,fontSize: currentCustomerPage == "My Bookings"?15:14),),),
          SizedBox(width: 20,),
          TextButton(onPressed: () async {
            currentCustomerPage = "Register";
            try {
              await FirebaseAuth.instance.signOut();
              userType = "";
              CustomerUser.resetInstance();
              // Navigate to login or home screen
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pushNamed(context, '/sign-in');
            } catch (e) {
              print("Error signing out: $e");
            }

            Navigator.pushNamed(context, '/sign-in');

          },
            child: Text('Sign out',style: TextStyle(color: currentCustomerPage == "Register"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold,fontSize: currentCustomerPage == "Register"?15:14),),),

        ],
      ),
    ],
  );
}