import 'package:athlete_factory/functions/dimensions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config.dart';
import '../../functions/authentication_functions.dart';
import '../../functions/image_functions.dart';
import '../../functions/platform-type.dart';
import '../../services/database.dart';
import '../../widgets/signed-out-widgets/drawer-signed-out.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out-mobile.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';
import 'package:country_picker/country_picker.dart';

bool isLoggedIn = false;
bool isMentor = false;
bool isParent = true;

String currentUserName = "";
String countryValue = "United States";
String countryCode = "us";

int selectedSportIndexSignup = 0;
Uint8List profilePictureImageBytes = Uint8List(0);

// List to keep track of checked items
List<bool> checked = [false, false, false, false, false, false, false, false, false];

// List of items for the checklist
List<String> items = ['Performance Mentorship', 'Sports Psychology', 'Nutrition', 'School & Training Balance', "Training & Video Feedback", "Technique & Skill Analysis", "Post & Pre Competition or Game Debrief", "Athletic Career Guidance", "College Recruiting"];
List<String> sports = ["Swimming", 'American Football' , "Combat Sports", "Soccer", "Rugby", "Basketball",  'Baseball', 'Softball', 'Golf', 'Volleyball', 'Tennis','Cross Country', 'Track & Field', 'Fencing'];
List<bool> checkedSports = [false, false, false, false, false, false,false, false, false, false, false, false, false,false];
List<String> genders = ['Male', 'Female'];

TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController parentFirstNameController = TextEditingController();
TextEditingController parentLastNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController mentorDescription = TextEditingController();


class SignupProcess extends StatefulWidget {
  const SignupProcess({Key? key}) : super(key: key);

  @override
  State<SignupProcess> createState() => _SignupProcessState();
}

class _SignupProcessState extends State<SignupProcess> {

  bool invalidEmail = false;
  bool invalidPassword = false;


  List<String> questionsCustomer = [
    "What are you looking for?",
    "Are you the parent of the athlete?",
    "What sport are you looking for?",
    "What type of service/s are you looking for?",
    "Please enter your first and last name",
    "Please enter your gender",
    "Please enter your email and password",
  ];

  List<String> questionsParent = [
    "What are you looking for?",
    "Are you the parent of the athlete?",
    "What sport are you looking for?",
    "What type of service/s are you looking for?",
    "Please enter your first and last name",
    "Please enter your athlete's first and last name",
    "Please enter your athlete's gender",
    "Please enter your email and password",
  ];


  List<String> questionsMentor = [
    "What are you looking for?",
    "What sport are you looking to mentor in?",
    "What type of service/s do you specialize in?",
    "Please enter your first and last name",
    "Please enter your gender",
    "Please give a brief description about yourself",
    "Please enter your nationality",
    "Please upload your profile picture",
    "If you are a college student, please specify your college",
    "Please enter your email and password",
  ];


  int currentQuestionIndex = 0;
  bool wrongAnswer = false;
  bool isObscure = true;

  List<Widget> signUpProcessMentorWidgets = [];
  List<Widget> signUpProcessCustomerWidgets = [];
  List<Widget> signUpProcessParentWidgets = [];

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    mentorDescription = TextEditingController();
    isMentor = false;
    checked = List.generate(9, (index) => false);
    checkedSports = List.generate(14, (index) => false);
    profilePictureImageBytes = Uint8List(0);
    currentSignedOutPage = "Register";
  }

  String collegeSelected = "None";
  String genderSelected = "Male";
  List<String> colleges = ["None", "University of Alabama","Arizona State University","Auburn University","Boston College","Brigham Young University","Brown University","Clemson University","Cornell University","Delta State University","Duke University","Florida State University","Georgetown University","Georgia State University","Georgia Tech","Harvard University","Hofstra University","Indiana University","Louisiana State University","Louisville University","Loyola Marymount University","Marshall University","University of Minnesota","Mississippi State University","Missouri State University","NC State University","New Jersey Institute of Technology","University of Notre Dame","Ohio State University","University of Oklahoma","Ole Miss","Oregon State University","University of Portland","Princeton University","Southern Methodist University","Stanford","University of Tennessee","Texas A&M University","Texas Christian University","Texas Tech University","Tufts University","University of Oregon","University of California, Berkeley","UCLA","University of Central Florida","University of Florida","University of Houston","University of Iowa","University of Kentucky","University of Michigan","University of New Hampshire","University of North Carolina","University of Southern California","University of South Carolina","University of South Florida","University of Texas","University of Virginia","University of Wisconsin","University of Georgia","Virginia Tech","Wake Forest University","West Virginia University","Western Michigan University","Yale University"];
  bool selectedProfilePicture = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    signUpProcessMentorWidgets = [
      whatAreYouLookingForWidget(),
      whatSportAreYouLookingFor(),
      whatTypesOfServicesAreYouLookingFor(),
      firstAndLastName(false),
      selectGender(),
      inputMentorDescription(),
      selectCountry(),
      selectProfilePicture(),
      selectCollege(),
      inputEmailAndPassword(),
    ];
    signUpProcessCustomerWidgets = [
      whatAreYouLookingForWidget(),
      customerType(),
      whatSportAreYouLookingFor(),
      whatTypesOfServicesAreYouLookingFor(),
      firstAndLastName(false),
      selectGender(),
      inputEmailAndPassword(),
    ];

    signUpProcessParentWidgets = [
      whatAreYouLookingForWidget(),
      customerType(),
      whatSportAreYouLookingFor(),
      whatTypesOfServicesAreYouLookingFor(),
      firstAndLastName(true),
      firstAndLastName(false),
      selectGender(),
      inputEmailAndPassword(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isDesktop(context)?false:true,
        title: isDesktop(context)?topBarSignedOut(context):topBarSignedOutMobile(),
        //Colors.lightBlue[50]
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: isMobile(context)?drawerSignedOutWidget(context, scaffoldKey):Container(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Center(
          child: Container(
            width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context),
            margin: const EdgeInsets.only(left: 20,right: 20),
            child: IntrinsicHeight(
              child: ConstrainedBox(
                constraints: BoxConstraints(

                  minHeight: screenHeight(context), // Set your minimum height here
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(isMentor?signUpProcessMentorWidgets.length:isParent?signUpProcessParentWidgets.length:signUpProcessCustomerWidgets.length, (index) {
                        return Icon(
                          Icons.circle,
                          size: 20,
                          color: currentQuestionIndex == index ? Config.secondaryColor : Colors.black,
                        );
                      }),
                    ),
                    const SizedBox(height: 40,),
                    // QUESTION TEXT
                    Text(isMentor?questionsMentor[currentQuestionIndex]:isParent?questionsParent[currentQuestionIndex]:questionsCustomer[currentQuestionIndex], style: TextStyle(fontSize: isDesktop(context)?20:18,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                    isMentor && currentQuestionIndex == 2?Container(
                      width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context),
                      margin: EdgeInsets.only(top: 20,bottom: 0),
                        child: ListTile(
                          title: Text("Select all that apply",style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),),
                        ),
                    ):Container(),
                    SizedBox(height: isMentor && currentQuestionIndex == 2?10:30,),
                    isMentor?signUpProcessMentorWidgets[currentQuestionIndex]:
                    isParent?signUpProcessParentWidgets[currentQuestionIndex]:
                    signUpProcessCustomerWidgets[currentQuestionIndex],
                    wrongAnswer?const SizedBox(height: 10,):Container(),
                    wrongAnswer?const Text("Please enter a valid entry", style: TextStyle(color: Colors.red,fontSize: 16),):Container(),
                    invalidPassword?const SizedBox(height: 10,):Container(),
                    invalidPassword?const Text("Password must be at least 4 characters long", style: TextStyle(color: Colors.red,fontSize: 16),):Container(),
                    invalidEmail?const SizedBox(height: 10,):Container(),
                    invalidEmail?const Text("Enter a valid email", style: TextStyle(color: Colors.red,fontSize: 16),):Container(),
                    const SizedBox(height: 20,),
                    currentQuestionIndex != 0?Container(
                      alignment: Alignment.centerLeft,
                      width: 150,
                      child: ListTile(
                        leading: const Icon(Icons.arrow_back),
                        onTap: (){
                          setState(() {
                            if(isMentor){
                              if(profilePictureImageBytes.isEmpty){
                                selectedProfilePicture = false;
                              }
                            }
                            currentQuestionIndex--;
                            wrongAnswer = false;
                            invalidEmail = false;
                            invalidPassword = false;
                          });
                        },
                        title: Text("Previous", style: TextStyle(fontSize: isDesktop(context)?16:14),),
                      ),
                    ):Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget whatAreYouLookingForWidget(){
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

        continueButton(nextQuestion),

      ],
    );
  }

  Widget customerType(){
    return Column(
      children: [
        SizedBox(
          width: screenWidth(context),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isDesktop(context)?150:screenWidth(context) / 3,
                height: 50,
                decoration: BoxDecoration(
                  color: isParent?Config.secondaryColor:Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      isParent = true;
                    });
                  },
                  child: Text("Yes", style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop(context)?14:11,
                  ),),
                ),
              ),
              const SizedBox(width: 20,),
              Container(
                width: isDesktop(context)?150:screenWidth(context) / 3,
                height: 50,
                decoration: BoxDecoration(
                  color: !isParent?Config.secondaryColor:Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      isParent = false;
                    });
                  },
                  child: Text("No", style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop(context)?14:11,
                  ),),
                ),
              ),
            ],
          ),
        ),

        continueButton(nextQuestion),

      ],
    );
  }

  Widget whatSportAreYouLookingFor(){
    return Column(
      children: [
        SizedBox(
          width: isDesktop(context)? screenWidth(context) / 3: screenWidth(context),
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
        continueButton(sportSelected),
      ],
    );
  }

  Widget whatTypesOfServicesAreYouLookingFor(){
    return Column(
      children: [
        SizedBox(
          width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context),
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
        continueButton(serviceSelected),
      ],
    );
  }

  Widget firstAndLastName(bool forParent){
    return Column(
      children: [
        textFieldSignUp(context, "First Name", forParent?parentFirstNameController:firstNameController),
        textFieldSignUp(context, "Last Name", forParent?parentLastNameController:lastNameController),
        continueButton(forParent?checkParentFirstNameOrLastNameEmpty:checkFirstNameOrLastNameEmpty),
      ],
    );
  }

  Widget textFieldSignUp(BuildContext context, String hintText, TextEditingController controller){
    return Container(
      width: screenWidth(context),
      height: 50,
      margin: EdgeInsets.only(top: 20,bottom: 0, left: 0, right: 0),
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

  Widget passwordTextFieldSignUp(BuildContext context, String hintText, TextEditingController controller, Function setState){
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

  Widget emailTextFieldSignUp(BuildContext context, String hintText, TextEditingController controller){
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
          validator: (email) {
            if(email != null && !EmailValidator.validate(email)){
              setState(() {
                invalidEmail = true;
              });
            }
            else{
              setState(() {
                invalidEmail = false;
              });
            }
            return null;
          } ,
        ),
      ),
    );
  }

  Widget selectGender(){
    return Column(
      children: [

        SizedBox(
          width: screenWidth(context),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isDesktop(context)?150:screenWidth(context) / 3,
                height: 50,
                decoration: BoxDecoration(
                  color: genderSelected == "Male"?Config.secondaryColor:Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      genderSelected = "Male";
                    });
                  },
                  child: Text("Male", style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop(context)?14:11,
                  ),),
                ),
              ),
              const SizedBox(width: 20,),
              Container(
                width: isDesktop(context)?150:screenWidth(context) / 3,
                height: 50,
                decoration: BoxDecoration(
                  color: genderSelected == "Female"?Config.secondaryColor:Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      genderSelected = "Female";
                    });
                  },
                  child: Text("Female", style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop(context)?14:11,
                  ),),
                ),
              ),
            ],
          ),
        ),
        continueButton(nextQuestion),
      ],
    );
  }

  Widget inputMentorDescription(){
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
        continueButton(checkMentorDescriptionEmpty),
      ],
    );
  }

  Widget selectCountry(){
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
        continueButton(nextQuestion),
      ],
    );
  }

  Widget selectProfilePicture(){
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
            color: Colors.grey,
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
        continueButton(checkProfilePictureEmpty),
      ],
    );
  }

  Widget selectCollege(){
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
        continueButton(nextQuestion),
      ],
    );
  }

  Widget inputEmailAndPassword(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          emailTextFieldSignUp(context, "Email", emailController),
          passwordTextFieldSignUp(context, "Password", passwordController, setState),
          signUpButton(),
        ],
      ),
    );
  }

  Widget signUpButton(){
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
              margin: const EdgeInsets.only(top: 30),
              width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context)/1.5,
              height: 50,
              decoration: BoxDecoration(
                color: Config.secondaryColor,
                borderRadius: BorderRadius.circular(30),
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
                child: Text("Sign up", style: const TextStyle(
                  color: Colors.white,
                ),),
              ),
            );
          }
        }
        return loadingButton(true);
      },


    );
  }

  Widget loadingButton(bool signUp){
    return Container(
      margin: const EdgeInsets.only(top: 50),
      width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context)/1.5,
      height: 50,
      decoration: BoxDecoration(
        color: signUp?Config.secondaryColor:Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget continueButton(Function function){
    return Container(
      margin: const EdgeInsets.only(top: 40),
      width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
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
        child: Text("Continue", style: const TextStyle(
          color: Colors.white,
        ),),
      ),
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

  void checkParentFirstNameOrLastNameEmpty(){
    wrongAnswer = parentFirstNameController.text.isEmpty || parentLastNameController.text.isEmpty;
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

  void handleSignUpLogic(AsyncSnapshot<dynamic> snapshot) async {
    if(emailController.text.isEmpty){
      print("invalid email");
      invalidEmail = true;
      invalidPassword = false;
    }
    else if(passwordController.text.isEmpty || passwordController.text.length < 4){
      print("invalid password");
      invalidPassword = true;
      if(_formKey.currentState!.validate()){
        print("invalid email");
        invalidEmail = false;
      }
    }
    else{
      print("valid");
      invalidPassword = false;
      if (_formKey.currentState!.validate() && !invalidEmail && !invalidPassword) {
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
          String parentName = "${parentFirstNameController.text.trim()} ${parentLastNameController.text.trim()}";

          if(parentName == ' '){
            parentName = "";
          }

          if(isMentor){
            await Database().addMentor(userIndex, currentUserName, emailController.text.toLowerCase(),[sports[selectedSportIndexSignup]], services, countryCode, collegeSelected, mentorDescription.text, genderSelected);
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
            await Database().addCustomer(userIndex, parentName, currentUserName, emailController.text.toLowerCase(),[sports[selectedSportIndexSignup]], services, genderSelected);
          }

          await Database().addUser(userIndex,parentFirstNameController.text.trim() != ""?parentName:currentUserName,emailController.text.toLowerCase(), isMentor?"mentor":"customer", genderSelected);
          if (!context.mounted) return;
          isMentor?Navigator.popAndPushNamed(context, '/mentor-home'):Navigator.popAndPushNamed(context, '/customer-home');

        }
      }
    }
  }



}