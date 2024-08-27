
import 'package:flutter/material.dart';
import 'package:untitled3/api.dart';

import 'model.dart';


class Details extends StatelessWidget {

  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    Model model = Service().model.value;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Hero(
              tag: model.name?.replaceAll(" ", "")??"tag",
              child: CircleAvatar(
                minRadius: 70,
                child: Icon(Icons.person, color: Colors.grey[600], size: 90,),
              ),
            ),

            SizedBox(height: 30,),
            Text(model.name??"", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Colors.grey[800]),),

            SizedBox(height: 40,),

            itemValue("Username",model.username??"",),
            itemValue("Phone",model.phone??"",),
            itemValue("Email",model.email??"",),
            itemValue("Address",model.address?.street??"",),
            itemValue("Website",model.website??"",),
            itemValue("Company",model.company?.name??"",),
          ],
        ),
      ),
    );
  }


  Widget itemValue(String title, String value){
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(width: 0.5, color: Colors.grey[300]!))),

      child: Row(
        children: [
          Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 14),),
          Spacer(),
          Text(value, style: TextStyle(color: Colors.grey[800], fontSize: 16, ),),
        ],
      ),
    );
  }

}
