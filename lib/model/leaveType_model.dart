import 'package:flutter/material.dart';

class LeaveType{
  int id;
  String name;
  int franchiseId;

  LeaveType({
    required this.id,
    required this.name,
    required this.franchiseId,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json){
    return LeaveType(
      id: json['id'],
      name: json['name'],
      franchiseId: json['franchise_id'],
    );
  }
}