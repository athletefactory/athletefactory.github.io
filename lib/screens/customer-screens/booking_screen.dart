import 'package:athlete_factory/functions/dimensions.dart';
import 'package:athlete_factory/functions/timing_functions.dart';
import 'package:athlete_factory/screens/signed-out-screens/signup_process.dart';
import 'package:athlete_factory/screens/signed-out-screens/verify_email.dart';
import 'package:athlete_factory/services/database.dart';
import 'package:athlete_factory/widgets/signed-out-widgets/top-bar-signed-out.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../config.dart';
import '../../functions/platform-type.dart';
import '../../functions/check_user_type.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../services/stripe-checkout-web.dart';
import '../../widgets/customer-widgets/mobile-top-bar.dart';
import '../../widgets/customer-widgets/top-bar-customer.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({Key? key}) : super(key: key);
  var currentHeight = 460.0;
  final GlobalKey _key = GlobalKey();
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}



class _BookingScreenState extends State<BookingScreen> {


  int timeIndexSelected = 0;
  String selectedMentorName = '';
  var selectedDay = DateTime.now().add(const Duration(days: 5));
  List<String> timings = [];

  String currentDayOfWeek = '';
  String currentDateInWords = '';

  //bool isRefresh = true;

  var focusedDay = DateTime.now().add(const Duration(days: 5));
  var timePicked = DateTime.now().add(const Duration(days: 5));

  bool showNoTimings = false;
  bool initial = true;

  List<dynamic> mentorshipServices = [];
  List<bool> mentorshipServicesSelected = [];
  List<String> weekDays = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];

  final dateFormat = DateFormat('EEEE yyyy-MMMM-dd');
  CalendarFormat format = CalendarFormat.month;

  String getWeekDay(String date){
    String weekDay = "";
    int letterIdx = 0;
    while(date[letterIdx] != ' '){
      weekDay += date[letterIdx];
      letterIdx++;
    }
    return weekDay;
  }

  List<String> getSelectedServices(List<dynamic> mentorshipServices, List<bool> mentorshipServicesSelected) {
    List<String> services = [];
    for (int serviceIndex = 0; serviceIndex < mentorshipServices.length; serviceIndex++) {
      if (mentorshipServicesSelected[serviceIndex]) {
        services.add(mentorshipServices[serviceIndex]);
      }
    }
    return services;
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn = false;
        userType = "";
        currentSignedOutPage = "Home";
        Navigator.popAndPushNamed(context, '/');
      } else {
        isLoggedIn = true;
        currentUserEmail = user.email!;
        isEmailVerified = user.emailVerified;
        userType = "customer";
        initializeUser();
      }
    });
  }

  CustomerUser customer = CustomerUser(currentUserEmail);

  Future<void> initializeUser() async {
    await customer.setInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            if(UserClass.refreshing){
              Navigator.popAndPushNamed(context, '/customer-home');
            }
            else{
              Navigator.pop(context);
            }
          },
        ),
        title: isDesktop(context)?topBarCustomer(context):mobileTopBar(),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: IntrinsicHeight(
          child: Container(
            margin: isDesktop(context)?const EdgeInsets.all(10):const EdgeInsets.only(left: 10,right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Center(
                  child: Card(
                    elevation: 4,
                    surfaceTintColor: Colors.white,
                    child: Container(
                      height: widget.currentHeight,
                      width: isDesktop(context)?screenWidth(context) / 2:screenWidth(context) ,
                      padding: EdgeInsets.all(isDesktop(context)?30:0),
                      child: TableCalendar(
                        key: widget._key,
                        focusedDay:selectedDay,
                        firstDay: DateTime(2024, DateTime.now().month,DateTime.now().day + 5),
                        lastDay: DateTime(2050),
                        calendarFormat: CalendarFormat.month,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                        },
                        daysOfWeekVisible: true,
                        calendarStyle: CalendarStyle(
                          isTodayHighlighted:true,
                          selectedDecoration:  BoxDecoration(
                            color: Config.secondaryColor,
                            shape: BoxShape.rectangle,
                          ),

                          todayTextStyle: const TextStyle(color: Colors.black),
                          selectedTextStyle: const TextStyle(color: Colors.black),
                          todayDecoration: BoxDecoration(
                            border: Border.all(
                              color:Colors.black,
                            ),
                            color:Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: true,
                          titleCentered: true,
                          formatButtonShowsNext: false,
                        ),
                        selectedDayPredicate: (DateTime date){
                          return isSameDay(selectedDay, date);
                        },
                        onDaySelected: (DateTime selectDay, DateTime focusDay){
                          setState(() {
                            if((focusDay.day >= DateTime.now().day && focusDay.month == DateTime.now().month) || focusDay.month > DateTime.now().month){
                              setState(() {
                                selectedDay = selectDay;
                                focusedDay = focusDay;
                                timePicked = selectedDay;
                              });
                            }
                          });
                        },
                        onFormatChanged: (CalendarFormat format){
                          setState((){
                            format = format;
                            /*
                            setState(() {
                              if(format == CalendarFormat.week){
                                widget.currentHeight = 200;
                              }
                              else if(format == CalendarFormat.twoWeeks){
                                format = CalendarFormat.week;
                                widget.currentHeight = 200;
                              }
                              else if(format == CalendarFormat.month){
                                widget.currentHeight = 460;
                              }
                            });
                            */
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Center(
                  child: FutureBuilder(
                    future: Future.wait([mentorAccountsData(), customerAccountsData(), userAccountsData(), adminData()]),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasError){
                          return const Text("");
                        }
                        else if(snapshot.hasData){

                          // Getting day of week from the date.
                          currentDateInWords = dateFormat.format(timePicked);
                          currentDayOfWeek = getWeekDay(currentDateInWords);
                          // If refresh button clicked,
                          // Get the mentor index that was selected by the user from the database, and set the name of the mentor.
                          if(UserClass.refresh){
                            //customer.setSelectedMentor(snapshot.data[2][customer.getEmail()]['selected-mentor-index']);
                            selectedMentorName = snapshot.data[0]['${customer.getMentorIndex()}']['user-name'];
                            UserClass.refresh = false;
                          }
                          // Get the start time based on the day of the week selected by the customer
                          String startTime = snapshot.data[0]['${customer.getMentorIndex()}']['timings'][currentDayOfWeek]['start-time'];

                          // If the start time is "None" meaning that the mentor has not set available times for the day selected
                          // Set showNoTimings to true, which will be used to display a widget that illustrates no availability
                          if(startTime == "None"){
                            showNoTimings = true;
                          }
                          else{

                            showNoTimings = false;
                            // We already got the startTime at line 191, now we get the endTime based on the day selected by the customer
                            String endTime = snapshot.data[0]['${customer.getMentorIndex()}']['timings'][currentDayOfWeek]['end-time'];
                            // We get the duration of the session for the day selected to generate all the possible timings.
                            String minuteGap = snapshot.data[0]['${customer.getMentorIndex()}']['timings'][currentDayOfWeek]['minute-gap'];
                            // We get the starting hour based on the start time. Example: startTime = "12:00 PM", so startingHour = 12
                            int startingHour = getHour(startTime);
                            // We get the starting minute based on the start time. Example: startTime = "12:00 PM", so startingMinute = 0
                            int startingMinute = getMinute(startTime);
                            // We get "AM" or "PM" based on the start time. Example: startTime = "12:00 PM", so startingEnd = "PM"
                            String startingEnd = getEnd(startTime);
                            // Once we have all of the components of the start time and we have the endTime
                            // We use them to generate all the timings in between.
                            timings = getTimings(startingHour, startingMinute, minuteGap, startingEnd, "booking", endTime, timePicked);
                            // Once we generate all the times in between the start and end time
                            // We remove any timings that have already been booked by other customers.
                            timings = filterTimings(snapshot, customer.getMentorIndex(), timings, selectedDay);
                            // We get the services that the selected mentor provides.
                            mentorshipServices = snapshot.data[0]['${customer.getMentorIndex()}']['main-mentorship-services'];
                            // If this is the first time the future builder is ran, Then we set all services as NOT selected by the customer.
                            if(initial){
                              mentorshipServicesSelected = List.generate(mentorshipServices.length, (index) => false);
                              initial = false;
                            }
                          }

                          return SizedBox(
                           width: isDesktop(context)?screenWidth(context) /2:screenWidth(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: isDesktop(context)?screenWidth(context) / 2:screenWidth(context) ,
                                  child: Center(
                                    child: ListView.builder(
                                        itemCount: showNoTimings || timings.isEmpty?1:timings.length,
                                        shrinkWrap: showNoTimings || timings.isEmpty?true:false,
                                        scrollDirection: Axis.horizontal,
                                        physics: const ScrollPhysics(),
                                        itemBuilder: (context,index){
                                          return Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            width: (showNoTimings || timings.isEmpty) && isDesktop(context)?screenWidth(context) / 3:(showNoTimings || timings.isEmpty) && !isDesktop(context)?screenWidth(context) * 0.9:150,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: showNoTimings || timings.isEmpty?Colors.grey:timeIndexSelected == index?Config.secondaryColor:Colors.grey[400],
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                if(!showNoTimings){
                                                  setState(() {
                                                    timeIndexSelected = index;
                                                  });
                                                }
                                              },
                                              child: Text(showNoTimings || timings.isEmpty?"No Availability for this day":'${timings[index]} EST', style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                                textAlign: TextAlign.center,),
                                            ),
                                          );
                                        }),
                                  ),
                                ),

                                SizedBox(height: !showNoTimings && timings.isNotEmpty?40:0,),
                                showNoTimings || timings.isEmpty?Container():Container(
                                  width: isDesktop(context)?screenWidth(context) / 4:screenWidth(context) * 0.9,
                                  height: 50,
                                  margin: const EdgeInsets.only(bottom: 30),
                                  decoration: BoxDecoration(
                                    color: Config.secondaryColor,
                                    borderRadius: BorderRadius.circular(30),
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
                                      // If the mentor has set available time slots for the selected day
                                      if(!showNoTimings){
                                        // Get the mentor's booking list
                                        List<dynamic> mentorBookings = snapshot.data[0]['${customer.getMentorIndex()}']['bookings'];
                                        // Get the current booking index from the mentor's booking list.
                                        int mentorBookingIndex = mentorBookings.length;

                                        // Get the mentor's name based on the selected mentor's index.
                                        selectedMentorName = snapshot.data[0]['${customer.getMentorIndex()}']['user-name'];

                                        // Calls the function to store the temporary booking details in the customer document in the database
                                        await Database().updateBookingExists(customer.getIndex());
                                        await Database().updateCurrentBookingInfo(customer.getEmail(), mentorBookingIndex, selectedDay.day, selectedDay.month, selectedDay.year, timings[timeIndexSelected], selectedMentorName);

                                        // Get users eligible for free session
                                        //List<dynamic> freeUsers = snapshot.data[3]['free-customers'];

                                        // Get stripe key from database
                                        String key = snapshot.data[3]['stripe']['${isTesting?'test':'stripe'}-key'];
                                        String priceKey = '';
                                        // If the session booked is a 30 minute sessions, get the 30 minute price key
                                        if(snapshot.data[0]['${customer.getMentorIndex()}']['timings'][currentDayOfWeek]['minute-gap'] == '30'){
                                          priceKey = snapshot.data[3]['stripe']['${isTesting?'test-thirty':'thirty'}-minute-session-key'];
                                        }
                                        // If not, get the 60 minute price key.
                                        else{
                                          priceKey = snapshot.data[3]['stripe']['${isTesting?'test-sixty':'sixty'}-minute-session-key'];
                                        }
                                        if (!context.mounted) return;
                                        // Pops the CircularProgressIndicator
                                        Navigator.of(context, rootNavigator: true).pop();
                                        // Redirects to stripe's official checkout
                                        redirectToCheckout(context,key,priceKey);
                                      }
                                    },
                                    child: const Text("Book Session", style: TextStyle(
                                      color: Colors.white,
                                    ),
                                      textAlign: TextAlign.center,),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isEligible(String str, List<dynamic> array) {
    return array.contains(str);
  }

}