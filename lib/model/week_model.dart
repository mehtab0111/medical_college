class WeekModel {
  int id;
  String name;

  WeekModel({
    required this.id,
    required this.name,
  });

  factory WeekModel.fromJson(Map<String, dynamic> json){
    return WeekModel(
      id: json['id'],
      name: json['name'],
    );
  }
}