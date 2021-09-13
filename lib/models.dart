import 'dart:convert';
// function for converting from JSON to an object (or map)

PhoneCheck phoneCheckFromJSON(String jsonString) =>
    PhoneCheck.fromJson(json.decode(jsonString));

PhoneCheckResult phoneCheckResultFromJSON(String jsonString) =>
    PhoneCheckResult.fromJson(json.decode(jsonString));

class PhoneCheck {
  String checkId;
  String checkUrl;

  PhoneCheck({required this.checkId, required this.checkUrl});

  factory PhoneCheck.fromJson(Map<String, dynamic> json) => PhoneCheck(
        checkId: json["check_id"],
        checkUrl: json["check_url"],
      );
}

class PhoneCheckResult {
  bool match;

  PhoneCheckResult({required this.match});

  factory PhoneCheckResult.fromJson(Map<String, dynamic> json) =>
      PhoneCheckResult(match: json["match"]);
}
