import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/widgets/website-widgets/contact-body.dart';
import 'package:flutter/material.dart';
import '../../functions/check_user_type.dart';
import '../../functions/platform-type.dart';
import '../../widgets/signed-out-widgets/drawer-signed-out.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out-mobile.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    isLoggedIn = false;
    currentUserEmail = '';
    currentSignedOutPage = "Contact";
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
        child: contactBody(context, false),
      ),
    );
  }
}
