
class Agent{
  int id;
  String identificationNo;
  String firstName;
  String middleName;
  String lastName;

  Agent({
    required this.id,
    required this.identificationNo,
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  factory Agent.fromJson(Map<String, dynamic> json){
    return Agent(
      id: json['id'],
      identificationNo: json['identification_no'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
    );
  }
}