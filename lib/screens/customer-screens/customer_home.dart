import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';
import '../../functions/platform-type.dart';
import '../../widgets/customer-widgets/drawer-customer.dart';
import '../../widgets/customer-widgets/mobile-top-bar.dart';
import '../../widgets/customer-widgets/signed_in_home_body_customer.dart';
import '../../widgets/customer-widgets/top-bar-customer.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({Key? key}) : super(key: key);

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        userType = "";
        currentSignedOutPage = "Home";
        Navigator.popAndPushNamed(context, '/');
      } else {
        isLoggedIn = true;
        currentUserEmail = user.email!;
        currentCustomerPage = "Home";
        userType = "customer";
        UserClass.type = "customer";
        initializeUser();
      }
    });
  }

  CustomerUser customer = CustomerUser(currentUserEmail);
  Future<void> initializeUser() async {
    await customer.setInfo();
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            signedInHomeBodyCustomer(context, customer),
          ],
        ),
      ),
    );
  }
}
