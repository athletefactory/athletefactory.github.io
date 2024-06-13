import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import '../screens/signed-out-screens/signup_process.dart';

bool signedUp = true;

Future signUp(BuildContext context, TextEditingController emailController, TextEditingController passwordController) async {

  signedUp = true;

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

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim().toLowerCase(),
      password: passwordController.text.trim(),
    );
  }
  on FirebaseAuthException catch (e) {
    signedUp = false;
    if (kDebugMode) {
      print(e);
    }
  }

  if (signedUp) {
    currentUserName = "${firstNameController.text.trim()} ${lastNameController.text.trim()}";
  }
  else {
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }
}

Future sendVerificationEmail(BuildContext context) async {

  try{
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }
  catch (e){

    if (kDebugMode) {
      print(e);
    }

    const snackBar = SnackBar(
      content: Text("There was an error"),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}

Future resetPassword(BuildContext context, TextEditingController emailController) async {
  
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(),),
  );
  
  try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim().toLowerCase());
    Navigator.of(context).pop();
  }
  on FirebaseAuthException catch (e){
    print(e);
    Navigator.of(context).pop();
  }
}