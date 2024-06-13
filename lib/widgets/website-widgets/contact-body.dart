import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/dimensions.dart';
import '../../functions/platform-type.dart';

Container contactBody(BuildContext context, bool signedIn){

  return Container(
    width: screenWidth(context),
    margin: const EdgeInsets.only(left: 50, right: 50, bottom: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const  SizedBox(height: 50,),
        const Text("Contact Us", style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),),
        const SizedBox(height: 20,),
        const Text("If there is anything you would like to share or enquire with us about, please email ",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
          overflow: TextOverflow.clip,
        ),
        const Text("athletefactorystaff@gmail.com.",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20,),
        const Text("Examples",
          style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20,),
        const Text("- Customer: I want mentoring for my 14 year old son in swimming",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
        ),
        const  SizedBox(height: 10,),
        const Text("- Mentor: I would like to be a mentor (swimming)",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
        ),
        const  SizedBox(height: 10,),
        const  Text("- Mentee: I want mentoring (sport)",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
        ),
        const  SizedBox(height: 10,),
        const  Text("- Customer Enquiry: Where can I learn more about your services?",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
        ),
        const   SizedBox(height: 10,),
        const   Text("- Customer Feedback: I want to comment about a session I had",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
        ),
        const   SizedBox(height: 10,),
        const   Text("- Customer Support: I am having issues with xyz.",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
        ),
        const  SizedBox(height: 30,),
        signedIn?Container():Container(
          width: isDesktop(context)?300:screenWidth(context)/2,
          height: 50,
          decoration: BoxDecoration(
            color: Config.mainColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: (){
              Navigator.pushNamed(context, '/sign-up-process');
            },
            child: const  Text("Get Started", style: TextStyle(
              color: Colors.white,
            ),),
          ),
        ),
      ],
    ),
  );


}