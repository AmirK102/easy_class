import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_class/functions/database_function.dart';
import 'package:easy_class/wigets/search_CR.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ClassScreen extends StatelessWidget {
  final className, classId;
  final color;
  final GoogleSignInAccount userInfo;

  const ClassScreen(
      {Key? key,
      @required this.className,
      this.color,
      this.classId,
      required this.userInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var studentData;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<bool> isStudentExist(id) async {
     return await  _firestore.collection('class').doc(classId).collection('students').doc(id).get().then((value) {
        return value.exists;
      });

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(color),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(className),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () async {
              studentData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectCR((value) {
                            return value;
                          })));
              print(studentData);
              if(await isStudentExist(studentData.id)){
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text("${studentData.name} Already Added"),
                    ));
              }
              else{
                Database().uploadStudentInAClass(classId, studentData.id);
                Database().uploadClassIdToStudents(classId, studentData.id);
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text("${studentData.name} Added"),
                    ));
              }

            },
            icon: Icon(Icons.add),
            iconSize: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
              child: Text(
            "Add Student",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          )),
        ],
      ),
    );
  }
}
