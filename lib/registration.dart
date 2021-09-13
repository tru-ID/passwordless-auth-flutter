import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String? phoneNumber;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(bottom: 45.0),
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    setState(() {
                      phoneNumber = text;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your phone number.',
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: TextButton(
                    onPressed: () async {
                      print('pressed');
                    },
                    child: Text('Register')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
