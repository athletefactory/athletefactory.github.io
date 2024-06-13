import 'package:athlete_factory/functions/dimensions.dart';
import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:athlete_factory/services/database.dart';
import 'package:athlete_factory/widgets/signed-out-widgets/top-bar-signed-out.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';
import '../../functions/platform-type.dart';
import '../../functions/timing_functions.dart';
import '../../widgets/customer-widgets/drawer-customer.dart';
import '../../widgets/customer-widgets/mobile-top-bar.dart';
import '../../widgets/customer-widgets/top-bar-customer.dart';


class CustomerBookings extends StatefulWidget {
  const CustomerBookings({Key? key}) : super(key: key);

  @override
  State<CustomerBookings> createState() => _CustomerBookingsState();
}

class _CustomerBookingsState extends State<CustomerBookings> {

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
        isEmailVerified = user.emailVerified;
        userType = "customer";
        currentCustomerPage = "My Bookings";
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
          future: Future.wait([customerAccountsData(), userAccountsData(), mentorAccountsData()]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Container(
                    margin: EdgeInsets.only(top: (screenHeight(context) / 2) - AppBar().preferredSize.height),
                    child: Center(child: CircularProgressIndicator(color: Config.secondaryColor,))
                );
              }
              else if(snapshot.hasData){


                 return IntrinsicHeight(
                   child: Container(
                     margin: const EdgeInsets.all(10),
                     width: screenWidth(context),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const SizedBox(height: 30,),
                         const Text("My Bookings", style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                         ),),
                         const SizedBox(height: 20,),
                         SizedBox(
                           width: !isDesktop(context)?screenWidth(context):screenWidth(context) / 2.5,
                           height: screenHeight(context),
                           child: ListView.builder(
                               shrinkWrap: true,
                               itemCount: snapshot.data[0]['${customer.getIndex()}']['bookings'].length,
                               itemBuilder: (context,index){

                                 int mentorId = snapshot.data[0]['${customer.getIndex()}']['bookings'][index]['mentor-id'];
                                 int bookingId = snapshot.data[0]['${customer.getIndex()}']['bookings'][index]['booking-id'];

                                 return !isDateTimeAfterAppointment(snapshot.data[2]['$mentorId']['bookings'][bookingId])?ListTile(
                                   leading: const VerticalDivider(color: Colors.green, width: 5,),
                                   title: SizedBox(
                                     width: screenWidth(context) / 2,
                                     child: Text("Mentor: ${snapshot.data[2]['$mentorId']['user-name']}", style: const TextStyle(fontWeight: FontWeight.bold),),
                                   ),
                                   subtitle: Text("${snapshot.data[2]['$mentorId']['bookings'][bookingId]['booking-day']}/${snapshot.data[2]['$mentorId']['bookings'][bookingId]['booking-month']}/${snapshot.data[2]['$mentorId']['bookings'][bookingId]['booking-year']} at ${snapshot.data[2]['$mentorId']['bookings'][bookingId]['booking-time']} EST"),

                                 ):Container();
                               }),
                         ),
                       ],
                     ),
                   ),
                 );
              }
            }
            return Container(
                margin: EdgeInsets.only(top: (screenHeight(context) / 2) - AppBar().preferredSize.height),
                child: Center(child: CircularProgressIndicator(color: Config.secondaryColor,))
            );
          },

        ),
      ),
    );
  }
}
