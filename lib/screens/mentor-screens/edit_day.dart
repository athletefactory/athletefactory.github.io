import 'package:athlete_factory/config.dart';
import 'package:athlete_factory/functions/dimensions.dart';
import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../functions/check_user_type.dart';
import '../../functions/platform-type.dart';
import '../../functions/timing_functions.dart';
import '../../services/database.dart';
import '../../widgets/mentor-widgets/mobile-top-bar-mentor.dart';
import '../../widgets/mentor-widgets/top-bar-mentor.dart';


class EditDay extends StatefulWidget {
  const EditDay({Key? key}) : super(key: key);

  @override
  _EditDayState createState() => _EditDayState();
}

String dayToEdit = "";
bool selectedDayToEdit = false;
List<String> weekDaysTimingsStartToEdit = [];
List<String> weekDaysTimingsEndToEdit = [];
String selectedStartTimeToEdit = "";
String selectedEndTimeToEdit = "";
bool selectedStartToEdit = false;
bool selectedEndToEdit = false;

String minuteGapItemToEdit = "";
bool confirmedMinuteGapToEdit = false;

class _EditDayState extends State<EditDay> {


  int currentUserIndex = 0;

  bool wrongInput = false;
  List<String> weekDays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        UserClass.loggedIn = false;
        UserClass.type = "";
      } else {
        isLoggedIn = true;
        UserClass.loggedIn = true;

        userType = "mentor";
        UserClass.type = "mentor";

        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;
        currentMentorPage = "Profile";
      }
    });
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: Container(
          width: screenWidth(context),
          height: screenHeight(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: userAccountsData(),
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return const Text("");
                    }
                    else if(snapshot.hasData){
          
                      if(dayToEdit == ''){
                        dayToEdit = snapshot.data![currentUserEmail]['selected-day-to-edit'];
                      }
          
                      return Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(dayToEdit, style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),),
                            SizedBox(width: 20,),
                            Switch(
                              activeColor: Config.secondaryColor,
                              inactiveTrackColor: Colors.white,
                              value: selectedDayToEdit,
                              onChanged: (bool value) {
                                setState(() {
                                  selectedDayToEdit = !selectedDayToEdit;
                                  if(!selectedDayToEdit){
                                    confirmedMinuteGapToEdit = false;
                                    selectedStartToEdit = false;
                                    selectedEndToEdit = false;
                                    minuteGapItemToEdit = '';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return Container();
                },
          
              ),
              selectedDayToEdit?Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Session Length (minutes)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                      SizedBox(width: 10,),
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(5.0), // Border radius
                        ),
          
                        child: DropdownButton<String>(
                          value: minuteGapItemToEdit,
                          onChanged: (String? newValue) {
                            setState(() {
                              if(newValue == ''){
                                setState(() {
                                  wrongInput = true;
                                });
                              }
                              else{
                                minuteGapItemToEdit = newValue!;
                                weekDaysTimingsStartToEdit = getTimings(12, 0, minuteGapItemToEdit, "AM", "start", "12:00 AM", DateTime.now());
                                selectedStartTimeToEdit = weekDaysTimingsStartToEdit[0];
                                setState(() {
                                  confirmedMinuteGapToEdit = true;
                                  selectedStartToEdit = false;
                                  selectedEndToEdit = false;
                                });
                              }
                            });
                          },
                          items: <String>['', '30', '60',].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ):Container(),
              confirmedMinuteGapToEdit?Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Start Time (EST)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                      SizedBox(width: 10,),
                      DropdownButton<String>(
                        value: selectedStartTimeToEdit,
                        hint: Text('Select an item'),
                        onChanged: (String? newValue) {
                          setState(() {
                            if(newValue == ''){
                              wrongInput = true;
                            }
                            else{
                              selectedStartTimeToEdit = newValue!;
                              selectedStartToEdit = true;
                              selectedEndToEdit = false;
                              weekDaysTimingsEndToEdit = getTimings(
                                  getMinute(newValue) + int.parse(minuteGapItemToEdit) == 60 && getHour(newValue) + 1 == 13?1:getMinute(newValue) + int.parse(minuteGapItemToEdit) == 60 && getHour(newValue) + 1 != 13?getHour(newValue) + 1:getHour(newValue),
                                  getMinute(newValue) + int.parse(minuteGapItemToEdit) == 60?0:getMinute(newValue) + int.parse(minuteGapItemToEdit),
                                  minuteGapItemToEdit,
                                  getMinute(newValue) + int.parse(minuteGapItemToEdit) == 60 && getHour(newValue) + 1 == 12 && getEnd(newValue) == "AM"?"PM":
                                  getMinute(newValue) + int.parse(minuteGapItemToEdit) != 60 && getEnd(newValue) == "PM"?"PM":
                                  getMinute(newValue) + int.parse(minuteGapItemToEdit) == 60 && getEnd(newValue) == "PM"?"PM":"AM",
                                  "end",
                                  "12:00 AM",
                                  DateTime.now()
                              );
                              selectedEndTimeToEdit = weekDaysTimingsEndToEdit[0];
                            }
                          });
                        },
                        items: weekDaysTimingsStartToEdit.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ):Container(),
              selectedStartToEdit?Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("End Time (EST)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
                      SizedBox(width: 10,),
                      DropdownButton<String>(
                        value: selectedEndTimeToEdit,
                        hint: Text('Select an item'),
                        onChanged: (String? newValue) {
                          if(newValue == ''){
                            setState(() {
                              wrongInput = true;
                            });
                          }
                          else{
                            setState(() {
                              selectedEndTimeToEdit = newValue!;
                              selectedEndToEdit = true;
                            });
                          }
                        },
                        items: weekDaysTimingsEndToEdit.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ):Container(),
              FutureBuilder(
                future: userAccountsData(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError){
                      return const Text("");
                    }
                    else if(snapshot.hasData){
                      return Container(
                        width: isDesktop(context)?screenWidth(context) / 4:screenWidth(context) / 2,
                        height: 40,
                        decoration: BoxDecoration(
                          color: !selectedDayToEdit?Config.mainColor:selectedStartToEdit && confirmedMinuteGapToEdit && selectedEndToEdit?Config.mainColor:Colors.grey,
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

                            if(selectedDayToEdit){
                              if(selectedEndToEdit){
                                await Database().addTiming(snapshot.data[currentUserEmail]['user-index'], dayToEdit, selectedStartTimeToEdit, selectedEndTimeToEdit, minuteGapItemToEdit);
                                Navigator.pushNamed(context, '/mentor-profile');
                              }
                              else{
                                Navigator.of(context, rootNavigator: true).pop();
                              }
                            }
                            else if(!selectedDayToEdit){
          
                              currentUserIndex = snapshot.data[currentUserEmail]['user-index'];
          
                              await Database().addTiming(currentUserIndex, dayToEdit, "None", "None", "None");
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.pushNamed(context, '/mentor-profile');
                            }
                            else{
                              Navigator.of(context, rootNavigator: true).pop();
                            }

                          },
                          child: Text("Save Changes", style: TextStyle(
                            color: Colors.white,
                          ),),
                        ),
                      );
                    }
                  }
                  return const CircularProgressIndicator();
                },
          
              ),
            ],
          ),
        ),
      ),
    );
  }
}
