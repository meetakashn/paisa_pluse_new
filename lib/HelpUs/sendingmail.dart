
import 'package:flutter_email_sender/flutter_email_sender.dart';

Future<void> sendHelpRequest(String subject, String body) async {
  final Email email = Email(
    body: body,
    subject: subject,
    recipients: ['akashnoffical03@gmail.com'],
  );
  await FlutterEmailSender.send(email);
}
