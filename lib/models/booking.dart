
class Booking{
  static int bookingAmount = 0;
  late int mentorIndex;
  late int customerIndex;
  late List<dynamic> mentorBookings;
  late List<dynamic> customerBookings;
  late List<dynamic> adminBookings;

  void addBooking(int mentorIdx, int customerIdx, List<dynamic> mentorBookngs,  List<dynamic> customerBookngs,  List<dynamic> adminBookngs){
    if(bookingAmount == 0){
      mentorIndex = mentorIdx;
      customerIndex = customerIdx;
      mentorBookings = mentorBookngs;
      customerBookings = customerBookngs;
      adminBookings = adminBookngs;
      bookingAmount = 1;
    }
  }

  void removeBooking(){
    bookingAmount = 0;
    mentorIndex = 0;
    customerIndex = 0;
    mentorBookings = [];
    customerBookings = [];
    adminBookings = [];
  }


}