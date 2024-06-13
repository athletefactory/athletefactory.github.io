import 'package:flutter/cupertino.dart';

class Mentor{
  late String name;
  late int index;
  late String country;
  late String college;
  late String description;
  late List<dynamic> services;

  void createMentor(AsyncSnapshot<dynamic> snapshot, dynamic mentor, int mentorIndex){
    index = mentor;
    name = snapshot.data[3]['$mentor']['user-name'];
    college = snapshot.data[3]['$mentor']['college'];
    country = snapshot.data[3]['$mentor']['country'];
    services = snapshot.data[3]['$mentor']['main-mentorship-services'];
    description = snapshot.data[3]['$mentor']['description'];
  }
}