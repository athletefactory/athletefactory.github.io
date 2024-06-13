import 'package:athlete_factory/colors/main-colors.dart';
import 'package:athlete_factory/functions/dimensions.dart';
import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:athlete_factory/services/database.dart';
import 'package:athlete_factory/services/google_authentication.dart';
import 'package:athlete_factory/widgets/customer-widgets/top-bar-customer.dart';
import 'package:athlete_factory/widgets/textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';
import '../../functions/platform-type.dart';
import '../../widgets/signed-out-widgets/drawer-signed-out.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out-mobile.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';



class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool wrongPassword = false;
  bool userNotFound = false;
  bool showWrongEmailOrPassword = false;
  bool isObscure = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    gotUserType = true;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              SizedBox(
                width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("athlete", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
                        Text("factory", style: TextStyle(color: Config.secondaryColor, fontSize: 30, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child:  Image.asset('assets/images/signincharactertransparent.png', width: 150, height: 150,),
                    ),
                    textField(context, "Email", emailController),
                    passwordTextField(context, "Password", passwordController, setState),
                    forgotPasswordButton(),
                    signInButton(),
                    const SizedBox(height: 30,),
                    goToSignup(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn(AsyncSnapshot<dynamic> snapshot) async {

    wrongPassword = false;
    userNotFound = false;
    bool credentialsFound = true;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: Config.secondaryColor,
          ),
        )
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.toLowerCase().trim(),
        password: passwordController.text.trim(),
      );
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    }
    on FirebaseAuthException catch (e) {
      credentialsFound = false;
      if (e.code == 'user-not-found') {
        userNotFound = true;
      } else if (e.code == 'wrong-password') {
        wrongPassword = true;
      }
    }

    if(credentialsFound){
      currentUserEmail = emailController.text.toLowerCase().trim();
      currentCustomerPage = "Home";
      isLoggedIn = true;
      if(isEmailVerified){
        await Database().updateVerified(emailController.text.toLowerCase().trim());
      }
      if(snapshot.data[0][currentUserEmail]['user-type'] == "customer"){
        UserClass.type = "customer";
        userType = "customer";
        CustomerUser customer = CustomerUser(currentUserEmail);
        customer.setIndex(snapshot.data[0][currentUserEmail]['user-index']);
        if (!context.mounted) return;
        Navigator.popAndPushNamed(context, '/customer-home');
      }
      else{
        UserClass.type = "mentor";
        userType = "mentor";

        MentorUser mentor = MentorUser(currentUserEmail);
        mentor.setIndex(snapshot.data[0][currentUserEmail]['user-index']);

        if (!context.mounted) return;
        Navigator.popAndPushNamed(context, '/mentor-home');
      }
    }
    else{
      isLoggedIn = false;
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        showWrongEmailOrPassword = true;
      });
    }
  }

  Widget signInWithGoogleButton(){
    return Center(
      child: Container(
        margin: isDesktop(context)?const EdgeInsets.all(0):const EdgeInsets.only(left:30, right: 30),
        width: isDesktop(context)?screenWidth(context) / 3.5:screenWidth(context),
        height: 50, // Adjust height here
        child: TextButton(
          onPressed: () async {
            //FirebaseAuthService authService = FirebaseAuthService(firebaseAuth: FirebaseAuth.instance, googleSignIn: GoogleSignIn());
            //User? user = await authService.signInWithGoogle();
            //signWebInWithGoogle();

            final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
            provider.googleLogin();

          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            alignment: Alignment.center,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Adjust border radius here
              ),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.google, color:  Colors.white,),
              SizedBox(width: 20,),
              Text(
                'Sign in with Google',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordButton(){
    return Container(
      margin: !isDesktop(context)?const EdgeInsets.only(left: 30, right: 30):const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          showWrongEmailOrPassword?const Text("Wrong email or password", style: TextStyle(color: Colors.red),):Container(),
          SizedBox(
            child: TextButton(
              onPressed: (){
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: const Text("Forgot password", style: TextStyle(color: Colors.black,fontSize: 14, fontWeight: FontWeight.bold,),textAlign: TextAlign.right,),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInButton(){
    return FutureBuilder(
      future: Future.wait([userAccountsData(), customerAccountsData(), mentorAccountsData()]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return  CircularProgressIndicator(
              color: Config.secondaryColor,
            );
          }
          else if(snapshot.hasData){
            return Center(
              child: Container(
                margin: isDesktop(context)?const EdgeInsets.all(0):const EdgeInsets.only(left:30, right: 30),
                width: isDesktop(context)?screenWidth(context) / 3.5:screenWidth(context),
                height: 50, // Adjust height here
                child: TextButton(
                  onPressed: () async {
                    await signIn(snapshot);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Config.buttonColor),
                    alignment: Alignment.center,
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Adjust border radius here
                      ),
                    ),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return  CircularProgressIndicator(
          color: Config.secondaryColor,
        );
      },

    );
  }

  Widget goToSignup(){
    return SizedBox(
      width: isDesktop(context)?screenWidth(context) / 3.5:screenWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account?", style: TextStyle(color: Colors.black,fontSize: 16,),),
          TextButton(
            onPressed: (){
              Navigator.popAndPushNamed(context, '/sign-up-process');
            },
            child:  Text(" Sign up now!", style: TextStyle(color: Config.secondaryColor,fontSize: 16, fontWeight: FontWeight.bold,),),
          ),
        ],
      ),
    );
  }

}
