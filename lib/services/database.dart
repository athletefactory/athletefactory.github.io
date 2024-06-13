import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

final CollectionReference database = FirebaseFirestore.instance.collection('Database');

Future<Map<String, dynamic>?> adminData() async {
  return (await FirebaseFirestore.instance.collection('Database').doc('Admin').get()).data();
}

Future<Map<String, dynamic>?> mentorAccountsData() async {
  return (await FirebaseFirestore.instance.collection('Database').doc('Mentors').get()).data();
}

Future<Map<String, dynamic>?> customerAccountsData() async {
  return (await FirebaseFirestore.instance.collection('Database').doc('Customers').get()).data();
}

Future<Map<String, dynamic>?> userAccountsData() async {
  return (await FirebaseFirestore.instance.collection('Database').doc('Users').get()).data();
}

Future<Map<String, dynamic>?> categoriesData() async {
  return (await FirebaseFirestore.instance.collection('Database').doc('Categories').get()).data();
}

Future<Map<String, dynamic>?> sportsData() async {
  return (await FirebaseFirestore.instance.collection('Database').doc('Sports').get()).data();
}


class Database{

  /*
  static final Database db = Database._internal();
  Database._internal();

  factory Database() {
    return db;
  }

  static late CollectionReference _firestoreDbCollection;

  static Future<void> initialize() async {
    _firestoreDbCollection = FirebaseFirestore.instance.collection('Database');
  }

  static CollectionReference getDbCollection() {
    return _firestoreDbCollection;
  }
  */


  Future addMentor(int userIndex, String userName, String userEmail, List<String> mainSports, List<String> mainMentorshipServices, String country, String college, String description, String gender) async {
    return await database.doc('Mentors').set({
      '$userIndex' : {
        'id': userIndex,
        'user-name': userName,
        'country': country,
        'college': college,
        'gender': gender,
        'description': description,
        'timing-adjusted': "false",
        'user-email': userEmail,
        'user-notifications': {},
        'user-notification-amount': 0,
        'number-of-reservations': 0,
        'rating': 0,
        'reviews': {},
        'main-sports': mainSports,
        'main-mentorship-services': mainMentorshipServices,
        'space-between-timings': 0,
        'booking-history': {},
        'bookings': [],
        'timings': {
          "Friday": {
            "blocked": [],
            "bookings": [],
            "end-time": "None",
            "start-time": "None",
            "minute-gap": "None",
          },
          "Saturday": {
            "blocked": [],
            "bookings": [],
            "end-time": "None",
            "start-time": "None",
            "minute-gap": "None",
          },
          "Sunday": {
            "blocked": [],
            "bookings": [],
            "end-time": "None",
            "start-time": "None",
            "minute-gap": "None",
          },
          "Monday": {
            "blocked": [],
            "bookings": [],
            "end-time": "None",
            "start-time": "None",
            "minute-gap": "None",
          },
          "Tuesday": {
            "blocked": [],
            "bookings": [],
            "end-time": "None",
            "start-time": "None",
            "minute-gap": "None",
          },
          "Wednesday": {
            "blocked": [],
            "bookings": [],
            "end-time": "None",
            "start-time": "None",
            "minute-gap": "None",
          },
          "Thursday": {
            "blocked": [],
            "bookings": [],
            "end-time": "None",
            "start-time": "None",
            "minute-gap": "None",
          },
        },
      },
      'user-amount': userIndex+1,
    },
      SetOptions(merge: true),
    );
  }

  Future updateMentorServices(int userIndex, List<String> mainMentorshipServices) async {
    return await database.doc('Mentors').set({
      '$userIndex' : {
        'main-mentorship-services': mainMentorshipServices,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future editSelectedDay(String email, String day) async {
    return await database.doc('Users').set({
      email : {
        'selected-day-to-edit': day,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future addCustomerBooking(int userIndex, int mentorIndex, int bookingIndex) async {
    return await database.doc('Customers').set({
      '$userIndex' : {
        'bookings': FieldValue.arrayUnion([{
          'mentor-id': mentorIndex,
          'booking-id': bookingIndex,
        }]),
      },
    },
      SetOptions(merge: true),
    );
  }

  Future addAdminBooking(int userIndex, int mentorIndex, int bookingIndex) async {
    return await database.doc('Admin').set({
      'bookings': FieldValue.arrayUnion([{
        'mentor-id': mentorIndex,
        'booking-id': bookingIndex,
      }]),
    },
      SetOptions(merge: true),
    );
  }

  Future addMentorBooking(int userIndex, dynamic booking) async {
    return await database.doc('Mentors').set({
      '$userIndex' : {
        'bookings': FieldValue.arrayUnion([booking]),
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateBookingExists(int userIndex) async {
    return await database.doc('Customers').set({
      '$userIndex' : {
        'session-to-book': {
          'exists': true,
        },
      },
    },
      SetOptions(merge: true),
    );
  }

  Future removeSessionToBook(int userIndex) async {
    return await database.doc('Customers').set({
      '$userIndex' : {
        'session-to-book': {
          'exists': false,
        },
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateVerified(String email) async {
    return await database.doc('Users').set({
      email : {
        'verified': 'true',
      },
    },
      SetOptions(merge: true),
    );
  }

  Future addTiming(int userIndex, String day, String startTime, String endTime, String minuteGap) async {
    return await database.doc('Mentors').set({
      '$userIndex': {
        'timing-adjusted': "true",
        'timings': {
          day : {
            'start-time': startTime,
            'end-time': endTime,
            'minute-gap': minuteGap,
            'bookings': [],
            'blocked': [],
          },
        },
      },
    },
      SetOptions(merge: true),
    );
  }

  Future addCustomer(int userIndex, String parentName, String userName, String userEmail, List<String> mainSports, List<String> mainMentorshipServices, String gender) async {
    return await database.doc('Customers').set({
      '$userIndex' : {
        'id': userIndex,
        'user-name': userName,
        'user-email': userEmail,
        'parent-name': parentName,
        'selected-sport': "",
        'gender': gender,
        'user-notifications': {},
        'user-notification-amount': 0,
        'main-sports': mainSports,
        'main-mentorship-services': mainMentorshipServices,
        'booking-history': {},
        'bookings': [],
      },
      'user-amount': userIndex+1,
    },
      SetOptions(merge: true),
    );
  }

  Future addUser(int userIndex, String userName, String userEmail, String userType, String gender) async {
    return await database.doc('Users').set({
      userEmail : {
        'verified': 'false',
        'enabled': true,
        'selected-day-to-edit': 'Sunday',
        'selected-mentor-index': 0,
        'user-type': userType,
        'user-index': userIndex,
        'gender': gender,
        'user-name': userName,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateFreeSession(String userEmail) async {
    return await database.doc('Users').set({
      userEmail : {
        'used-free': true,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateMentorName(int userIndex, String name) async {
    return await database.doc('Mentors').set({
      '$userIndex' : {
        'user-name': name,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateSelectedMentor(String customerEmail, int mentorIndex) async {
    return await database.doc('Users').set({
      customerEmail : {
        'selected-mentor-index': mentorIndex,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateCurrentBookingInfo(String customerEmail, int bookingIndex, int day, int month, int year, String time, String mentorName) async {
    return await database.doc('Users').set({
      customerEmail : {
        'booking-day': day,
        'booking-month': month,
        'booking-year': year,
        'booking-time': time,
        'booking-id': bookingIndex,
        'booking-mentor-name': mentorName,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateCustomerName(int userIndex, String name, String type) async {
    return await database.doc('Customers').set({
      '$userIndex' : {
        '$type-name': name,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateCustomerSelectedSportToBookIn(String email, int sport) async {
    return await database.doc('Users').set({
      email : {
        'selected-sport': sport,
      },
    },
      SetOptions(merge: true),
    );
  }



  Future updateCustomerSelectedCategoryToBookIn(String email, int category) async {
    return await database.doc('Users').set({
      email : {
        'selected-category': category,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateMentorDescription(int userIndex, String description) async {
    return await database.doc('Mentors').set({
      '$userIndex' : {
        'description': description,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateSportMentors(int sportIndex, List<dynamic> mentors) async {
    return await database.doc('Sports').set({
      '$sportIndex': {
        'mentors': mentors,
      },
    },
      SetOptions(merge: true),
    );
  }

  Future updateCategoryMentors(int categoryIndex, List<dynamic> mentors) async {
    return await database.doc('Categories').set({
      '$categoryIndex': {
        'mentors': mentors,
      },
    },
      SetOptions(merge: true),
    );
  }


}