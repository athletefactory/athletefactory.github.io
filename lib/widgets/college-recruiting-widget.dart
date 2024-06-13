import 'package:flutter/material.dart';
import '../functions/dimensions.dart';
import '../functions/platform-type.dart';

Widget collegeRecruitingWidget(BuildContext context){
  return Container(
    margin: const EdgeInsets.only(top: 20),
    padding: const EdgeInsets.only(bottom: 20),
    width: isDesktop(context)?screenWidth(context) / 1.5:screenWidth(context),
    height: isDesktop(context)?150:180,
    decoration: BoxDecoration(
      color: Colors.orangeAccent.shade700.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: !isDesktop(context)?collegeRecruitingMobileSlider():collegeRecruitingDesktopSlider(),
        ),
        Expanded(child: Container()),
        //SizedBox(height: isDesktop(context)?5:20,),
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
              Navigator.pushNamed(context, '/make-request');
            },
            child: Text('Get recruited now',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),),),
        ),
      ],
    ),
  );
}

Widget collegeRecruitingMobileSlider(){
  return RichText(
      text: const TextSpan(
        text: 'Elevate your chances of ',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'College Recruitment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ' using the experience of our ',
          ),
          TextSpan(
            text: 'NCAA Athletes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
  ));
}

Widget collegeRecruitingDesktopSlider(){
  return const Row(
    children: [
      Text("Elevate your chances of ", style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.normal,
      ),),
      Text("College Recruitment ", style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),),
      Text("using the experience of our ", style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.normal,
      ),),
      Text("NCAA Athletes", style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),),
    ],
  );
}