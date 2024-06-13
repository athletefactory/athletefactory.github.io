import 'package:athlete_factory/functions/check_user_type.dart';
import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:athlete_factory/widgets/customer-widgets/top-bar-customer.dart';
import 'package:athlete_factory/widgets/mentor-widgets/top-bar-mentor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/image_functions.dart';
import '../../functions/platform-type.dart';
import '../../widgets/signed-out-widgets/drawer-signed-out.dart';
import '../../widgets/signed-out-widgets/signed_out_home_body.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out-mobile.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Uint8List _imageBytes = Uint8List(0);
  Uint8List testimonialZero = Uint8List(0);

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        userType = "";
      } else {
        isLoggedIn = true;
        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;
        UserClass currentUser = UserClass(currentUserEmail);
        initializeUser(currentUser);
      }
    });
    currentSignedOutPage = "Home";
  }

  Future<void> initializeUser(UserClass user) async {
    await user.setInfo();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isDesktop(context)?false:true,
        title: isDesktop(context)?topBarSignedOut(context):topBarSignedOutMobile(),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: isMobile(context)?drawerSignedOutWidget(context, scaffoldKey):Container(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getUserType(),
            signedOutHomeBody(context, _imageBytes),
          ],
        ),
      ),
    );
  }
}
