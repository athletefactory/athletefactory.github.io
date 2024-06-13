import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:athlete_factory/services/database.dart';
import 'package:athlete_factory/widgets/signed-out-widgets/top-bar-signed-out.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';
import '../../functions/dimensions.dart';
import '../../functions/platform-type.dart';
import '../../widgets/customer-widgets/drawer-customer.dart';
import '../../widgets/customer-widgets/mobile-top-bar.dart';
import '../../widgets/customer-widgets/top-bar-customer.dart';


class CustomerProfile extends StatefulWidget {
  const CustomerProfile({Key? key}) : super(key: key);

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String mainSport = '';
  String userName = '';
  String parentName = '';

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        currentSignedOutPage = "Home";
        userType = "";
        Navigator.popAndPushNamed(context, '/');
      } else {
        isLoggedIn = true;
        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;
        currentCustomerPage = "Profile";
        userType = "customer";
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
        child: FutureBuilder(
          future: Future.wait([customerAccountsData(), categoriesData(), userAccountsData()]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Center(child: CircularProgressIndicator(color: Config.secondaryColor,));
              }
              else if(snapshot.hasData){
                return Column(
                  children: [
                    profilePage(snapshot),
                  ],
                );
              }
            }
            return Center(child: CircularProgressIndicator(color: Config.secondaryColor,));
          },
        ),
      ),
    );
  }

  Container profilePage(AsyncSnapshot<dynamic> snapshot){

    parentName = snapshot.data[0]['${customer.getIndex()}']['parent-name'];
    if(parentName.isNotEmpty){
      userName = snapshot.data[0]['${customer.getIndex()}']['user-name'];
    }
    else{
      userName = customer.getName();
    }
    mainSport = snapshot.data[0]['${customer.getIndex()}']['main-sports'][0];

    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50,),
          parentName.isNotEmpty?const Text("Parent Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),):Container(),
          SizedBox(height: snapshot.data[0]['${customer.getIndex()}']['parent-name'] != ""?10:0,),
          parentName.isNotEmpty?
          SizedBox(
            width: isDesktop(context)?screenWidth(context) / 5:screenWidth(context)/1.5,
            child:  ListTile(
              leading: VerticalDivider(
                color: Config.secondaryColor,
                width: 2,
              ),
              title: Text(parentName),
            ),
          ):Container(),
          SizedBox(height: parentName.isNotEmpty?30:0,),
          Text(parentName.isNotEmpty?"Athlete Name":"Full Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 10,),
          Container(
            width: isDesktop(context)?screenWidth(context) / 5:screenWidth(context)/1.5,
            child:  ListTile(
              leading: VerticalDivider(
                color: Config.secondaryColor,
                width: 2,
              ),
              title: Text(userName),
            ),
          ),
          const SizedBox(height: 30,),
          const Text("Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 10,),

          Container(
            width: isDesktop(context)?screenWidth(context) :screenWidth(context),
            child:  ListTile(
              leading: VerticalDivider(
                color: Colors.orange,
                width: 2,
              ),
              title: Text(customer.getEmail()),
            ),
          ),

          SizedBox(height: 30,),
          Text("Sport", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          SizedBox(height: 10,),
          Container(
            width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context),
            height: 50,
            child: ListView.builder(
                itemCount: snapshot.data[0]['${customer.getIndex()}']['main-sports'].length,
                itemBuilder: (context,index){
                  return ListTile(
                    leading: VerticalDivider(color: Colors.blue,width: 3,),
                    title: Text(snapshot.data[0]['${customer.getIndex()}']['main-sports'][index]),
                  );
                }),
          ),
          SizedBox(height: 30,),
        ],
      ),
    );
  }

}
