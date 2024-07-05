import 'package:medical_college/model/semester_model.dart';

class Course{
  int id;
  String courseName;
  int duration;
  List<Semester> semester;

  Course({
    required this.id,
    required this.courseName,
    required this.duration,
    required this.semester,
  });

  factory Course.fromJson(Map<String, dynamic> json){
    return Course(
      id: json['id'],
      courseName: json['course_name'],
      duration: json['duration'],
      semester: (json['semester'] as List)
          .map((item) => Semester.fromJson(item))
          .toList(),
    );
  }
}
