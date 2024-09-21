import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../view/bottom_navigation/gmail_page/bmail_sent.dart';


// Define the Email class
class Email {
   String? message_id;
  final String subject;
  final String sender;
  final String body;
  final String date;

  Email( {
     this.message_id,
    required this.subject,
    required this.sender,
    required this.body,
    required this.date,
  });

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      message_id: json['message_id'],
      subject: json['subject'],
      sender: json['from'],
      body: json['body'],
      date: json['date'],
    );
  }
}
