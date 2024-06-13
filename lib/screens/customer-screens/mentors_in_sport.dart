import 'dart:typed_data';
import 'package:athlete_factory/functions/dimensions.dart';
import 'package:athlete_factory/models/sport.dart';
import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:athlete_factory/services/database.dart';
import 'package:athlete_factory/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../colors/main-colors.dart';
import '../../config.dart';
import '../../functions/check_user_type.dart';
import '../../functions/image_functions.dart';
import '../../functions/platform-type.dart';
import '../../widgets/customer-widgets/drawer-customer.dart';
import '../../widgets/customer-widgets/mobile-top-bar.dart';
import '../../widgets/customer-widgets/top-bar-customer.dart';
import '../../widgets/image_container.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';

class MentorsInSport extends StatefulWidget {
  const MentorsInSport({Key? key}) : super(key: key);

  @override
  State<MentorsInSport> createState() => _MentorsInSportState();
}

class _MentorsInSportState extends State<MentorsInSport> {

  List<Uint8List> mentorImagesBytes = [];
  List<String> searchedMentorNames = [];
  TextEditingController searchController = TextEditingController();
  bool isInitial = true;
  bool mentorImagesRendered = false;
  dynamic receivedList;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        userType = "";
        currentSignedOutPage = "Home";
        Navigator.popAndPushNamed(context, "/");
      } else {
        isLoggedIn = true;
        userType = "customer";
        UserClass.type = "customer";
        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;
        isInitial = true;
        initializeUser();
      }
    });

    searchedMentorNames = Sport.getNames();

    mentorImagesBytes = [];
    int actualIndex = 0;
    int mentorImageIndex = 0;

    while(mentorImageIndex < Sport.mentors.length){
      Uint8List currentMentorImageBytes = Uint8List(0);
      mentorImagesBytes.add(currentMentorImageBytes);
      getDataMap(mentorImageIndex, currentMentorImageBytes, "Mentors/mentor_${Sport.mentors[mentorImageIndex].index}/picture_0.jpg", '', setState).
      then((result) {
        mentorImagesBytes[result['imageIndex']] = result['imageBytes'];
        actualIndex++;
        if(actualIndex == Sport.mentors.length){
          mentorImagesRendered = true;
        }

      }).catchError((error) {
        debugPrint("Error - $error");
      });

      mentorImageIndex++;
    }
  }

  CustomerUser customer = CustomerUser(currentUserEmail);
  Future<void> initializeUser() async {
    await customer.setInfo();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            if(mentorImagesRendered){
              currentCustomerPage = "Home";
              Navigator.popAndPushNamed(context, '/customer-home');
            }
          },
        ),
        title: isDesktop(context)?topBarCustomer(context):mobileTopBar(),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: IntrinsicHeight(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          width: screenWidth(context),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              searchTextField(searchController, searchName),
              const SizedBox(height: 30,),
              SizedBox(
                width: screenWidth(context),
                height: screenHeight(context) - 150 - AppBar().preferredSize.height,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    itemCount: Sport.mentors.length,
                    itemBuilder: (context,index){
                      return searchedMentorNames.contains(Sport.mentors[index].name)?Container(
                        width: screenWidth(context),
                        height: isDesktop(context)?200:150,
                        margin: const EdgeInsets.only(bottom: 30, right: 30),
                        child: TextButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Center(
                                  child: CircularProgressIndicator(
                                    color: Config.secondaryColor,
                                  ),
                                )
                            );

                            UserClass.refresh = false;

                            customer.setSelectedMentor(Sport.mentors[index].index);
                            await Database().updateSelectedMentor(customer.getEmail(), customer.getSelectedMentor());

                            if (!context.mounted) return;
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.pushNamed(context, '/booking-screen');

                          },
                          child: isDesktop(context)?desktopView(index):mobileView(index),
                        ),
                      ):Container();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchName(String query){
    final suggestions = Sport.getNames().where((name) {
      final mentorName = name.toLowerCase();
      final input = query.toLowerCase();

      return mentorName.contains(input);

    }).toList();

    setState(() {
      searchedMentorNames = suggestions;
    });

  }
  
  Widget desktopView(int index){
    return Row(
      children: [
        mentorImagesRendered && mentorImagesBytes[index].isNotEmpty?imageContainer(mentorImagesBytes[index], isDesktop(context)?200:100, isDesktop(context)?150:100, 20):
        SizedBox(
          width: isDesktop(context)?200:100,
          height: isDesktop(context)?150:100,
          child: const Icon(
            Icons.person,
            size: 50,
            color: Colors.grey,
          ),
        ),//
        const SizedBox(width: 20,),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    mentorTitle(index),
                    const SizedBox(width: 30,),
                    mentorServices(index),
                  ],
                ),
              ),
              mentorDescription(index),
            ],
          ),
        ),
        Expanded(child: Container()),
        flag(index),
      ],
    );
  }
  
  Widget mentorServices(int index){
    return SizedBox(
      width: screenWidth(context) / 2.5,
      height: 30,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const ScrollPhysics(),
          itemCount: Sport.mentors[index].services.length,
          itemBuilder: (context,serviceIndex){
            return Card(
              elevation: 4,
              surfaceTintColor: Colors.white,
              color: Colors.grey[100],
              child: IntrinsicWidth(
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Center(child: Text('${Sport.mentors[index].services[serviceIndex]}',),
                  ),
                ),
              ),
            );
          }),
    );
  }
  
  Widget nameAndCollege(int index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Sport.mentors[index].name,
          style: TextStyle(
            fontSize: isDesktop(context)?18:15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(Sport.mentors[index].college,
          style: TextStyle(
            fontSize: isDesktop(context)?16:14,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  
  Widget flag(int index){
    return SizedBox(
      width: 32.0,
      child: Image.asset(
        'flags/${Sport.mentors[index].country}.png',
        package: 'country_code_picker',
      ),
    );
  }
  
  Widget mentorTitle(int index){
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Sport.mentors[index].college != "None"?nameAndCollege(index):
          Text(Sport.mentors[index].name, style: TextStyle(fontSize: isDesktop(context)?18:15, fontWeight: FontWeight.bold, color: Colors.black,),),
          const SizedBox(width: 30,),
          flag(index),
        ],
      ),
    );
  }
  
  Widget mentorDescription(int index){
    return SizedBox(
      width: isDesktop(context) ? screenWidth(context) / 1.5 : screenWidth(context) / 2,
      height: isDesktop(context)?90:75,
      child: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Text(
          Sport.mentors[index].description,
          style: TextStyle(
            fontSize: isDesktop(context)?14:12,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
  
  Widget mobileView(int index){
    return Row(
      children: [
        mentorImagesRendered && mentorImagesBytes[index].isNotEmpty?imageContainer(mentorImagesBytes[index], isDesktop(context)?200:100, isDesktop(context)?150:100, 20):Container(
          width: isDesktop(context)?200:100,
          height: isDesktop(context)?150:100,
          child: Icon(
            Icons.person,
            size: 50,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 20,),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mentorTitle(index),
              mentorDescription(index),
            ],
          ),
        ),
      ],
    );
  }
  
  
}
