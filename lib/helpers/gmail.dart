import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Gmail {
  static Future<void> sendMail() async {
    String username = 'pherico.live@gmail.com';
    String password = 'dhhqaumvisnavubn';
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Gopi chand')
      ..recipients.add('Gopichand0215@gmail.com')
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {}
  }
}
