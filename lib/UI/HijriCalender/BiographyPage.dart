import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:islamic_app/Api_Model/Biography_Model.dart';

class Biography extends StatelessWidget{
  final id;

  Biography({required this.id});


  Future<BiographyModel?> loadBiographyById(String personId) async {
       final String response = await rootBundle.loadString('assets/personalities.json');
       final List data = jsonDecode(response);
       for (var item in data) {
         if (item['id'] == personId) {
            return BiographyModel.fromJson(item);
          }
       }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(id), centerTitle: true,),
      body: FutureBuilder<BiographyModel?>(
         future: loadBiographyById(id),
         builder: (context, snaphot){
           if(snaphot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
           }
           if(!snaphot.hasData){
              return Center(child: Text('No Data available'));
           }

           final bio = snaphot.data!;
           return Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: [
                 Text('${bio.id}'),
                 SizedBox(height: 10),
                 Text('${bio.birth}'),
                 SizedBox(height: 10),
                 Text('${bio.death}'),
                 SizedBox(height: 20),
                 Text('${bio.biography}'),
              ],
            ),
          
           );

         },
      ),
    );
  }
}