import 'package:athlete_factory/functions/check_user_type.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../functions/platform-type.dart';
import '../../models/user.dart';
import '../../widgets/mentor-widgets/drawer-mentor.dart';
import '../../widgets/mentor-widgets/mobile-top-bar-mentor.dart';
import '../../widgets/mentor-widgets/top-bar-mentor.dart';
import '../../widgets/website-widgets/about-body.dart';

class AboutMentor extends StatefulWidget {
  const AboutMentor({Key? key}) : super(key: key);

  @override
  State<AboutMentor> createState() => _AboutMentorState();
}

class _AboutMentorState extends State<AboutMentor> {

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
        UserClass.loggedIn = true;
        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;

        userType = "mentor";
        UserClass.type = "mentor";

        currentMentorPage = "About";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    currentMentorPage = "About";
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
        child: aboutBody(context, true),
      ),
    );
  }
}
