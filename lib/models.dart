import 'dart:convert';
// function for converting from JSON to an object (or map)

PhoneCheck phoneCheckFromJSON(String jsonString) =>
    PhoneCheck.fromJson(json.decode(jsonString));

PhoneCheckResponse phoneCheckResponseFromJson(String jsonString) =>
    PhoneCheckResponse.fromJson(json.decode(jsonString));

class PhoneCheck {
  String checkId;
  String checkUrl;

  PhoneCheck({required this.checkId, required this.checkUrl});

  factory PhoneCheck.fromJson(Map<String, dynamic> json) => PhoneCheck(
        checkId: json["check_id"],
        checkUrl: json["check_url"],
      );
}

class PhoneCheckResponse {
  String match;

  PhoneCheckResponse({required this.match});

  factory PhoneCheckResponse.fromJson(Map<String, dynamic> json) =>
      PhoneCheckResponse(match: json["match"]);
}
