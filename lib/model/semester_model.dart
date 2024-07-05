class Semester{
  int id;
  String name;

  Semester({
    required this.id,
    required this.name,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'],
      name: json['name'],
    );
  }
}
