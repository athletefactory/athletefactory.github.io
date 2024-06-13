import 'dart:convert';

import 'package:http/http.dart' as http;

class EmailService{

  static Future sendRequestEmail(String name, String email, String subject, String message) async {

    final serviceId = 'service_x485dvw';
    final templateId = 'template_g0rngdl';
    final userId = 'Dz9bpx1d9Fj3ekJxG';

    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_name': name,
            'user_email': email,
            'user_subject': subject,
            'user_message': message,
          }
        }),
    );
    print(response.body);
  }

  static Future sendBookingConfirmationEmailToCustomer(String name, String mentorName, String email, String date, String time,) async {

    final serviceId = 'service_x485dvw';
    final templateId = 'template_6ksbkuj';
    final userId = 'Dz9bpx1d9Fj3ekJxG';

    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'to_name': name,
          'mentor_name': mentorName,
          'to_email': email,
          'date': date,
          'time': time,
        }
      }),
    );
    print(response.body);
  }

}