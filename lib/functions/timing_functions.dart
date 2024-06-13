import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

Map<String, bool> timingsMapping = {};

bool isDateTimeAfterAppointment(dynamic booking) {
  // Get the current date and time
  DateTime now = DateTime.now();

  int day = booking['booking-day'];
  int month = booking['booking-month'];
  int year = booking['booking-year'];
  String time = booking['booking-time'];

  // Parse the appointment time
  RegExp regExp = RegExp(r'(\d+):(\d+) (AM|PM)');
  Match match = regExp.firstMatch(time)!;

  int hour = int.parse(match.group(1)!);
  int minute = int.parse(match.group(2)!);
  String period = match.group(3)!;

  // Convert 12-hour format to 24-hour format
  if (period == 'PM' && hour < 12) {
    hour += 12;
  }

  // Create a DateTime object for the appointment
  DateTime appointmentDateTime = DateTime(year, month, day, hour, minute);

  // Compare current date and time with appointment date and time
  return now.isAfter(appointmentDateTime);
}

bool isNowBeforeStartTime(String startTime) {
  // Get the current time
  DateTime now = DateTime.now();

  // Parse the start time
  RegExp regExp = RegExp(r'(\d+):(\d+) (AM|PM)');
  Iterable<Match> matchesStart = regExp.allMatches(startTime);

  if (matchesStart.isEmpty) {
    return false; // Invalid time format
  }

  Match matchStart = matchesStart.first;

  int hourStart = int.parse(matchStart.group(1)!);
  int minuteStart = int.parse(matchStart.group(2)!);
  String periodStart = matchStart.group(3)!;

  // Convert 12-hour format to 24-hour format for comparison
  if (periodStart == 'PM' && hourStart < 12) {
    hourStart += 12;
  }

  // Create a DateTime object for the start time
  DateTime startTimeDateTime = DateTime(now.year, now.month, now.day, hourStart, minuteStart);

  // Compare current time with start time
  return now.isBefore(startTimeDateTime);
}


bool isStartTimeBeforeNow(String startTime) {
  // Get the current time
  DateTime now = DateTime.now();

  // Parse the start time
  RegExp regExp = RegExp(r'(\d+):(\d+) (AM|PM)');
  Iterable<Match> matchesStart = regExp.allMatches(startTime);

  if (matchesStart.isEmpty) {
    return false; // Invalid time format
  }

  Match matchStart = matchesStart.first;

  int hourStart = int.parse(matchStart.group(1)!);
  int minuteStart = int.parse(matchStart.group(2)!);
  String periodStart = matchStart.group(3)!;

  // Convert 12-hour format to 24-hour format for comparison
  if (periodStart == 'PM' && hourStart < 12) {
    hourStart += 12;
  }

  // Create a DateTime object for the start time
  DateTime startTimeDateTime = DateTime(now.year, now.month, now.day, hourStart, minuteStart);

  // Compare start time with current time
  return startTimeDateTime.isBefore(now);
}

bool isTimeInRange(String timeToCheck, String startTime, String endTime) {
  // Parse time strings into hour, minute, and period components
  RegExp regExp = RegExp(r'(\d+):(\d+) (AM|PM)');
  Iterable<Match> matchesToCheck = regExp.allMatches(timeToCheck);
  Iterable<Match> matchesStart = regExp.allMatches(startTime);
  Iterable<Match> matchesEnd = regExp.allMatches(endTime);

  if (matchesToCheck.isEmpty || matchesStart.isEmpty || matchesEnd.isEmpty) {
    return false; // Invalid time format
  }

  Match matchToCheck = matchesToCheck.first;
  Match matchStart = matchesStart.first;
  Match matchEnd = matchesEnd.first;

  int hourToCheck = int.parse(matchToCheck.group(1)!);
  int minuteToCheck = int.parse(matchToCheck.group(2)!);
  String periodToCheck = matchToCheck.group(3)!;

  int hourStart = int.parse(matchStart.group(1)!);
  int minuteStart = int.parse(matchStart.group(2)!);
  String periodStart = matchStart.group(3)!;

  int hourEnd = int.parse(matchEnd.group(1)!);
  int minuteEnd = int.parse(matchEnd.group(2)!);
  String periodEnd = matchEnd.group(3)!;

  // Convert 12-hour format to 24-hour format for comparison
  if (periodToCheck == 'PM' && hourToCheck < 12) {
    hourToCheck += 12;
  }
  if (periodStart == 'PM' && hourStart < 12) {
    hourStart += 12;
  }
  if (periodEnd == 'PM' && hourEnd < 12) {
    hourEnd += 12;
  }

  // Check if the check time is between start and end time
  if (hourToCheck > hourStart || (hourToCheck == hourStart && minuteToCheck >= minuteStart)) {
    if (hourToCheck < hourEnd || (hourToCheck == hourEnd && minuteToCheck <= minuteEnd)) {
      return true;
    }
  }
  return false;
}


bool bookingTimePassed(int hour, int minute, String end, int day, int month, int year){

  if(year < DateTime.now().year){
    return true;
  }
  else if(year == DateTime.now().year){
    if(month < DateTime.now().month){
      return true;
    }
    else if(month == DateTime.now().month){
      if(day < DateTime.now().day){
        return true;
      }
      else if(day == DateTime.now().day){
        if(hour < DateTime.now().hour){
          return true;
        }
        else if(hour == DateTime.now().hour){
          if(minute < DateTime.now().minute){
            return true;
          }
          else if(minute >= DateTime.now().minute){
            return false;
          }
        }
      }
    }
  }
  return false;
}

List<String> getTimings(int startingHour, int startingMinute, String gap, String startingEnd, String timeType, String endTime, DateTime timePicked){
  List<String> currentDayTimings = [''];
  if(timeType == "booking"){
    currentDayTimings = [];
  }
  timingsMapping = {};
  int currentHour = startingHour;
  int currentMinute = startingMinute;
  String currentEnd = startingEnd;
  int minuteGap = int.parse(gap);
  String currentTime = "$currentHour:${currentMinute < 10?"0$currentMinute":currentMinute} $currentEnd";
  bool finished = false;

  while(!finished){
    if(timeType == "booking"){
      if(DateTime.now().hour > getActualHour(currentTime) && DateTime.now().year == timePicked.year && DateTime.now().month == timePicked.month && DateTime.now().day == timePicked.day){
        currentDayTimings.remove(currentTime);
      }
      else if(DateTime.now().hour == getActualHour(currentTime) && DateTime.now().minute >  getMinute(currentTime) && DateTime.now().year == timePicked.year && DateTime.now().month == timePicked.month && DateTime.now().day == timePicked.day){
        currentDayTimings.remove(currentTime);
      }
      else{
        currentDayTimings.add(currentTime);
        timingsMapping[currentTime] = true;
      }
    }
    else{
      currentDayTimings.add(currentTime);
      timingsMapping[currentTime] = true;
    }


    currentMinute += minuteGap;
    if(currentMinute == 60){
      if(currentHour == 12){
        currentHour = 1;
      }
      else{
        currentHour++;
        if(currentHour == 12){
          if(currentEnd == "AM"){
            currentEnd = "PM";
          }
          else{
            currentEnd = "AM";
          }
        }
      }
      currentMinute = 0;
    }
    currentTime = "$currentHour:${currentMinute < 10?"0$currentMinute":currentMinute} $currentEnd";
    if(currentTime == endTime){
      finished = true;
    }
  }

  if(currentDayTimings.length > 1 && timeType == "start"){
    currentDayTimings.remove(currentDayTimings[currentDayTimings.length-1]);
  }

  return currentDayTimings;
}

List<String> filterTimings(AsyncSnapshot<dynamic> snapshot, int mentorIndex, List<String> timings, var selectedDay){

  List<dynamic> bookings = snapshot.data[0]['$mentorIndex']['bookings'];
  int bookingIndex = 0;
  while(bookingIndex < bookings.length) {
    if (timingsMapping[bookings[bookingIndex]['booking-time']] != null) {
      if (selectedDay.year == bookings[bookingIndex]['booking-year']) {
        if (selectedDay.month == bookings[bookingIndex]['booking-month']) {
          if (selectedDay.day == bookings[bookingIndex]['booking-day']) {
            timings.remove(bookings[bookingIndex]['booking-time']);
          }
        }
      }
    }
    bookingIndex++;
  }

  return timings;
}

String getEnd(String time){
  int timeIndex = 0;
  while(timeIndex < time.length){
    if(time[timeIndex] == "P"){
      return "PM";
    }
    else if(time[timeIndex] == "A"){
      return "AM";
    }
    timeIndex++;
  }
  return "";
}

int getHour(String time){
  int timeIndex = 0;
  String hour = "";
  while(timeIndex < time.length){
    if(time[timeIndex] == ':'){
      return int.parse(hour);
    }
    hour += time[timeIndex];
    timeIndex++;
  }
  return 0;
}

int getActualHour(String time){
  int timeIndex = 0;
  String hour = "";
  while(timeIndex < time.length){
    if(time[timeIndex] == ':'){
      if(getEnd(time) == "AM"){
        return int.parse(hour);
      }
      else{
        return hour == "12"?int.parse(hour):int.parse(hour) + 12;
      }
    }
    hour += time[timeIndex];
    timeIndex++;
  }
  return 0;
}

int getMinute(String time){
  int timeIndex = 0;
  String minute = "";
  bool startAdding = false;
  while(timeIndex < time.length){
    if(time[timeIndex] == ':'){
      startAdding = true;
    }
    else if(time[timeIndex] == " "){
      if(minute[0] == "0"){
        return int.parse(minute[1]);
      }
      else{
        return int.parse(minute);
      }

    }
    else if(startAdding){
      minute += time[timeIndex];
    }
    timeIndex++;
  }
  return 0;
}

String getWeekDay(DateTime timePicked){
  final dateFormat = DateFormat('EEEE yyyy-MMMM-dd');
  var currentDateInWords = dateFormat.format(timePicked);
  String weekDay = "";
  int letterIdx = 0;
  while(letterIdx < currentDateInWords.length){
    if(currentDateInWords[letterIdx] != ' '){
      weekDay += currentDateInWords[letterIdx];
    }
    else{
      break;
    }
    letterIdx++;
  }
  return weekDay;
}