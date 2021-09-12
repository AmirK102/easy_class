import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_class/functions/database_function.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class Schedules extends StatefulWidget {
  const Schedules({Key? key, this.classId, this.userInfo, }) : super(key: key);
  final classId;
  final GoogleSignInAccount? userInfo;
  @override
  _SchedulesState createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Database().addClassSchedules("New Topic", widget.userInfo!.displayName, (DateTime.now()), widget.classId);
        },
        child: Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
          stream: Database().getClassSchedules(widget.classId),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Container();
            }

            print(snapshot.data!.docs.length);
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data=snapshot.data!.docs[index];
                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(7),
                  margin: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data["topic"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(
                        "Added by ${data["added_by"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Ending Date",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(

                                    "Date: ${ DateFormat("yyyy-MM-dd").format((data["time"]  as Timestamp).toDate())}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(

                                    "Time: ${ DateFormat("hh:mm:ss").format((data["time"]  as Timestamp).toDate())}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Remaining time",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    getTime(data["time"]),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }

   getTime(Timestamp time) {
    print(time.toDate());


  // var value= (DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch*1000).difference(DateTime.now()));

  // return daysBetween(DateTime.now().subtract(Duration(days: 300)), time.toDate()).toString();
var date=daysBetween( time.toDate(),DateTime.now());


    if(date<7){
      return "$date days";
    }else{
      return "${(date/7).toStringAsFixed(0)} Weeks and ${(date%7)} Days";
    }

  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

}
