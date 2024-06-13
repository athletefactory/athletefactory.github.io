import 'package:athlete_factory/functions/check_user_type.dart';
import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../functions/platform-type.dart';
import '../../widgets/customer-widgets/drawer-customer.dart';
import '../../widgets/customer-widgets/mobile-top-bar.dart';
import '../../widgets/customer-widgets/top-bar-customer.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';
import '../../widgets/website-widgets/about-body.dart';

class AboutCustomer extends StatefulWidget {
  const AboutCustomer({Key? key}) : super(key: key);

  @override
  State<AboutCustomer> createState() => _AboutCustomerState();
}

class _AboutCustomerState extends State<AboutCustomer> {


  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        userType = "";
        currentSignedOutPage = "About";
        Navigator.popAndPushNamed(context, '/about');
      } else {
        isLoggedIn = true;
        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;
        userType = "customer";
        currentCustomerPage = "About";
      }
    });
  }

  CustomerUser customer = CustomerUser(currentUserEmail);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isDesktop(context)?false:true,
        title: isDesktop(context)?topBarCustomer(context):mobileTopBar(),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: isMobile(context)?drawerCustomerWidget(context,scaffoldKey):Container(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: aboutBody(context, true),
      ),
    );
  }
}
