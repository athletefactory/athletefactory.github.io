import 'package:athlete_factory/functions/dimensions.dart';
import 'package:athlete_factory/functions/email_functions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';
import '../../functions/platform-type.dart';
import '../../models/user.dart';
import '../../widgets/customer-widgets/mobile-top-bar.dart';
import '../../widgets/customer-widgets/top-bar-customer.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';
import '../signed-out-screens/signup_process.dart';
import '../signed-out-screens/verify_email.dart';


class MakeRequest extends StatefulWidget {
  const MakeRequest({Key? key}) : super(key: key);

  @override
  State<MakeRequest> createState() => _MakeRequestState();
}

class _MakeRequestState extends State<MakeRequest> {

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        currentSignedOutPage = "Home";
        userType = "";
      } else {
        isLoggedIn = true;
        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;
        userType = "customer";
        UserClass.type = "customer";
        currentCustomerPage = "Profile";
        initializeUser();
      }
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: screenWidth(context),
          height: screenHeight(context),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Tell us what you need, and we'll get back to you within 48 hours", style: TextStyle(fontSize: isDesktop(context)?20:18, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                SizedBox(height: 30,),
                !isLoggedIn?Container(
                  height: 50,
                  width: isDesktop(context)?screenWidth(context) / 2:screenWidth(context),
                  margin: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    //color: Colors.lightGreenAccent.shade100.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 0.5, color: Colors.grey),
                  ),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 1,
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none, // Removes the border
                      contentPadding: EdgeInsets.symmetric(vertical: 15), // Adjust the vertical
                    ),
                  ),
                ):Container(),
                !isLoggedIn?Container(
                  height: 50,
                  width: isDesktop(context)?screenWidth(context) / 2:screenWidth(context),
                  margin: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    //color: Colors.lightGreenAccent.shade100.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 0.5, color: Colors.grey),
                  ),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 1,
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none, // Removes the border
                      contentPadding: EdgeInsets.symmetric(vertical: 15), // Adjust the vertical
                    ),
                    validator: (email) => email != null && !EmailValidator.validate(email)?'Enter a valid email':null,
                  ),
                ):Container(),
                Container(
                  height: 50,
                  width: isDesktop(context)?screenWidth(context) / 2:screenWidth(context),
                  margin: const EdgeInsets.only(left: 20,right: 20, bottom: 20),
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    //color: Colors.lightGreenAccent.shade100.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 0.5, color: Colors.grey),
                  ),
                  child: TextField(
                    minLines: 1,
                    maxLines: 1,
                    controller: subjectController,
                    decoration: const InputDecoration(
                      hintText: 'Subject',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none, // Removes the border
                      contentPadding: EdgeInsets.symmetric(vertical: 15), // Adjust the vertical
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: isDesktop(context)?screenWidth(context) / 2:screenWidth(context),
                  margin: const EdgeInsets.only(left: 20,right: 20),
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    //color: Colors.lightGreenAccent.shade100.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 0.5, color: Colors.grey),
                  ),
                  child: TextField(
                    minLines: 5,
                    maxLines: 5,
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your request here',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none, // Removes the border
                      contentPadding: EdgeInsets.symmetric(vertical: 15), // Adjust the vertical
                    ),
                  ),
                ),

                Container(
                  width: isDesktop(context)?screenWidth(context) / 4:screenWidth(context),
                  height: 50,
                  margin: const EdgeInsets.only(left: 20,right: 20, top: 30),
                  decoration: BoxDecoration(
                    color: Config.secondaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: () async {

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              Center(
                                child: CircularProgressIndicator(
                                  color: Config.secondaryColor,
                                ),
                              )
                      );

                      if(!isLoggedIn){
                        if(_formKey.currentState!.validate()){
                          await EmailService.sendRequestEmail(nameController.text, emailController.text.toLowerCase(), subjectController.text, messageController.text);
                          if (!context.mounted) return;
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.pushNamed(context, '/customer-home');
                        }
                      }
                      else{
                        await EmailService.sendRequestEmail(customer.getName(), customer.getEmail(), subjectController.text, messageController.text);
                        if (!context.mounted) return;
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.pushNamed(context, '/customer-home');
                      }
                    },
                    child: const Text('Send email',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
                ),

              ],
            ),
          ),
        )
      ),
    );
  }
}
