import 'dart:convert';

// function for converting from JSON to an object (or map)
PhoneCheck phoneCheckFromJSON(String jsonString) =>
    PhoneCheck.fromJson(jsonDecode(jsonString));

class PhoneCheck {
  String checkId;
  String checkUrl;

  PhoneCheck({required this.checkId, required this.checkUrl});

  factory PhoneCheck.fromJson(Map<String, dynamic> json) => PhoneCheck(
        checkId: json["check_id"],
        checkUrl: json["check_url"],
      );
}

PhoneCheckResult phoneCheckResultFromJSON(String jsonString) =>
    PhoneCheckResult.fromJson(jsonDecode(jsonString));

class PhoneCheckResult {
  bool match;

  PhoneCheckResult({required this.match});

  factory PhoneCheckResult.fromJson(Map<String, dynamic> json) =>
      PhoneCheckResult(match: json["match"]);
}
