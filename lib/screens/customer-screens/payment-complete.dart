import 'package:athlete_factory/functions/dimensions.dart';
import 'package:athlete_factory/functions/email_functions.dart';
import 'package:athlete_factory/services/database.dart';
import 'package:athlete_factory/widgets/af-logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';
import '../../functions/platform-type.dart';
import '../../models/user.dart';
import '../../widgets/customer-widgets/drawer-customer.dart';
import '../../widgets/customer-widgets/mobile-top-bar.dart';
import '../../widgets/customer-widgets/top-bar-customer.dart';
import '../signed-out-screens/signup_process.dart';
import '../signed-out-screens/verify_email.dart';

class PaymentComplete extends StatefulWidget {
  const PaymentComplete({Key? key}) : super(key: key);

  @override
  State<PaymentComplete> createState() => _PaymentCompleteState();
}

class _PaymentCompleteState extends State<PaymentComplete> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = true;
        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const SizedBox(width: 10,),
            afLogo(),
          ],
        ),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Container(
          width: screenWidth(context),
          height: screenHeight(context),
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Booking Successful", style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 20,),
              Icon(Icons.check_circle,color: Config.secondaryColor,size: 100,),
              const SizedBox(height: 50,),
              FutureBuilder(
                future: customerAccountsData(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return CircularProgressIndicator(
                        color: Config.secondaryColor,
                      );
                    }
                    else if(snapshot.hasData){
                      dynamic currentBooking = snapshot.data['${customer.getIndex()}']['session-to-book'];
                      if(currentBooking['exists']){
                        dynamic mentorBooking = {
                          'booking-day': customer.getBookingDay(),
                          'booking-month': customer.getBookingMonth(),
                          'booking-year': customer.getBookingYear(),
                          'booking-time': customer.getBookingTime(),
                          'user-name': customer.getName(),
                          'user-email': customer.getEmail(),
                          'services': [],
                          'cancelled': 'false',
                          'paid': 'true',
                        };

                        Database().addCustomerBooking(customer.getIndex(), customer.getMentorIndex(), customer.getBookingId());
                        Database().addMentorBooking(customer.getMentorIndex(), mentorBooking);
                        Database().addAdminBooking(customer.getIndex(), customer.getMentorIndex(), customer.getBookingId());
                        Database().removeSessionToBook(customer.getIndex());
                        Database().updateFreeSession(customer.getEmail());
                        EmailService.sendBookingConfirmationEmailToCustomer(customer.getName(), customer.getMentorName(), customer.getEmail(), "${customer.getBookingDay()}/${customer.getBookingMonth()}/${customer.getBookingYear()}", customer.getBookingTime());
                      }



                      return Container(
                        width: isDesktop(context)?screenWidth(context) / 4:screenWidth(context),
                        height: 50,
                        margin: const EdgeInsets.only(left: 20,right: 20),
                        decoration: BoxDecoration(
                          color: Config.secondaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: (){
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.pushNamed(context, '/customer-home');
                          },
                          child: const Text('Go to home',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
                      );
                    }
                  }
                  return CircularProgressIndicator(
                    color: Config.secondaryColor,
                  );
                },

              ),
            ],
          ),
        ),
      ),
    );
  }
}
