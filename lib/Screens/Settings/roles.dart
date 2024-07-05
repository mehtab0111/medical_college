import 'dart:async';
import 'dart:convert';
import 'package:medical_college/Components/util.dart';
import 'package:medical_college/Services/apiData.dart';
import 'package:medical_college/Theme/style.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RolesAndPermission extends StatefulWidget {
  const RolesAndPermission({super.key});

  @override
  State<RolesAndPermission> createState() => _RolesAndPermissionState();
}

class _RolesAndPermissionState extends State<RolesAndPermission> {

  final StreamController _streamController = StreamController();
  final StreamController _streamController2 = StreamController();

  @override
  void initState() {
    super.initState();
    getMenuForUpdate();
    getRolesAndPermissionForUpdate();
  }

  Future<String> getRolesAndPermissionForUpdate() async {
    String url = APIData.getRolesAndPermissionForUpdate;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = await jsonDecode(response.body);
      if(!_streamController.isClosed) {
        _streamController.add(jsonData['data']);
      }
      // print(jsonData);
    } else {
      print(response.statusCode);
      print(response.body);
    }
    return 'Success';
  }

  Future<String> getMenuForUpdate() async {
    String url = APIData.getMenuForUpdate;
    var response = await http.get(Uri.parse(url), headers: APIData.kHeader);
    if(response.statusCode == 200){
      var jsonData = await jsonDecode(response.body);
      if(!_streamController2.isClosed) {
        _streamController2.add(jsonData['data']);
      }
      // print(jsonData);
    } else {
      print(response.statusCode);
      print(response.body);
    }
    return 'Success';
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _streamController2.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ROLES AND PERMISSION'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Menu Permission', style: kHeaderStyle(),),
            StreamBuilder(
              stream: _streamController2.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var data = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      return ExpansionTileCard(
                        title: Text('${data[index]['name']}'),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            itemCount: data[index]['permission'].length,
                            itemBuilder: (context, ind){
                              var permission = data[index]['permission'];
                              return Row(
                                children: [
                                  Expanded(child: Text('${permission[ind]['name']}')),
                                  CupertinoSwitch(
                                    value: permission[ind]['permission'] == 1 ? true : false,
                                    onChanged: (value){
                                      updateMenuManagement('${permission[ind]['id']}');
                                      setState(() {
                                        permission[ind]['permission'] = !value;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                return LoadingIcon();
              }
            ),
            kSpace(),
            Text('Internal Permission', style: kHeaderStyle(),),
            StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var data = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      return ExpansionTileCard(
                        title: Text('${data[index]['name']}'),
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: data[index]['role'].length,
                            itemBuilder: (context, ind){
                              var role = data[index]['role'];
                              return ExpansionTileCard(
                                title: Text('${role[ind]['name']}'),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    itemCount: role[ind]['permission'].length,
                                    itemBuilder: (context, ind2){
                                      var permission = role[ind]['permission'];
                                      return Row(
                                        children: [
                                          Expanded(child: Text('${permission[ind2]['name']}')),
                                          CupertinoSwitch(
                                            value: permission[ind2]['permission'] == 1 ? true : false,
                                            onChanged: (value){
                                              updateRoleAndPermissions('${permission[ind2]['id']}');
                                              setState(() {
                                                permission[ind2]['permission'] = !value;
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return Divider();
                            },
                          )
                        ],
                      );
                    },
                  );
                }
                return LoadingIcon();
              }
            ),
          ],
        ),
      )
    );
  }

  Future<String> updateMenuManagement(String id) async {
    String url = APIData.updateMenuManagement;
    var response = await http.get(Uri.parse('$url/$id'), headers: APIData.kHeader);
    if(response.statusCode == 200){
      print('success');
      getMenuForUpdate();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }

  Future<String> updateRoleAndPermissions(String id) async {
    String url = APIData.updateRoleAndPermissions;
    var response = await http.get(Uri.parse('$url/$id'), headers: APIData.kHeader);
    if(response.statusCode == 200){
      print('success');
      getRolesAndPermissionForUpdate();
    } else {
      print(response.statusCode);
    }
    return 'Success';
  }
}
