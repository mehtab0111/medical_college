
class Cast {
  int id;
  String name;

  Cast({
    required this.id,
    required this.name,
  });

  factory Cast.fromJson(Map<String, dynamic> json){
    return Cast(
      id: json['id'],
      name: json['name'],
    );
  }
}