import 'dart:typed_data';
import 'package:athlete_factory/models/mentor.dart';
import 'package:athlete_factory/models/user.dart';
import 'package:flutter/cupertino.dart';

import '../functions/image_functions.dart';
import '../services/database.dart';

class Sport{

  static List<Uint8List> mentorImagesBytes = [];
  static late String name;
  static late int index;
  static bool imagesRendered = false;
  static List<Mentor> mentors = [];
  static late List<Uint8List> imageBytes;

  static List<String> getNames(){
    List<String> names = [];

    int index = 0;
    while(index < mentors.length){
      names.add(mentors[index].name);
      index++;
    }

    return names;
  }

  static void setSportInfo(AsyncSnapshot<dynamic> snapshot, List<dynamic> sports, int sportIndex, CustomerUser customer) async {
    List<Mentor> currentMentors = [];
    dynamic mentors = snapshot.data[0]['${sports[sportIndex]}']['mentors'];
    int mentorIndex = 0;

    while(mentorIndex < mentors.length){
      if(snapshot.data[2][snapshot.data[3]['${mentors[mentorIndex]}']['user-email']]['enabled'] && snapshot.data[2][snapshot.data[3]['${mentors[mentorIndex]}']['user-email']]['gender'] == customer.getGender()){
        Mentor mentor = Mentor();
        mentor.createMentor(snapshot, mentors[mentorIndex], mentorIndex);
        currentMentors.add(mentor);
      }
      mentorIndex++;
    }

    Sport.name = snapshot.data[0]['${sports[sportIndex]}']['sport-name'];
    Sport.index = sports[sportIndex];
    Sport.mentors = currentMentors;
    await Database().updateCustomerSelectedSportToBookIn(customer.getEmail(), sports[sportIndex]);
  }
}