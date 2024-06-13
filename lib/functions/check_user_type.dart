import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/signed-out-screens/signup_process.dart';
import '../screens/signed-out-screens/verify_email.dart';
import '../services/database.dart';

String userType = "";
String currentUserEmail = "";
bool gotUserType = false;

FutureBuilder getUserType(){

  return FutureBuilder(
    future: userAccountsData(),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if(snapshot.connectionState == ConnectionState.done){
        if(snapshot.hasError){
          return const Text("");
        }
        else if(snapshot.hasData){
          User? user = FirebaseAuth.instance.currentUser;
          String email = user?.email ?? 'No Email';
          if(email != 'No Email'){
            if(snapshot.data[email]['user-type'] == "mentor"){
              userType = "mentor";
            }
            else{
              userType = "customer";
            }
            isLoggedIn = true;

            currentUserEmail = email;
            isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
            if(isEmailVerified){
              if(snapshot.data[email]['verified'] == "false"){
                Database().updateVerified(currentUserEmail);
              }
            }
          }
          else{
            isLoggedIn = false;
          }
          gotUserType = true;
          return Container();
        }
      }
      return Container();
    },

  );

}