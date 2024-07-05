import 'package:flutter/material.dart';

class Session{
  int id;
  String name;
  int franchiseId;

  Session({
    required this.id,
    required this.name,
    required this.franchiseId,
  });

  factory Session.fromJson(Map<String, dynamic> json){
    return Session(
      id: json['id'],
      name: '${json['name']}',
      franchiseId: json['franchise_id'],
    );
  }
}