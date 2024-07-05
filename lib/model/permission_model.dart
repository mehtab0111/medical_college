class Permission {
  String name;
  int permission;

  Permission({
    required this.name,
    required this.permission,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      name: json['name'],
      permission: json['permission'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'permission': permission,
    };
  }
}

class Entity {
  int id;
  String name;
  List<Permission> permissions;

  Entity({
    required this.id,
    required this.name,
    required this.permissions,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['id'],
      name: json['name'],
      permissions: (json['permission'] as List)
          .map((permission) => Permission.fromJson(permission))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'permission': permissions.map((permission) => permission.toJson()).toList(),
    };
  }
}
