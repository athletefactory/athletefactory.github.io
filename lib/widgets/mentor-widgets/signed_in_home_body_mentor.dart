import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/services/database.dart';
import 'package:flutter/material.dart';
import '../../colors/main-colors.dart';
import '../../functions/check_user_type.dart';
import '../../functions/dimensions.dart';
import '../../functions/platform-type.dart';
import '../../functions/timing_functions.dart';
import '../../config.dart';

MentorUser handleInitialSetup(AsyncSnapshot<dynamic> snapshot, String currentUserEmail) {
  MentorUser mentor = MentorUser(currentUserEmail);
  if (mentor.getDataIsNotSetup()) {
    int userIndex = snapshot.data[1][currentUserEmail]['user-index'];
    String timingAdjusted = snapshot.data[0]['$userIndex']['timing-adjusted'];
    mentor.setTimeAdjusted(timingAdjusted == "true"?true:false);
    List<dynamic> bookings = snapshot.data[0]['$userIndex']['bookings'] ?? [];
    mentor.setBookings(bookings);
    mentor.setDataIsNotSetup(false);
  }
  return mentor;
}

Widget signedInHomeBodyMentor(BuildContext context, Function setState, MentorUser mentor){

  MentorUser mentor = MentorUser(currentUserEmail);

  return IntrinsicHeight(
    child: Container(
      margin: const EdgeInsets.all(20),
      child: FutureBuilder(
        future: Future.wait([mentorAccountsData(), userAccountsData()]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Center(
                child: CircularProgressIndicator(color: Config.secondaryColor,),
              );
            }
            else if(snapshot.hasData){

              // This is used to get the mentor's index using the mentor's email from the "Users" doc in the DB
              mentor = handleInitialSetup(snapshot, currentUserEmail);
              List<dynamic> bookings = mentor.getBookings();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dashboardTitle(),
                  mentor.getBookings().isEmpty?noBookingsWidget(context, mentor):bookingListWidget(context, mentor, bookings),
                ],
              );
            }
          }
          return Center(
            child: Container(
                margin: EdgeInsets.only(top: (screenHeight(context) / 2) - AppBar().preferredSize.height),
                child: CircularProgressIndicator(color: Config.secondaryColor,)
            ),
          );
        },
        
      ),
    ),
  );
}

Widget dashboardTitle(){
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 50,),
      Text("DASHBOARD", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
      SizedBox(height: 30,),
      Text("SESSIONS COMING UP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
      SizedBox(height: 20,),
    ],
  );
}

Widget noBookingsWidget(BuildContext context, MentorUser mentor){
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(!mentor.timeAdjusted?"You need to setup your timing availability":"You have no sessions coming up", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal,),),
        const SizedBox(height: 30,),
        mentor.timeAdjusted?Container():Container(
          width: isDesktop(context)?screenWidth(context) / 6:screenWidth(context)/2,
          height: 40,
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Config.mainColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, '/mentor-profile'),
            child: const Text("Go to profile", style: TextStyle(
              color: Colors.white,
            ),
              textAlign: TextAlign.center,),
          ),
        ),
      ],
    ),
  );
}

Widget bookingListWidget(BuildContext context, MentorUser mentor, dynamic bookings){
  return SizedBox(
    height: isDesktop(context)?screenHeight(context) / 1.5:screenWidth(context),
    width: isDesktop(context)?screenWidth(context) / 2:screenWidth(context),
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: mentor.getBookings().length,
        itemBuilder: (context, index){

          return !isDateTimeAfterAppointment(bookings[index])?Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: ListTile(
                leading: const VerticalDivider(color: Colors.green, width: 3,),
                title: Text("${bookings[index]["user-name"]}", style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                ),),
                subtitle: Text("${bookings[index]["user-email"]}", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isDesktop(context)?12:10,
                ),),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${bookings[index]['booking-day']}/${bookings[index]['booking-month']}/${bookings[index]['booking-year']}",
                      style: const TextStyle(
                          fontSize: 14
                      ),),
                    Text("${bookings[index]['booking-time']} EST",
                      style: const TextStyle(
                          fontSize: 14
                      ),),
                  ],
                ),
              ),
            ),
          ):Container();
        }
    ),
  );
}
