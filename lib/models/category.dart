import 'dart:typed_data';
import 'package:athlete_factory/models/mentor.dart';
import 'package:athlete_factory/models/user.dart';
import 'package:athlete_factory/services/database.dart';
import 'package:flutter/cupertino.dart';

class CategoryClass {

  static late String name;
  static late int index;
  static bool imagesRendered = false;
  static late List<Mentor> mentors = [];
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

  static void setCategoryInfo(AsyncSnapshot<dynamic> snapshot, List<dynamic> categories, int categoryIndex, CustomerUser customer) async {
    List<Mentor> currentMentors = [];
    dynamic mentors = snapshot.data[1]['${categories[categoryIndex]}']['mentors'];

    int mentorIndex = 0;
    while(mentorIndex < mentors.length){
      if(snapshot.data[2][snapshot.data[3]['${mentors[mentorIndex]}']['user-email']]['enabled'] && snapshot.data[2][snapshot.data[3]['${mentors[mentorIndex]}']['user-email']]['gender'] == customer.getGender()){
        Mentor mentor = Mentor();
        mentor.createMentor(snapshot, mentors[mentorIndex], mentorIndex);
        currentMentors.add(mentor);
      }
      mentorIndex++;
    }

    CategoryClass.name = snapshot.data[1]['${categories[categoryIndex]}']['category-name'];
    CategoryClass.mentors = currentMentors;
    CategoryClass.index = categories[categoryIndex];
    await Database().updateCustomerSelectedCategoryToBookIn(customer.getEmail(), categories[categoryIndex]);


  }

}