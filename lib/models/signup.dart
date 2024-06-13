import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import '../functions/authentication_functions.dart';
import '../functions/dimensions.dart';
import '../functions/image_functions.dart';
import '../functions/platform-type.dart';
import '../screens/signed-out-screens/signup_process.dart';
import '../services/database.dart';

class SignUpProcess{


  static late BuildContext context;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String collegeSelected = "None";
  String genderSelected = "Male";
  List<String> colleges = ["None", "Georgia Tech", "University of Florida", "Boston College", "University of Michigan", "New Jersey Institute of Technology", "Delta State University"];
  bool selectedProfilePicture = false;
  int currentQuestionIndex = 0;
  bool wrongAnswer = false;
  bool isObscure = true;

  List<Widget> signUpProcessMentorWidgets = [];
  List<Widget> signUpProcessCustomerWidgets = [];


  Widget whatAreYouLookingForWidget(Function setState){
    return Column(
      children: [
        SizedBox(
          width: screenWidth(context),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isDesktop(context)?200:screenWidth(context) / 2.5,
                height: 50,
                decoration: BoxDecoration(
                  color: isMentor?Config.secondaryColor:Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      isMentor = true;
                    });
                  },
                  child: Text("Providing Mentorship", style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop(context)?14:11,
                  ),),
                ),
              ),
              const SizedBox(width: 20,),
              Container(
                width: isDesktop(context)?200:screenWidth(context) / 2.5,
                height: 50,
                decoration: BoxDecoration(
                  color: !isMentor?Config.secondaryColor:Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      isMentor = false;
                    });
                  },
                  child: Text("Receiving Mentorship", style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop(context)?14:11,
                  ),),
                ),
              ),
            ],
          ),
        ),

        continueButton(nextQuestion, setState),

      ],
    );
  }

  Widget whatSportAreYouLookingFor(Function setState){
    return Column(
      children: [
        SizedBox(
          width: 400,
          height: 340,
          child: ListView.builder(
            itemCount: sports.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                activeColor: Config.secondaryColor,
                title: Text(sports[index]),
                value: checkedSports[index],
                onChanged: (newValue) {
                  setState(() {
                    int sportIndex = 0;
                    while(sportIndex < sports.length){
                      if(sportIndex != index){
                        checkedSports[sportIndex] = false;
                      }
                      sportIndex++;
                    }
                    checkedSports[index] = newValue!;
                    if(checkedSports[index]){
                      selectedSportIndexSignup = index;
                    }
                  });
                },
              );
            },
          ),
        ),
        continueButton(sportSelected, setState),
      ],
    );
  }

  Widget whatTypesOfServicesAreYouLookingFor(Function setState){
    return Column(
      children: [
        SizedBox(
          width: 400,
          height: 340,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                activeColor: Config.secondaryColor,
                title: Text(items[index]),
                value: checked[index],
                onChanged: (newValue) {
                  setState(() {
                    checked[index] = newValue!;
                  });
                },
              );
            },
          ),
        ),
        continueButton(serviceSelected, setState),
      ],
    );
  }

  Widget firstAndLastName(Function setState){
    return Column(
      children: [
        Container(
          margin: isDesktop(context)?const EdgeInsets.all(0):const EdgeInsets.only(left: 10,right: 10),
          width: isDesktop(context)?screenWidth(context) / 2.5:screenWidth(context),
          height: 50,
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            controller: firstNameController,
            decoration: const InputDecoration(
              hintText: "First Name",
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Container(
          margin: isDesktop(context)?const EdgeInsets.all(0):const EdgeInsets.only(left: 10,right: 10),
          width: isDesktop(context)?screenWidth(context) / 2.5:screenWidth(context),
          height: 50,
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            controller: lastNameController,
            decoration: const InputDecoration(
              hintText: "Last Name",
              border: InputBorder.none,
            ),
          ),
        ),
        continueButton(checkFirstNameOrLastNameEmpty, setState),
      ],
    );
  }

  Widget selectGender(Function setState){
    return Column(
      children: [
        DropdownButton<String>(
          value: genderSelected,
          onChanged: (String? newValue) {
            setState(() {
              genderSelected = newValue!;
            });
          },
          items: genders.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        continueButton(nextQuestion, setState),
      ],
    );
  }

  Widget inputMentorDescription(Function setState){
    return Column(
      children: [
        Container(
          width: isDesktop(context)?screenWidth(context) / 2.5:screenWidth(context),
          height: 100,
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            minLines: 4,
            maxLines: 10,
            controller: mentorDescription,
            decoration: const InputDecoration(
              hintText: "Description",
              border: InputBorder.none,
            ),
          ),
        ),
        continueButton(checkMentorDescriptionEmpty, setState),
      ],
    );
  }

  Widget selectCountry(Function setState){
    return Column(
      children: [
        SizedBox(
            width: isDesktop(context)?screenWidth(context) / 3: screenWidth(context) / 2,
            child: Center(
              child: TextButton(
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false, // optional. Shows phone code before the country name.
                    onSelect: (Country country) {
                      setState(() {
                        countryValue = country.name;
                        countryCode = country.countryCode.toLowerCase();
                      });
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 32.0,
                      child: Image.asset(
                        "flags/$countryCode.png",
                        package: 'country_code_picker',
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Text(countryValue, style: const TextStyle(
                      color: Colors.black,
                    ),), // Display custom name
                  ],
                ),
              ),
            )
        ),
        continueButton(nextQuestion, setState),
      ],
    );
  }

  Widget selectProfilePicture(Function setState){
    return Column(
      children: [
        Card(
          surfaceTintColor: Colors.white,
          child: SizedBox(
            width: isDesktop(context)?screenWidth(context) / 3: screenWidth(context),
            height: screenHeight(context) / 2,
            child: !selectedProfilePicture?Center(
              child: IconButton(
                iconSize: screenWidth(context) / 10,
                onPressed: (){
                  pickImage(profilePictureImageBytes, setState).then((result) {
                    profilePictureImageBytes = result;
                    selectedProfilePicture = true;
                    wrongAnswer = false;
                  }).catchError((error) {
                    debugPrint("Error - $error");
                  });

                },
                icon: Icon(Icons.image, color: Config.secondaryColor, size: screenWidth(context) / 10,),
              ),
            ):Image.memory(
              width: screenWidth(context) / 3,
              height: screenHeight(context) / 2,
              profilePictureImageBytes,
            ),
          ),
        ),
        SizedBox(height: profilePictureImageBytes.isNotEmpty?10:0,),
        profilePictureImageBytes.isNotEmpty?Container(
          width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context)/1.5,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: (){
              pickImage(profilePictureImageBytes, setState).then((result) {
                profilePictureImageBytes = result;
                selectedProfilePicture = true;
              }).catchError((error) {
                debugPrint("Error - $error");
              });
            },
            child: const Text("Change Picture", style: TextStyle(
              color: Colors.white,
            ),),
          ),
        ):Container(),
        continueButton(checkProfilePictureEmpty, setState),
      ],
    );
  }

  Widget selectCollege(Function setState){
    return Column(
      children: [
        DropdownButton<String>(
          value: collegeSelected,
          onChanged: (String? newValue) {
            setState(() {
              collegeSelected = newValue!;
            });
          },
          items: colleges.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        continueButton(nextQuestion, setState),
      ],
    );
  }

  Widget inputEmailAndPassword(Function setState){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: isDesktop(context)?const EdgeInsets.all(0):const EdgeInsets.only(left:20, right: 20),
            width: isDesktop(context)?screenWidth(context) / 2.5:screenWidth(context),
            height: 50,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
                border: InputBorder.none,
              ),
              validator: (email) => email != null && !EmailValidator.validate(email)?'Enter a valid email':null,
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            margin: isDesktop(context)?const EdgeInsets.all(0):const EdgeInsets.only(left:20, right: 20),
            width: isDesktop(context)?screenWidth(context) / 2.5:screenWidth(context),
            height: 50,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              controller: passwordController,
              obscureText: isObscure, // Initially obscure the text
              decoration: InputDecoration(
                hintText: "Password",
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility, // Toggle the icon based on password visibility
                    color: isObscure ? Colors.grey : Colors.green, // Change icon color based on visibility
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure; // Toggle password visibility
                    });
                  },
                ),
              ),
            ),
          ),
          signUpButton(setState),
        ],
      ),
    );
  }

  Widget signUpButton(Function setState){
    return FutureBuilder(
      future: Future.wait([isMentor?mentorAccountsData():customerAccountsData(), userAccountsData(), categoriesData(), sportsData()]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return CircularProgressIndicator(
              color: Config.mainColor,
            );
          }
          else if(snapshot.hasData){
            return Container(
              margin: const EdgeInsets.only(top: 50),
              width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context)/1.5,
              height: 50,
              decoration: BoxDecoration(
                color: Config.mainColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    handleSignUpLogic(snapshot);
                    if(profilePictureImageBytes.isEmpty){
                      selectedProfilePicture = false;
                    }
                  });
                },
                child: Text(currentQuestionIndex != 9?"Continue": "Sign up", style: const TextStyle(
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


    );
  }

  Widget continueButton(Function function, Function setState){

    return FutureBuilder(
      future: Future.wait([isMentor?mentorAccountsData():customerAccountsData(), userAccountsData(), categoriesData(), sportsData()]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return CircularProgressIndicator(
              color: Config.mainColor,
            );
          }
          else if(snapshot.hasData){
            return Container(
              margin: const EdgeInsets.only(top: 50),
              width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context)/1.5,
              height: 50,
              decoration: BoxDecoration(
                color: Config.mainColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    function();
                    if(profilePictureImageBytes.isEmpty){
                      selectedProfilePicture = false;
                    }
                  });
                },
                child: Text(currentQuestionIndex != 9?"Continue": "Sign up", style: const TextStyle(
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


    );
  }

  void whatAreYouLookingForLogic(){
    currentQuestionIndex++;
    wrongAnswer = false;
  }

  void sportSelected(){
    int sportIndex = checkedSports.indexWhere((checked) => checked);

    if (sportIndex != -1) {
      currentQuestionIndex++;
      wrongAnswer = false;
    } else {
      wrongAnswer = true;
    }
  }

  void serviceSelected(){
    int serviceIndex = checked.indexWhere((isChecked) => isChecked);

    if (serviceIndex != -1) {
      currentQuestionIndex++;
      wrongAnswer = false;
    } else {
      wrongAnswer = true;
    }

  }

  void checkFirstNameOrLastNameEmpty(){
    wrongAnswer = firstNameController.text.isEmpty || lastNameController.text.isEmpty;
    if (!wrongAnswer) {
      currentQuestionIndex++;
    }
  }

  void checkMentorDescriptionEmpty(){
    wrongAnswer = mentorDescription.text.isEmpty;

    if (!wrongAnswer) {
      currentQuestionIndex++;
    }
  }

  void checkProfilePictureEmpty(){
    wrongAnswer = profilePictureImageBytes.isEmpty;

    if (!wrongAnswer) {
      currentQuestionIndex++;
    }
  }

  void nextQuestion(){
    currentQuestionIndex++;
    wrongAnswer = false;
  }

  bool validateForm() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return false;
    }
    return _formKey.currentState!.validate();
  }

  Future<void> handleSignUp(AsyncSnapshot<dynamic> snapshot) async {
    await signUp(context, emailController, passwordController);
    if (signedUp) {
      await postSignUpTasks(snapshot);
    } else {
      wrongAnswer = true;
    }
  }

  Future<void> postSignUpTasks(AsyncSnapshot<dynamic> snapshot) async {
    isLoggedIn = true;
    List<String> services = [];
    int userIndex = snapshot.data[0]['user-amount'];

    if (isMentor) {
      await handleMentorSignUp(snapshot, userIndex, services);
    } else {
      await Database().addCustomer(userIndex,"" ,currentUserName, emailController.text, [sports[selectedSportIndexSignup]], services, genderSelected);
    }

    await Database().addUser(userIndex,currentUserName ,emailController.text, isMentor ? "mentor" : "customer", genderSelected);

    if (!context.mounted) return;
    isMentor ? Navigator.popAndPushNamed(context, '/mentor-home') : Navigator.popAndPushNamed(context, '/customer-home');
  }

  Future<void> handleMentorSignUp(AsyncSnapshot<dynamic> snapshot, int userIndex, List<String> services) async {
    await handleSelectedServices(snapshot, userIndex, services);
    currentUserName = "${firstNameController.text.trim()} ${lastNameController.text.trim()}";

    await Database().addMentor(userIndex, currentUserName, emailController.text, [sports[selectedSportIndexSignup]], services, countryCode, collegeSelected, mentorDescription.text, genderSelected);
    await uploadFileWeb(userIndex, profilePictureImageBytes);

    await updateSportMentors(snapshot, userIndex);
  }

  Future<void> handleSelectedServices(AsyncSnapshot<dynamic> snapshot, int userIndex, List<String> services) async {
    for (int serviceIndex = 0; serviceIndex < checked.length; serviceIndex++) {
      if (checked[serviceIndex]) {
        services.add(items[serviceIndex]);
        await updateCategoryMentors(snapshot, serviceIndex, userIndex);
      }
    }
  }

  Future<void> updateCategoryMentors(AsyncSnapshot<dynamic> snapshot, int serviceIndex, int userIndex) async {
    for (int categoryIndex = 0; categoryIndex < snapshot.data[2]['category-amount']; categoryIndex++) {
      if (snapshot.data[2]['$categoryIndex']['category-name'] == items[serviceIndex]) {
        List<dynamic> mentors = snapshot.data[2]['$categoryIndex']['mentors'];
        mentors.add(userIndex);
        await Database().updateCategoryMentors(categoryIndex, mentors);
      }
    }
  }

  Future<void> updateSportMentors(AsyncSnapshot<dynamic> snapshot, int userIndex) async {
    for (int sportIndex = 0; sportIndex < snapshot.data[3]['sports-amount']; sportIndex++) {
      if (snapshot.data[3]['$sportIndex']['sport-name'] == sports[selectedSportIndexSignup]) {
        List<dynamic> mentors = snapshot.data[3]['$sportIndex']['mentors'];
        mentors.add(userIndex);
        await Database().updateSportMentors(sportIndex, mentors);
        break;
      }
    }
  }

  void handleSignUpLogic(AsyncSnapshot<dynamic> snapshot) async {
    if(emailController.text.isEmpty || passwordController.text.isEmpty){
      wrongAnswer = true;
    }
    else{

      if (_formKey.currentState!.validate()) {
        // Validation passed, do something
        wrongAnswer = false;
        await signUp(context, emailController, passwordController);
        if(signedUp){
          isLoggedIn = true;
          List<String> services = [];
          int serviceIndex = 0;
          int userIndex = snapshot.data[0]['user-amount'];

          // Loop over all mentorship services
          if(isMentor){
            while(serviceIndex < checked.length){
              // If current service was selected by the user
              if(checked[serviceIndex]){
                // Add mentorship services selected to a list
                services.add(items[serviceIndex]);
                int categoryIndex = 0;
                while(categoryIndex < snapshot.data[2]['category-amount']){
                  if(snapshot.data[2]['$categoryIndex']['category-name'] == items[serviceIndex]){
                    List<dynamic> mentors = snapshot.data[2]['$categoryIndex']['mentors'];
                    mentors.add(userIndex);
                    await Database().updateCategoryMentors(categoryIndex, mentors);
                  }
                  categoryIndex++;
                }
              }
              serviceIndex++;
            }
          }

          currentUserName = "${firstNameController.text.trim()} ${lastNameController.text.trim()}";

          if(isMentor){
            await Database().addMentor(userIndex, currentUserName, emailController.text,[sports[selectedSportIndexSignup]], services, countryCode, collegeSelected, mentorDescription.text, genderSelected);
            await uploadFileWeb(userIndex, profilePictureImageBytes);

            int sportIndex = 0;
            while(sportIndex < snapshot.data[3]['sports-amount']){
              if(snapshot.data[3]['$sportIndex']['sport-name'] == sports[selectedSportIndexSignup]){
                List<dynamic> mentors = snapshot.data[3]['$sportIndex']['mentors'];
                mentors.add(userIndex);
                await Database().updateSportMentors(sportIndex, mentors);
                break;
              }
              sportIndex++;
            }
          }
          else{
            await Database().addCustomer(userIndex,"", currentUserName, emailController.text,[sports[selectedSportIndexSignup]], services, genderSelected);
          }

          await Database().addUser(userIndex,currentUserName,emailController.text, isMentor?"mentor":"customer", genderSelected);
          if (!context.mounted) return;
          isMentor?Navigator.popAndPushNamed(context, '/mentor-home'):Navigator.popAndPushNamed(context, '/customer-home');

        }
      }
      else {
        // Validation failed
        wrongAnswer = true;
      }
    }
  }

}