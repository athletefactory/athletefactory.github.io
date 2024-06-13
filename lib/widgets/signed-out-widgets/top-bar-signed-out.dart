import 'package:flutter/material.dart';
import '../../config.dart';
import '../af-logo.dart';

String currentSignedOutPage = "";

Widget topBarSignedOut(BuildContext context) {

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {
              currentSignedOutPage = "Home";
              Navigator.popAndPushNamed(context, '/');
            },
            child: afLogo(),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: (){
            currentSignedOutPage = "Home";
            Navigator.popAndPushNamed(context, '/');
          }, child: Text('Home',style: TextStyle(color: currentSignedOutPage == "Home"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold, fontSize: currentSignedOutPage == "Home"?15:14),),),
          const SizedBox(width: 20,),
          TextButton(onPressed: (){
            currentSignedOutPage = "Services";
            Navigator.popAndPushNamed(context, '/services');
          }, child: Text('Services',style: TextStyle(color: currentSignedOutPage == "Services"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold,fontSize: currentSignedOutPage == "Services"?15:14),),),
          const SizedBox(width: 20,),
          TextButton(onPressed: (){
            currentSignedOutPage = "About";
            Navigator.popAndPushNamed(context, '/about');
          }, child: Text('About',style: TextStyle(color: currentSignedOutPage == "About"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold,fontSize: currentSignedOutPage == "About"?15:14),),),
          const SizedBox(width: 20,),
          TextButton(onPressed: (){
            currentSignedOutPage = "Contact";
            Navigator.popAndPushNamed(context, '/contact');
          }, child: Text('Contact',style: TextStyle(color: currentSignedOutPage == "Contact"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold, fontSize: currentSignedOutPage == "Contact"?15:14),),),
          const SizedBox(width: 20,),
          TextButton(onPressed: () async {
            currentSignedOutPage = "Register";
            Navigator.popAndPushNamed(context, '/sign-in');
          },
            child: Text('Sign in',style: TextStyle(color: currentSignedOutPage == "Register"?Config.secondaryColor:Colors.black,fontWeight: FontWeight.bold,fontSize: currentSignedOutPage == "Register"?15:14),),),
          const SizedBox(width: 30,),
          Container(
            width: 150,
            height: 40,
            decoration: BoxDecoration(
              color: Config.buttonColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: (){
                Navigator.popAndPushNamed(context, '/sign-up-process');
              },
              child: Text('Get Started',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
          ),
        ],
      ),
    ],
  );
}