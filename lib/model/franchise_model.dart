
class FranchiseModel {
  int id;
  String name;
  bool status;

  FranchiseModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory FranchiseModel.fromJson(Map<String, dynamic> json) {
    return FranchiseModel(
      id: json['id'],
      name: json['name'],
      status: json['status'] == 1 ? true : false,
    );
  }
}