import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pherico/config/config.dart';

//200/m Quoto only

class MyMailer {
  static Future<void> sendMail() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
     await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': Config.serviceIdMailgun,
          'template_id': Config.templateId,
          'user_id': Config.userId,
          'template_params': {
            'subject': 'OTP to reset password',
            'message': 'Use this OTP to reset your password',
            'send_to': 'gopichand0215@gmail.com'
          }
        }),
      );
    
    } catch (e) {
     //todo
    }
  }

  static Future<void> sendOtpMail(int otp, String email) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': Config.serviceIdMailgun,
          'template_id': Config.templateId,
          'user_id': Config.userId,
          'template_params': {
            'subject': 'OTP to reset password',
            'message': 'Use this OTP to reset your password - $otp',
            'send_to': email
          }
        }),
      );
      
    } catch (e) {
      // todo
    }
  }
}
