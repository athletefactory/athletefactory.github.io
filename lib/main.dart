import 'package:athlete_factory/functions/check_user_type.dart';
import 'package:athlete_factory/screens/customer-screens/about-customer.dart';
import 'package:athlete_factory/screens/customer-screens/make-request.dart';
import 'package:athlete_factory/screens/customer-screens/payment-complete.dart';
import 'package:athlete_factory/screens/mentor-screens/about-mentor.dart';
import 'package:athlete_factory/screens/mentor-screens/contact-mentor.dart';
import 'package:athlete_factory/screens/signed-out-screens/about.dart';
import 'package:athlete_factory/screens/signed-out-screens/contact.dart';
import 'package:athlete_factory/screens/customer-screens/booking_screen.dart';
import 'package:athlete_factory/screens/customer-screens/contact-customer.dart';
import 'package:athlete_factory/screens/customer-screens/customer-profile.dart';
import 'package:athlete_factory/screens/customer-screens/customer_bookings.dart';
import 'package:athlete_factory/screens/customer-screens/customer_home.dart';
import 'package:athlete_factory/screens/customer-screens/mentors_in_sport.dart';
import 'package:athlete_factory/screens/signed-out-screens/forgot-password.dart';
import 'package:athlete_factory/screens/signed-out-screens/home.dart';
import 'package:athlete_factory/screens/mentor-screens/edit_day.dart';
import 'package:athlete_factory/screens/mentor-screens/mentor_home.dart';
import 'package:athlete_factory/screens/mentor-screens/mentor_profile.dart';
import 'package:athlete_factory/screens/customer-screens/mentors_in_category.dart';
import 'package:athlete_factory/screens/signed-out-screens/services.dart';
import 'package:athlete_factory/screens/signed-out-screens/sign_in.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:athlete_factory/services/google_authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config.dart';

bool isTesting = false;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: !isTesting?"AIzaSyCAMCYAW-a37ybosU3RRMIhJdr8p1yuuxo":"AIzaSyDOr6WyRttYdFH9OGRTLLboOHnCWdJfYtg",
        authDomain: !isTesting?"athlete-factory-15e30.firebaseapp.com":"athletefactory-c575a.firebaseapp.com",
        projectId: !isTesting?"athlete-factory-15e30":"athletefactory-c575a",
        storageBucket: !isTesting?"athlete-factory-15e30.appspot.com":"athletefactory-c575a.appspot.com",
        messagingSenderId: !isTesting?"290442250273":"353598207449",
        appId: !isTesting?"1:290442250273:web:11f1ae395cfbe90664bb60":"1:353598207449:web:2edfcac34aaa66b31455c8"
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Athlete Factory',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Config.secondaryColor),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Home(),
          '/sign-up-process':(context) => const SignupProcess(),
          '/verify-email':(context) => const VerifyEmail(),
          '/sign-in':(context) => const SignIn(),
          '/forgot-password':(context) => const ForgotPassword(),
          '/about': (context) => const About(),
          '/about-customer':(context) => const AboutCustomer(),
          '/about-mentor':(context) => const AboutMentor(),
          '/services':(context) => const Services(),
          '/contact':(context) => const Contact(),
          '/contact-customer':(context) => const ContactCustomer(),
          '/contact-mentor':(context) => const ContactMentor(),
          '/mentors-in-sport':(context) => const MentorsInSport(),
          '/mentors-in-category':(context) => const MentorsInCategory(),
          '/mentor-profile':(context) => const MentorProfile(),
          '/customer-profile':(context) => const CustomerProfile(),
          '/booking-screen':(context) => BookingScreen(),
          '/customer-bookings':(context)=> const CustomerBookings(),
          '/customer-home':(context) => const CustomerHome(),
          '/mentor-home':(context) => const MentorHome(),
          '/edit-day':(context) => const EditDay(),
          '/payment-complete':(context) => const PaymentComplete(),
          '/make-request':(context) => const MakeRequest(),
        },
      ),
    );
  }
}
