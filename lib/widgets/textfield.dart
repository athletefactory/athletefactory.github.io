import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../functions/dimensions.dart';

Widget textField(BuildContext context, String hintText, TextEditingController controller){
  return Container(
    width: screenWidth(context),
    height: 50,
    margin: EdgeInsets.only(top: 20,bottom: 20, left: 20, right: 20),
    decoration: BoxDecoration(
      color: Config.textFieldColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none, // Removes the border
          contentPadding: const EdgeInsets.symmetric(vertical: 15), // Adjust the vertical
        ),
      ),
    ),
  );
}

Widget emailTextField(BuildContext context, String hintText, TextEditingController controller){
  return Container(
    width: screenWidth(context),
    height: 50,
    margin: EdgeInsets.only(top: 20,bottom: 20, left: 20, right: 20),
    decoration: BoxDecoration(
      color: Config.textFieldColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none, // Removes the border
          contentPadding: const EdgeInsets.symmetric(vertical: 15), // Adjust the vertical
        ),
        //autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (email) => email != null && !EmailValidator.validate(email)?'Enter a valid email':null,
      ),
    ),
  );
}

Widget searchTextField(TextEditingController controller, void Function(String)? searchFunction){
  return Container(
    height: 50,
    margin: const EdgeInsets.only(left: 20,right: 20),
    decoration: BoxDecoration(
      //color: Colors.lightGreenAccent.shade100.withOpacity(0.5),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(width: 0.5, color: Colors.grey),
    ),
    child: TextField(
      controller: controller,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.grey,),
        hintText: 'Search by name',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        border: InputBorder.none, // Removes the border
        contentPadding: EdgeInsets.symmetric(vertical: 15), // Adjust the vertical
      ),
      onChanged: searchFunction,
    ),
  );
}

Widget passwordTextField(BuildContext context, String hintText, TextEditingController controller, Function setState){
  return Container(
    width: screenWidth(context),
    height: 50,
    margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
    decoration: BoxDecoration(
      color: Config.textFieldColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none, // Removes the border
          suffixIcon: IconButton(
            icon: Icon(Icons.visibility), // Add an icon for visibility
            onPressed: () {
              // Toggle the visibility of the password
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
        ),
      ),
    ),
  );
}


