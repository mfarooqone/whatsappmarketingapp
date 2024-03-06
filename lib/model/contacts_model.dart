class ContactModel {
  String? displayName;
  List<String>? phones;

  ContactModel({this.displayName, this.phones});

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'phones': phones,
    };
  }

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      displayName: json['displayName'],
      phones: json['phones'] != null ? List<String>.from(json['phones']) : null,
    );
  }
}
