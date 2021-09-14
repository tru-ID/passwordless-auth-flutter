import 'package:flutter/material.dart';
import 'package:passwordless_auth_flutter/models.dart';
import 'package:http/http.dart' as http;
import 'package:tru_sdk_flutter/tru_sdk_flutter.dart';

final String baseURL = '<YOUR-LOCAL-TUNNEL-URL>';

class Registration extends StatefulWidget {
  Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

Future<PhoneCheck?> createPhoneCheck(String phoneNumber) async {
  final response = await http.post(Uri.parse('$baseURL/phone-check'),
      body: {"phone_number": phoneNumber});

  if (response.statusCode != 201) {
    return null;
  }
  final String data = response.body;

  return phoneCheckFromJSON(data);
}

Future<PhoneCheckResult?> getPhoneCheck(String checkId) async {
  final response =
      await http.get(Uri.parse('$baseURL/phone-check?check_id=$checkId'));

  if (response.statusCode != 200) {
    return null;
  }

  final String data = response.body;

  return phoneCheckResultFromJSON(data);
}

class _RegistrationState extends State<Registration> {
  String? phoneNumber;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 45.0),
                margin: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/images/tru-id-logo.png',
                )),
            Container(
                width: double.infinity,
                child: const Text(
                  'Register.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    setState(() {
                      phoneNumber = text;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your phone number.',
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:const  EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: TextButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final PhoneCheck? phoneCheckResponse =
                          await createPhoneCheck(phoneNumber!);

                      if (phoneCheckResponse == null) {
                        setState(() {
                          loading = false;
                        });
                        AlertDialog(
                          title: const Text('Something Went Wrong.'),
                          content: const Text('Phone number not supported.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                        return;
                        // return dialog
                      }
                      // open check URL
                      TruSdkFlutter sdk = TruSdkFlutter();

                      await sdk.check(phoneCheckResponse.checkUrl);

                      final PhoneCheckResult? phoneCheckResult =
                          await getPhoneCheck(phoneCheckResponse.checkId);

                      if (phoneCheckResult == null) {
                        // return dialog
                        AlertDialog(
                          title: const Text('Something Went Wrong.'),
                          content: const Text('Please contact support.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                        return;
                      }

                      if (phoneCheckResult.match) {
                        // set loading to false  and show dialog
                        setState(() {
                          loading = false;
                        });
                        AlertDialog(
                          title: const Text('Registration Successful.'),
                          content: const Text('✅'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        );

                        return;
                      } else {
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: loading ? const CircularProgressIndicator() : const Text('Register')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
