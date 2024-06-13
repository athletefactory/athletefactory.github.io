
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../functions/check_user_type.dart';

class UserClass {
  late String email;
  late String name;
  String gender = "";
  late int index = 0;
  late int selectedMentorIndex;
  late int bookingDay;
  late int bookingMonth;
  late int bookingYear;
  late int bookingId;
  late String bookingTime;
  String mentorName = "";

  static bool loggedIn = false;
  static bool refresh = true;
  static bool refreshing = true;
  static late String type;

  UserClass(this.email);

  void setEmail(String email){
    this.email = email;
  }

  String getEmail(){
    return email;
  }

  int getBookingDay(){
    return bookingDay;
  }

  int getBookingId(){
    return bookingId;
  }

  int getBookingMonth(){
    return bookingMonth;
  }

  int getBookingYear(){
    return bookingYear;
  }

  String getBookingTime(){
    return bookingTime;
  }

  void setIndex(int index){
    this.index = index;
  }

  int getIndex(){
    return index;
  }

  int getMentorIndex(){
    return selectedMentorIndex;
  }

  String getGender(){
    return gender;
  }

  String getName(){
    return name;
  }

  String getMentorName(){
    return mentorName;
  }

  Future<void> setInfo() async {

    // Get a reference to the document
    DocumentReference docRef = FirebaseFirestore.instance.collection('Database').doc('Users');
    // Get the document
    DocumentSnapshot docSnapshot = await docRef.get();
    // Check if the document exists
    if (docSnapshot.exists) {
      // Get the data from the document
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      // Get the specific value you're interested in
      email = currentUserEmail;
      type = data[currentUserEmail]['user-type'];
      index = data[currentUserEmail]['user-index'];
      gender = data[currentUserEmail]['gender'];
      name = data[currentUserEmail]['user-name'];
      if(type == "customer"){
        if(data[currentUserEmail]['booking-day'] != null && data[currentUserEmail]['booking-month'] != null && data[currentUserEmail]['booking-year'] != null && data[currentUserEmail]['booking-time'] != null){
          bookingDay = data[currentUserEmail]['booking-day'];
          bookingMonth = data[currentUserEmail]['booking-month'];
          bookingYear = data[currentUserEmail]['booking-year'];
          bookingTime = data[currentUserEmail]['booking-time'];
          bookingId = data[currentUserEmail]['booking-id'];
        }
        selectedMentorIndex = data[currentUserEmail]['selected-mentor-index'];
        mentorName = data[currentUserEmail]['booking-mentor-name'];
      }
    } else {
      print('Document does not exist');
    }
  }

  Future<Map<String, dynamic>> fetchDocument(String docId) async {
    DocumentReference docRef = FirebaseFirestore.instance.collection('Database').doc(docId);
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      return docSnapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document $docId does not exist');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMultipleDocuments(List<String> docIds) {
    return Future.wait(docIds.map((docId) => fetchDocument(docId)));
  }

  Future<void> getSportsData(Function setState, ) async {

    try{
      List<String> docIds = ['Sports', 'Categories', 'Users', 'Mentors'];
      List<Map<String, dynamic>> documents = await fetchMultipleDocuments(docIds);
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot = AsyncSnapshot.withData(ConnectionState.done, documents);
      //Sport.setSportInfo(snapshot, sports, sportIndex, customer);
    }
    catch (e) {
      print('Error fetching documents: $e');
      // Create an AsyncSnapshot with the error
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot = AsyncSnapshot.withError(ConnectionState.done, e);

      // Call another function and pass the snapshot
    }

  }

}

class CustomerUser extends UserClass {

  late int selectedMentor;
  static CustomerUser? _customer;

  CustomerUser._internal(String email):super(email);

  // Factory method to get or create the single instance of Customer
  factory CustomerUser(String email) {
    // If _customer is null, create a new Customer instance
    _customer ??= CustomerUser._internal(email);
    // Return the single instance of Customer
    return _customer!;
  }

  // Method to reset the singleton instance
  static void resetInstance() {
    _customer = null;
  }

  void setSelectedMentor(int selectedMentor){
    this.selectedMentor = selectedMentor;
  }

  int getSelectedMentor(){
    return selectedMentor;
  }

}

class MentorUser extends UserClass {

  bool timeAdjusted = false;
  bool dataIsNotSetup = true;
  List<dynamic> bookings = [];
  static MentorUser? _mentor;

  MentorUser._internal(String email):super(email);
  factory MentorUser(String email) {
    // If _mentor is null, create a new Mentor instance
    _mentor ??= MentorUser._internal(email);
    // Return the single instance of Mentor
    return _mentor!;
  }

  // Getter for dataIsSetup
  bool getDataIsNotSetup() {
    return dataIsNotSetup;
  }

  // Setter for dataIsSetup
  void setDataIsNotSetup(bool newValue) {
    dataIsNotSetup = newValue;
  }

  bool getTimeAdjusted() {
    return timeAdjusted;
  }

  void setTimeAdjusted(bool newValue) {
    timeAdjusted = newValue;
  }

  // Getter for bookings
  List<dynamic> getBookings() {
    return bookings;
  }

  dynamic getBooking(int index){
    return bookings[index];
  }

  // Setter for bookings
  void setBookings(List<dynamic> newValue) {
    bookings = newValue;
  }

  // Method to reset the singleton instance
  static void resetInstance() {
    _mentor = null;
  }

}

