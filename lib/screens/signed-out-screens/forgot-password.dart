import 'package:athlete_factory/functions/authentication_functions.dart';
import 'package:athlete_factory/functions/dimensions.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/services/database.dart';
import 'package:athlete_factory/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';
import '../../functions/platform-type.dart';
import '../../colors/main-colors.dart';
import '../../widgets/signed-out-widgets/drawer-signed-out.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out-mobile.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  bool emailSent = false;
  bool invalid = false;

  @override
  void initState() {
    super.initState();
    isLoggedIn = false;
    currentUserEmail = '';
    currentSignedOutPage = "Register";
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
        child: SizedBox(
          width: screenWidth(context),
          height: screenHeight(context),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30,right: 30),
                  width: isDesktop(context)?screenWidth(context) / 2.5:screenWidth(context),
                  height: screenHeight(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*
                      SizedBox(
                        width: isDesktop(context)?screenWidth(context) / 2.5:screenWidth(context),
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(labelText: 'Email'),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) => email != null && !EmailValidator.validate(email)?'Enter a valid email':null,
                        ),
                      ),
                      */
                      emailTextField(context, "Email", emailController),
                      const SizedBox(height: 30,),

                      FutureBuilder(
                        future: userAccountsData(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            if(snapshot.hasError){
                              return const Text("");
                            }
                            else if(snapshot.hasData){
                              return Container(
                                width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context)/2,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Config.secondaryColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextButton(
                                  onPressed: (){
                                    if (_formKey.currentState!.validate()) {
                                      // Validation passed, do something

                                      if(snapshot.data[emailController.text] != null){
                                        setState(() {
                                          emailSent = true;
                                          invalid = false;
                                        });
                                        resetPassword(context, emailController);
                                      }
                                      else{
                                        setState(() {
                                          invalid = true;
                                        });
                                      }
                                    } else {
                                      // Validation failed
                                      setState(() {
                                        invalid = true;
                                      });
                                    }

                                  },
                                  child: const Text('Reset Password', style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                ),
                              );
                            }
                          }
                          return CircularProgressIndicator(
                            color: Config.secondaryColor,
                          );
                        },
                      ),

                      SizedBox(height: emailSent || invalid?30:0,),
                      invalid?const Text("This account does not exist", style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),):Container(),
                      emailSent?Text("An email has been sent to ${emailController.text}", style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),):Container(),
                      SizedBox(height: emailSent?20:0,),
                      emailSent?const Text("Didn't receive an email?", style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),):Container(),

                      SizedBox(height: emailSent?20:0,),
                      emailSent?Container(
                        width: isDesktop(context)?screenWidth(context) / 6:screenWidth(context)/2,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: (){
                            setState(() {
                              emailSent = true;
                            });
                            resetPassword(context, emailController);
                          },
                          child: const Text('Resend email', style: TextStyle(
                            color: Colors.white,
                          ),),
                        ),
                      ):Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}