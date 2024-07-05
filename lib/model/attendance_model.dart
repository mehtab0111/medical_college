class AttendanceModel {
  String userID;
  String firstName;
  String middleName;
  String lastName;
  String attendance;

  AttendanceModel({
    required this.userID,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.attendance,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json){
    return AttendanceModel(
      userID: json['user_id'].toString(),
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      attendance: json['attendance'],
    );
  }
}
