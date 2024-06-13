import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:athlete_factory/widgets/signed-out-widgets/top-bar-signed-out.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../functions/check_user_type.dart';
import '../../functions/platform-type.dart';
import '../../widgets/mentor-widgets/drawer-mentor.dart';
import '../../widgets/mentor-widgets/mobile-top-bar-mentor.dart';
import '../../widgets/mentor-widgets/signed_in_home_body_mentor.dart';
import '../../widgets/mentor-widgets/top-bar-mentor.dart';


class MentorHome extends StatefulWidget {
  const MentorHome({Key? key}) : super(key: key);

  @override
  State<MentorHome> createState() => _MentorHomeState();
}

class _MentorHomeState extends State<MentorHome> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        UserClass.loggedIn = false;
        UserClass.type = "";
        currentSignedOutPage = "Home";
        Navigator.popAndPushNamed(context, '/');
      }
      else {
        isLoggedIn = true;
        UserClass.loggedIn = true;

        userType = "mentor";
        UserClass.type = "mentor";

        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;

        currentMentorPage = "Home";
        initializeUser();
      }
    });
  }

  MentorUser mentor = MentorUser(currentUserEmail);

  Future<void> initializeUser() async {
    await mentor.setInfo();
  }


  @override
  Widget build(BuildContext context) {
    currentMentorPage = "Home";
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            signedInHomeBodyMentor(context, setState, mentor),
          ],
        ),
      ),
    );
  }
}
