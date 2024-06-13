import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../functions/check_user_type.dart';
import '../../functions/platform-type.dart';
import '../../widgets/mentor-widgets/drawer-mentor.dart';
import '../../widgets/mentor-widgets/mobile-top-bar-mentor.dart';
import '../../widgets/mentor-widgets/top-bar-mentor.dart';
import '../../widgets/website-widgets/contact-body.dart';

class ContactMentor extends StatefulWidget {
  const ContactMentor({Key? key}) : super(key: key);

  @override
  State<ContactMentor> createState() => _ContactMentorState();
}

class _ContactMentorState extends State<ContactMentor> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        UserClass.loggedIn = false;
        UserClass.type = "";
      } else {
        isLoggedIn = true;
        userType = "mentor";

        UserClass.loggedIn = true;
        UserClass.type = "mentor";

        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;
        currentMentorPage = "Contact";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    currentMentorPage = "Contact";
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isDesktop(context)?false:true,
        title: isDesktop(context)?topBarMentor(context):mobileTopBarMentor(),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: isMobile(context)?drawerMentorWidget(context, scaffoldKey):Container(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: contactBody(context, true),
      ),
    );
  }
}