import 'dart:async';
import 'package:athlete_factory/functions/check_user_type.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../colors/main-colors.dart';
import '../../config.dart';
import '../../functions/authentication_functions.dart';
import '../../functions/dimensions.dart';
import '../../functions/platform-type.dart';
import '../../services/database.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}
bool isEmailVerified = false;

class _VerifyEmailState extends State<VerifyEmail> {

  Timer? timer;

  @override
  void initState(){

    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!isEmailVerified){
      sendVerificationEmail(context);
    }
  }


  Future<dynamic> checkEmailVerified(AsyncSnapshot<dynamic> snapshot) async {

    await FirebaseAuth.instance.currentUser!.reload();

    final user = FirebaseAuth.instance.currentUser!;

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      currentUserName = '';
      int index = 0;
      while(index < snapshot.data[0]['user-amount']){
        if(snapshot.data[0]['$index']['user-email'] == user.email){
          currentUserEmail = user.email!;
          await Database().updateVerified(user.email!);
         // currentUserIndex = index;
          break;
        }
        index++;
      }
      if (!context.mounted) return;
      Navigator.pushNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Verify Email",style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('A verification email has been sent to your email', style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20,),

          FutureBuilder(
            future: Future.wait([isMentor?mentorAccountsData():customerAccountsData()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: isDesktop(context)?screenWidth(context) / 3.5:screenWidth(context) / 2.5,
                      height: 50, // Adjust height here
                      child: TextButton(
                        onPressed: () => checkEmailVerified(snapshot),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          alignment: Alignment.center,
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), // Adjust border radius here
                            ),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );

                }
                else if (snapshot.hasError) {
                  return const Text("There is an error");
                }
              }
              return const CircularProgressIndicator();
            },

          ),

          const SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Didn't receive an email? ",style: TextStyle(color: Colors.black,fontSize: 16,),),
              TextButton(onPressed: (){sendVerificationEmail(context);},
                child: Text('Resend email',style: TextStyle(color: Config.mainColor,fontWeight: FontWeight.bold,fontSize: 16,decoration: TextDecoration.underline,),),
              )
            ],
          ),

        ],
      ),

    );
  }
}