
class MenuManagement {
  int id;
  int userTypeId;
  int groups;
  String name;
  bool permission;
  int franchiseId;
  String createdAt;
  String updatedAt;

  MenuManagement({
    required this.id,
    required this.userTypeId,
    required this.groups,
    required this.name,
    required this.permission,
    required this.franchiseId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuManagement.fromJson(Map<String, dynamic> json){
    return MenuManagement(
      id: json['id'],
      userTypeId: json['user_type_id'],
      groups: json['groups'],
      name: json['name'],
      permission: json['permission']  == 1 ? true : false,
      franchiseId: json['franchise_id'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}