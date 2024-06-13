import '../../config.dart';
import 'package:flutter/material.dart';
import '../../functions/dimensions.dart';
import '../../functions/platform-type.dart';

Container aboutBody(BuildContext context, bool signedIn){
  return Container(
    margin:const  EdgeInsets.only(left: 50, right: 50, bottom: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50,),
        const Text("What is Athlete Factory?", style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),),
        const SizedBox(height: 20,),
        const  Text("Athlete Factory, launched in 2024 and proudly based at the Georgia Institute of Technology in the United States, embodies a revolutionary vision: to remove the barriers that hinder the development & learning of today’s youth athletes.",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
        ),
        const  SizedBox(height: 20,),
        const  Text("Our pioneering platform bridges the gap between your aspiring youth athletes and our esteemed network of NCAA Collegiate Athletes & Sports Professionals, offering unparalleled mentoring sessions. These sessions are meticulously designed to nurture the essential qualities of an ELITE Athlete, encompassing a holistic approach to long-term athletic development.",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
        ),
        const  SizedBox(height: 20,),
        const  Text("Our unwavering commitment is to provide a secure, tailored journey for every athlete and parent, ensuring the journey towards excellence is both safe and personal. Athlete Factory was founded by athletes for athletes, with the desire to innovate in the transfer of athletic wisdom across generations, fostering a legacy of knowledge and achievement.",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
        ),
        const  SizedBox(height: 20,),
        const  Text("We invite you to join us at Athlete Factory in realizing this vision. Together, we can create a legacy of success, mentorship, and unparalleled athletic development.",
          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),
        ),
        const    SizedBox(height: 30,),
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
            child:const  Text("Get Started", style: TextStyle(
              color: Colors.white,
            ),),
          ),
        ),
      ],
    ),
  );
}