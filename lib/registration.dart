import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tru_sdk_flutter/tru_sdk_flutter.dart';
import 'package:passwordless_auth_flutter/models.dart';
import 'package:http/http.dart' as http;

final String baseURL = '{YOUR_NGROK_URL}';

class Registration extends StatefulWidget {
  Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

Future<PhoneCheck?> createPhoneCheck(String phoneNumber) async {
  final response = await http.post(Uri.parse('$baseURL/v0.2/phone-check'),
      body: {"phone_number": phoneNumber});

  if (response.statusCode != 200) {
    return null;
  }

  PhoneCheck phoneCheck = PhoneCheck.fromJson(jsonDecode(response.body));

  return phoneCheck;
}

Future<void> errorHandler(BuildContext context, String title, String content) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
      });
}

Future<void> successHandler(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
      });
}

class _RegistrationState extends State<Registration> {
  String? phoneNumber;
  bool loading = false;

  Future<TokenResponse> getCoverageAccessToken() async {
    final response = await http.get(
      Uri.parse('$baseURL/coverage-access-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return TokenResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get coverage access token: No access token');
    }
  }

  Future<PhoneCheckResult> exchangeCode(
      String checkID, String code, String? referenceID) async {
    var body = jsonEncode(<String, String>{
      'code': code,
      'check_id': checkID,
      'reference_id': (referenceID != null) ? referenceID : ""
    });

    final response = await http.post(
      Uri.parse('$baseURL/v0.2/phone-check/exchange-code'),
      body: body,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
      },
    );
    print("response request ${response.request}");
    if (response.statusCode == 200) {
      PhoneCheckResult exchangeCheckRes =
          PhoneCheckResult.fromJson(jsonDecode(response.body));
      print("Exchange Check Result $exchangeCheckRes");
      if (exchangeCheckRes.match) {
        print("✅ successful PhoneCheck match");
      } else {
        print("❌ failed PhoneCheck match");
      }
      return exchangeCheckRes;
    } else {
      throw Exception('Failed to exchange Code');
    }
  }

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });

                    TruSdkFlutter sdk = TruSdkFlutter();

                    var tokenResponse = await getCoverageAccessToken();
                    var token = tokenResponse.token;
                    var url = tokenResponse.url;

                    Map reach = await sdk.openWithDataCellularAndAccessToken(
                        url, token, true);
                    print("isReachable = $reach");
                    bool isPhoneCheckSupported = false;

                    if (reach.containsKey("http_status") &&
                        reach["http_status"] != 200) {
                      if (reach["http_status"] == 400 ||
                          reach["http_status"] == 412) {
                        return errorHandler(context, "Something Went Wrong.",
                            "Mobile Operator not supported, or not a Mobile IP.");
                      }
                    } else if (reach.containsKey("http_status") ||
                        reach["http_status"] == 200) {
                      Map body =
                          reach["response_body"] as Map<dynamic, dynamic>;
                      Coverage coverage = Coverage.fromJson(body);

                      for (var product in coverage.products!) {
                        if (product.name == "Phone Check") {
                          isPhoneCheckSupported = true;
                        }
                      }
                    } else {
                      isPhoneCheckSupported = true;
                    }

                    if (!isPhoneCheckSupported) {
                      return errorHandler(context, "Something went wrong.",
                          "PhoneCheck is not supported on MNO.");
                    }

                    final PhoneCheck? phoneCheckResponse =
                        await createPhoneCheck(phoneNumber!);

                    if (phoneCheckResponse == null) {
                      setState(() {
                        loading = false;
                      });

                      return errorHandler(context, 'Something went wrong.',
                          'Phone number not supported');
                    }

                    Map result = await sdk.openWithDataCellular(
                        phoneCheckResponse.url, false);
                    print("openWithDataCellular Results -> $result");

                    if (result.containsKey("error")) {
                      setState(() {
                        loading = false;
                      });

                      errorHandler(context, "Something went wrong.",
                          "Failed to open Check URL.");
                    }

                    if (result.containsKey("http_status") &&
                        result["http_status"] == 200) {
                      Map body =
                          result["response_body"] as Map<dynamic, dynamic>;
                      if (body["code"] != null) {
                        CheckSuccessBody successBody =
                            CheckSuccessBody.fromJson(body);

                        try {
                          PhoneCheckResult exchangeResult = await exchangeCode(
                              successBody.checkId,
                              successBody.code,
                              successBody.referenceId);

                          if (exchangeResult.match) {
                            setState(() {
                              loading = false;
                            });

                            return successHandler(context);
                          } else {
                            setState(() {
                              loading = false;
                            });

                            return errorHandler(
                                context,
                                "Something went wrong.",
                                "Unable to login. Please try again later");
                          }
                        } catch (error) {
                          setState(() {
                            loading = false;
                          });

                          return errorHandler(context, "Something went wrong.",
                              "Unable to login. Please try again later");
                        }
                      }
                    }
                  },
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TokenResponse {
  final String token;
  final String url;
  TokenResponse({required this.token, required this.url});
  factory TokenResponse.fromJson(Map<dynamic, dynamic> json) {
    return TokenResponse(token: json['token'], url: json['url']);
  }
}
