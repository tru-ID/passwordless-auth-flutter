class PhoneCheck {
  final String id;
  final String url;

  PhoneCheck({required this.id, required this.url});

  factory PhoneCheck.fromJson(Map<dynamic, dynamic> json) {
    return PhoneCheck(
      id: json['check_id'],
      url: json['check_url'],
    );
  }
}

class PhoneCheckResult {
  final String id;
  bool match = false;

  PhoneCheckResult({required this.id, required this.match});

  factory PhoneCheckResult.fromJson(Map<dynamic, dynamic> json) {
    return PhoneCheckResult(
      id: json['check_id'],
      match: json['match'] ?? false,
    );
  }
}
