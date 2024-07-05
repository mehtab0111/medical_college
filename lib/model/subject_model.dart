class Subject{
  int id;
  String name;
  String subjectCode;

  Subject({
    required this.id,
    required this.name,
    required this.subjectCode,
  });

  factory Subject.fromJson(Map<String, dynamic> json){
    return Subject(
      id: json['id'],
      name: json['name'],
      subjectCode: json['subject_code'],
    );
  }
}