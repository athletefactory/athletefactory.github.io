import 'dart:typed_data';
import 'package:athlete_factory/functions/check_user_type.dart';
import 'package:athlete_factory/functions/dimensions.dart';
import 'package:athlete_factory/models/mentor.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:athlete_factory/services/database.dart';
import 'package:athlete_factory/widgets/image_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import '../../functions/image_functions.dart';
import '../../functions/platform-type.dart';
import '../../functions/timing_functions.dart';
import '../../models/user.dart';
import '../../widgets/mentor-widgets/drawer-mentor.dart';
import '../../widgets/mentor-widgets/mobile-top-bar-mentor.dart';
import '../../widgets/mentor-widgets/top-bar-mentor.dart';
import '../../widgets/signed-out-widgets/top-bar-signed-out.dart';
import 'edit_day.dart';

class MentorProfile extends StatefulWidget {
  const MentorProfile({Key? key}) : super(key: key);

  @override
  State<MentorProfile> createState() => _MentorProfileState();
}

class _MentorProfileState extends State<MentorProfile> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> weekDays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];

  bool initialSetup = true;
  bool initialServices = true;
  bool viewWeekDayTimings = false;
  bool editServices = false;
  String sportName = '';
  String userName = '';
  String descriptionText = '';

  List<dynamic> mentorshipServices = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool initialProfilePicLoad = true;
  Uint8List profilePictureBytes = Uint8List(0);

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        UserClass.loggedIn = false;
        UserClass.type = "";
        currentSignedOutPage = "Home";
        Navigator.popAndPushNamed(context, '/');
      } else {
        isLoggedIn = true;
        UserClass.loggedIn = true;

        userType = "mentor";
        UserClass.type = "mentor";

        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;
        currentMentorPage = "Profile";
        initializeUser();
      }
    });
  }

  MentorUser mentor = MentorUser(currentUserEmail);
  Future<void> initializeUser() async {
    await mentor.setInfo();
  }


  void loadProfilePicture(AsyncSnapshot snapshot){
    if(initialProfilePicLoad){

      int mentorIndex = snapshot.data[2][currentUserEmail]['user-index'];

      getData(profilePictureBytes, 'Mentors/mentor_$mentorIndex/picture_0.jpg', '', setState).then((result) {
        setState(() {
          profilePictureBytes = result;
        });
      }).catchError((error) {
        debugPrint("Error - $error");
      });
      initialProfilePicLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    currentMentorPage = "Profile";
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isDesktop(context)?false:true,
        title: isDesktop(context)?topBarMentor(context):mobileTopBarMentor(),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: isMobile(context)?drawerMentorWidget(context, scaffoldKey):Container(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Center(
          child: initialNameSetup?FutureBuilder(
            future: Future.wait([mentorAccountsData(), categoriesData(), userAccountsData()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                  return Center(child: CircularProgressIndicator(color: Config.secondaryColor,));
                }
                else if(snapshot.hasData){

                  loadProfilePicture(snapshot);

                  return Column(
                    crossAxisAlignment: editServices?CrossAxisAlignment.center:CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50,),
                      profilePage(snapshot),
                    ],
                  );
                }
              }
              return Center(child: CircularProgressIndicator(color: Config.secondaryColor,));
            },
          ):editServices?
          FutureBuilder(
              future: Future.wait([mentorAccountsData(), categoriesData(), userAccountsData()]),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasError){
                    return Center(child: CircularProgressIndicator(color: Config.secondaryColor,));
                  }
                  else if(snapshot.hasData){
                    return Column(
                      crossAxisAlignment: editServices?CrossAxisAlignment.center:CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50,),
                        editMentorshipServices(snapshot),
                      ],
                    );
                  }
                }
                return Center(child: CircularProgressIndicator(color: Config.secondaryColor,));
              },

          ):viewWeekDayTimings?
              FutureBuilder(
                future: Future.wait([mentorAccountsData(), categoriesData(), userAccountsData()]),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return Center(child: CircularProgressIndicator(color: Config.secondaryColor,));
                    }
                    else if(snapshot.hasData){
                      return Column(
                        crossAxisAlignment: editServices?CrossAxisAlignment.center:CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50,),
                          weekDayTimingSetup(snapshot),
                        ],
                      );
                    }
                  }
                  return Center(child: CircularProgressIndicator(color: Config.secondaryColor,));
                },

              ):
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30,),
                const Text("Full Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                const SizedBox(height: 10,),

                SizedBox(
                  width: isDesktop(context)?screenWidth(context) / 5:screenWidth(context)/1.5,
                  child:  ListTile(
                    leading: VerticalDivider(
                      color: Config.secondaryColor,
                      width: 2,
                    ),
                    title: Text(nameController.text),
                  ),
                ),
                const SizedBox(height: 30,),
                const Text("Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                const SizedBox(height: 10,),

                SizedBox(
                  width: isDesktop(context)?screenWidth(context) :screenWidth(context),
                  child:  ListTile(
                    leading: const VerticalDivider(
                      color: Colors.orange,
                      width: 2,
                    ),
                    title: Text(currentUserEmail),
                  ),
                ),
                SizedBox(height: 30,),

                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("My Timing Availability", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                    SizedBox(width: 50,),
                    Container(
                      width: isDesktop(context)?screenWidth(context) / 12:screenWidth(context)/5,
                      height: 40,
                      margin: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: !true?Colors.grey:Config.mainColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: ()  {
                          if(true){
                            setState(() {
                              viewWeekDayTimings = true;
                              editServices = false;
                            });
                          }

                        },
                        child: Text("View", style: TextStyle(
                          color: Colors.white,
                        ),
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30,),

                const Text("Profile Photo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                const SizedBox(height: 10,),

                Row(
                  children: [
                    profilePictureBytes.isEmpty?SizedBox(
                      width: isDesktop(context)?200:100,
                      height: isDesktop(context)?150:100,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ):imageContainer(profilePictureBytes, isDesktop(context)?screenWidth(context) / 6:screenWidth(context) / 3, isDesktop(context)?150:100, 20),
                    SizedBox(width: 20,),
                    Container(
                      width: isDesktop(context)?screenWidth(context) / 12:screenWidth(context)/5,
                      height: 40,
                      margin: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: Config.mainColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await pickImage(profilePictureImageBytes, setState).then((result) {
                            if(result.isNotEmpty){
                              profilePictureBytes = result;
                            }
                          }).catchError((error) {
                            debugPrint("Error - $error");
                          });

                          await uploadFileWeb(mentor.getIndex(), profilePictureBytes);

                        },
                        child: Text("Edit", style: TextStyle(
                          color: Colors.white,
                        ),
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30,),

                const Text("Description", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                const SizedBox(height: 10,),

                Row(
                  children: [
                    Container(
                      width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context)/1.5,
                      child:  ListTile(
                        leading: VerticalDivider(
                          color: Config.secondaryColor,
                          width: 2,
                        ),
                        title: TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          controller: descriptionController,
                        ),
                      ),
                    ),
                    Container(
                      width: isDesktop(context)?screenWidth(context) / 12:screenWidth(context)/5,
                      height: 40,
                      margin: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: descriptionController.text.isNotEmpty?Config.secondaryColor:Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
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

                          if(descriptionController.text.isNotEmpty){
                            descriptionText = descriptionController.text;
                            await Database().updateMentorDescription(mentor.getIndex(), descriptionController.text);
                          }
                          else{
                            setState(() {
                              descriptionController.text = descriptionText;
                            });
                          }

                          Navigator.of(context, rootNavigator: true).pop();

                        },
                        child: Text("Save", style: TextStyle(
                          color: Colors.white,
                        ),
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                const Row(
                  children: [
                    Text("Sport", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                    SizedBox(width: 50,),

                  ],
                ),
                SizedBox(height: 30,),
                Container(
                  width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context),
                  height: 50,
                  child: ListTile(
                    leading: VerticalDivider(color: Colors.blue,width: 3,),
                    title: Text(sportName),
                  ),
                ),
                SizedBox(height: 30,),

                Row(
                  children: [
                    Text("Mentorship Services", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                    SizedBox(width: 50,),
                    Container(
                      width: isDesktop(context)?screenWidth(context) / 12:screenWidth(context)/5,
                      height: 40,
                      margin: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                        color: Config.mainColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: ()  {
                          if(true){
                            setState(() {
                              items = [];
                              checked = [];
                              initialServices = true;
                              editServices = true;
                              viewWeekDayTimings = false;
                            });
                          }
                        },
                        child: Text("Edit", style: TextStyle(
                          color: Colors.white,
                        ),
                          textAlign: TextAlign.center,),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Container(
                  width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context),
                 // height: screenHeight(context) / 3,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: mentorshipServices.length,
                      itemBuilder: (context,index){
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: VerticalDivider(color: Colors.blue,width: 3,),
                            title: Text(mentorshipServices[index]),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool initialNameSetup = true;
  Container profilePage(AsyncSnapshot<dynamic> snapshot){
    currentMentorPage = "Profile";
    if(initialNameSetup){
      nameController.text = snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['user-name'];
      descriptionController.text = snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['description'];
      userName = nameController.text;
      descriptionText = descriptionController.text;
      sportName = snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['main-sports'][0];
      mentorshipServices = snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['main-mentorship-services'];
      initialNameSetup = false;
    }

    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Full Name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 10,),

          Container(
            width: isDesktop(context)?screenWidth(context) / 5:screenWidth(context)/1.5,
            child:  ListTile(
              leading: VerticalDivider(
                color: Config.secondaryColor,
                width: 2,
              ),
              title: Text(nameController.text),
            ),
          ),
          SizedBox(height: 30,),
          const Text("Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 10,),

          Container(
            width: isDesktop(context)?screenWidth(context) :screenWidth(context),
            child:  ListTile(
              leading: VerticalDivider(
                color: Colors.orange,
                width: 2,
              ),
              title: Text("${ snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['user-email']}"),
            ),
          ),
          SizedBox(height: 30,),

          const Text("Profile Photo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 10,),

          Row(
            children: [
              profilePictureBytes.isEmpty?SizedBox(
                width: isDesktop(context)?200:100,
                height: isDesktop(context)?150:100,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                ),
              ):imageContainer(profilePictureBytes, isDesktop(context)?screenWidth(context) / 6:screenWidth(context) / 3, isDesktop(context)?150:100, 20),
              SizedBox(width: 20,),
              Container(
                width: isDesktop(context)?screenWidth(context) / 12:screenWidth(context)/5,
                height: 40,
                margin: EdgeInsets.only(right: 30),
                decoration: BoxDecoration(
                  color: Config.mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    await pickImage(profilePictureImageBytes, setState).then((result) {
                      profilePictureBytes = result;
                    }).catchError((error) {
                      debugPrint("Error - $error");
                    });

                    await uploadFileWeb(mentor.getIndex(), profilePictureBytes);

                  },
                  child: Text("Edit", style: TextStyle(
                    color: Colors.white,
                  ),
                    textAlign: TextAlign.center,),
                ),
              ),
            ],
          ),

          SizedBox(height: 30,),

          const Text("Description", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 10,),

          Row(
            children: [
              Container(
                width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context)/1.5,
                child:  ListTile(
                  leading: VerticalDivider(
                    color: Config.secondaryColor,
                    width: 2,
                  ),
                  title: TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    controller: descriptionController,
                  ),
                ),
              ),
              Container(
                width: isDesktop(context)?screenWidth(context) / 12:screenWidth(context)/5,
                height: 40,
                margin: EdgeInsets.only(right: 30),
                decoration: BoxDecoration(
                  color: descriptionController.text.isNotEmpty?Config.secondaryColor:Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    if(descriptionController.text.isNotEmpty){
                      await Database().updateMentorDescription(snapshot.data[2][currentUserEmail]['user-index'], descriptionController.text);
                    }
                    else{
                      setState(() {
                        descriptionController.text = snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['description'];
                      });
                    }
                  },
                  child: Text("Save", style: TextStyle(
                    color: Colors.white,
                  ),
                    textAlign: TextAlign.center,),
                ),
              ),
            ],
          ),
          SizedBox(height: 30,),
          const Row(
            children: [
              Text("Sport", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
              SizedBox(width: 50,),

            ],
          ),
          SizedBox(height: 30,),
          Container(
            width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context),
            height: 50,
            child: ListView.builder(
                itemCount: snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['main-sports'].length,
                itemBuilder: (context,index){
                  return ListTile(
                    leading: VerticalDivider(color: Colors.blue,width: 3,),
                    title: Text(snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['main-sports'][index]),
                  );
            }),
          ),
          SizedBox(height: 30,),

          Row(
            children: [
              Text("Mentorship Services", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
              SizedBox(width: 50,),
              Container(
                width: isDesktop(context)?screenWidth(context) / 12:screenWidth(context)/5,
                height: 40,
                margin: EdgeInsets.only(right: 30),
                decoration: BoxDecoration(
                  color: Config.mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: ()  {
                    if(true){
                      setState(() {
                        items = [];
                        checked = [];
                        initialServices = true;
                        editServices = true;
                        viewWeekDayTimings = false;
                      });
                    }
                  },
                  child: Text("Edit", style: TextStyle(
                    color: Colors.white,
                  ),
                    textAlign: TextAlign.center,),
                ),
              ),
            ],
          ),
          SizedBox(height: 30,),
          Container(
            width: isDesktop(context)?screenWidth(context) / 3:screenWidth(context),
            //height: screenHeight(context) / 2,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['main-mentorship-services'].length,
                itemBuilder: (context,index){
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: VerticalDivider(color: Colors.blue,width: 3,),
                      title: Text(snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['main-mentorship-services'][index]),
                    ),
                  );
                }),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text("My Timing Availability", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
              SizedBox(width: 50,),
              Container(
                width: isDesktop(context)?screenWidth(context) / 12:screenWidth(context)/5,
                height: 40,
                margin: EdgeInsets.only(right: 30),
                decoration: BoxDecoration(
                  color: !true?Colors.grey:Config.mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: ()  {
                    if(true){
                      setState(() {
                        viewWeekDayTimings = true;
                        editServices = false;
                      });
                    }

                  },
                  child: Text("View", style: TextStyle(
                    color: Colors.white,
                  ),
                    textAlign: TextAlign.center,),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container weekDayTimingSetup(AsyncSnapshot<dynamic> snapshot){
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Week Day Timing Availability", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          SizedBox(height: 20,),
          Container(
            width: screenWidth(context),
            height: screenHeight(context),
            margin: EdgeInsets.only(left: 30),
            child: ListView.builder(
                itemCount: weekDays.length,
                itemBuilder: (context,index){
                  return Container(
                    margin: EdgeInsets.only(top:10,bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(weekDays[index], style: TextStyle(color: Colors.black, fontSize: 16),),
                        SizedBox(width: 30),
                        Container(
                          width: isDesktop(context)?screenWidth(context) / 10:screenWidth(context) / 5,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              dayToEdit = weekDays[index];
                              if(snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['timings'][dayToEdit]['start-time'] != "None"){
                                selectedStartTimeToEdit = snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['timings'][dayToEdit]['start-time'];
                                selectedEndTimeToEdit = snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['timings'][dayToEdit]['end-time'];
                                minuteGapItemToEdit = snapshot.data[0]['${snapshot.data[2][currentUserEmail]['user-index']}']['timings'][dayToEdit]['minute-gap'];
                                selectedDayToEdit = true;
                                confirmedMinuteGapToEdit = true;
                                selectedStartToEdit = true;
                                selectedEndToEdit = true;
                                weekDaysTimingsStartToEdit = getTimings(
                                    getHour(selectedStartTimeToEdit),
                                    getMinute(selectedStartTimeToEdit),
                                    minuteGapItemToEdit,
                                    getEnd(selectedStartTimeToEdit),
                                    "start","12:00 AM",DateTime.now()
                                );
                                weekDaysTimingsEndToEdit = getTimings(
                                    getMinute(selectedStartTimeToEdit) + int.parse(minuteGapItemToEdit) == 60 && getHour(selectedStartTimeToEdit) + 1 == 13?1:getMinute(selectedStartTimeToEdit) + int.parse(minuteGapItemToEdit) == 60 && getHour(selectedStartTimeToEdit) + 1 != 13?getHour(selectedStartTimeToEdit) + 1:getHour(selectedStartTimeToEdit),
                                    getMinute(selectedStartTimeToEdit) + int.parse(minuteGapItemToEdit) == 60?0:getMinute(selectedStartTimeToEdit) + int.parse(minuteGapItemToEdit),
                                    minuteGapItemToEdit,
                                    getMinute(selectedStartTimeToEdit) + int.parse(minuteGapItemToEdit) == 60 && getHour(selectedStartTimeToEdit) + 1 == 12 && getEnd(selectedStartTimeToEdit) == "AM"?"PM":
                                    getMinute(selectedStartTimeToEdit) + int.parse(minuteGapItemToEdit) != 60 && getEnd(selectedStartTimeToEdit) == "PM"?"PM":
                                    getMinute(selectedStartTimeToEdit) + int.parse(minuteGapItemToEdit) == 60 && getEnd(selectedStartTimeToEdit) == "PM"?"PM":"AM",
                                    "end", "12:00 AM",DateTime.now()
                                );
                              }
                              else{
                                selectedStartTimeToEdit = 'None';
                                selectedEndTimeToEdit = 'None';
                                minuteGapItemToEdit = '';
                                selectedDayToEdit = false;
                                confirmedMinuteGapToEdit = false;
                                selectedStartToEdit = false;
                                selectedEndToEdit = false;
                              }


                              await Database().editSelectedDay(currentUserEmail, dayToEdit);

                              Navigator.pushNamed(context, '/edit-day');
                            },
                            child: Text("Edit", style: TextStyle(
                              color: Colors.white,
                            ),),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Column editMentorshipServices(AsyncSnapshot<dynamic> snapshot){
    if(initialServices){
      int serviceIndex = 0;
      while(serviceIndex < snapshot.data[1]['category-amount']){
        items.add(snapshot.data[1]['$serviceIndex']['category-name']);
        int mentorIndex = 0;
        bool isChecked = false;
        while(mentorIndex < snapshot.data[1]['$serviceIndex']['mentors'].length){
          if(snapshot.data[1]['$serviceIndex']['mentors'][mentorIndex] == snapshot.data[2][currentUserEmail]['user-index']){
            checked.add(true);
            isChecked = true;
            break;
          }
          mentorIndex++;
        }
        if(!isChecked){
          checked.add(false);
        }
        serviceIndex++;
        initialServices = false;
      }
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
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
        SizedBox(height: 30,),
        Container(
          width: isDesktop(context)?screenWidth(context) / 6:screenWidth(context)/2,
          height: 50,
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Config.mainColor,
            borderRadius: BorderRadius.circular(10),
          ),
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


              List<String> mentorshipServices = [];
              int serviceIndex = 0;
              while(serviceIndex < snapshot.data[1]['category-amount']){
                int mentorIndex = 0;
                List<int> mentors = [];
                bool addedCurrentMentor = false;
                if(checked[serviceIndex]){
                  mentorshipServices.add(snapshot.data[1]['$serviceIndex']['category-name']);
                }

                while(mentorIndex < snapshot.data[1]['$serviceIndex']['mentors'].length){
                  if(snapshot.data[1]['$serviceIndex']['mentors'][mentorIndex] == snapshot.data[2][currentUserEmail]['user-index'] && !checked[serviceIndex]){
                    // DON'T ADD MENTOR
                  }
                  else {
                    if(snapshot.data[1]['$serviceIndex']['mentors'][mentorIndex] == snapshot.data[2][currentUserEmail]['user-index']){
                      addedCurrentMentor = true;
                    }
                    mentors.add(snapshot.data[1]['$serviceIndex']['mentors'][mentorIndex]);
                  }
                  mentorIndex++;
                }
                if(!addedCurrentMentor && checked[serviceIndex]){
                  mentors.add(snapshot.data[2][currentUserEmail]['user-index']);
                }
                await Database().updateCategoryMentors(serviceIndex, mentors);
                serviceIndex++;
              }

              await Database().updateMentorServices(snapshot.data[2][currentUserEmail]['user-index'], mentorshipServices);

              if (!context.mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pushNamed(context, '/mentor-profile');

            },
            child: Text("Save Changes", style: TextStyle(
              color: Colors.white,
            ),
              textAlign: TextAlign.center,),
          ),
        ),
      ],
    );
  }
}
