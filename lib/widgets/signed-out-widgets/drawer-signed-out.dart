import 'package:athlete_factory/colors/main-colors.dart';
import 'package:athlete_factory/widgets/signed-out-widgets/top-bar-signed-out.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../config.dart';


Container drawerSignedOutWidget(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey){

  return Container(
    color: Colors.white,
    width: 255,
    child: Drawer(
      child: ListView(
        children: [

          SizedBox(height: 20,),

          TextButton(
              onPressed: (){
                currentSignedOutPage = "Home";
                Navigator.popAndPushNamed(context, '/');
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
            leading: Image.asset("assets/images/${currentSignedOutPage != "Home"?'home':'home-selected'}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Home",style: TextStyle(
              fontSize: currentSignedOutPage == "Home"?15:14,
              fontWeight: currentSignedOutPage == "Home"?FontWeight.bold:FontWeight.normal,
              color: currentSignedOutPage == "Home"?Config.secondaryColor:Colors.black,
            ),),
            onTap: (){
              currentSignedOutPage = "Home";
              Navigator.popAndPushNamed(context, '/');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentSignedOutPage != "Services"?"services":"services-selected"}.png", width: Config.iconSize * 1.1, height: Config.iconSize * 1.1,),
            title: Text("Services",style: TextStyle(
              fontSize: currentSignedOutPage == "Services"?15:14,
              fontWeight: currentSignedOutPage == "Services"?FontWeight.bold:FontWeight.normal,
              color: currentSignedOutPage == "Services"?Config.secondaryColor:Colors.black,
            ),),
            onTap: (){
              currentSignedOutPage = "Services";
              Navigator.popAndPushNamed(context, '/services');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentSignedOutPage != "About"?"about":"about-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("About",style: TextStyle(
              fontSize: currentSignedOutPage == "About"?15:14,
              fontWeight: currentSignedOutPage == "About"?FontWeight.bold:FontWeight.normal,
              color: currentSignedOutPage == "About"?Config.secondaryColor:Colors.black,
            ),),
            onTap: (){
              currentSignedOutPage = "About";
              Navigator.popAndPushNamed(context, '/about');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentSignedOutPage != "Contact"?"contact":"contact-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Contact",style: TextStyle(
              fontSize: currentSignedOutPage == "Contact"?15:14,
              fontWeight: currentSignedOutPage == "Contact"?FontWeight.bold:FontWeight.normal,
              color: currentSignedOutPage == "Contact"?Config.secondaryColor:Colors.black,
            ),),
            onTap: (){
              currentSignedOutPage = "Contact";
              Navigator.popAndPushNamed(context, '/contact');
              scaffoldKey.currentState?.closeDrawer();
            },
          ),

          ListTile(
            leading: Image.asset("assets/images/${currentSignedOutPage != "Register"?"signin":"signin-selected"}.png", width: Config.iconSize, height: Config.iconSize,),
            title: Text("Sign in",style: TextStyle(
              fontSize: currentSignedOutPage == "Register"?15:14,
              fontWeight: currentSignedOutPage == "Register"?FontWeight.bold:FontWeight.normal,
              color: currentSignedOutPage == "Register"?Config.secondaryColor:Colors.black,
            ),),
            onTap: () {
              currentSignedOutPage = "Register";
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