import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getClassSchedules(classId){
    return  _firestore.collection("class").doc(classId).collection("schedules").orderBy('time', descending: true).snapshots();
  }

  addClassSchedules(topic, added_by, last_date, classId) async {
    await _firestore.collection("class").doc(classId).collection("schedules").doc().set(
        {
          "topic": topic,
          "added_by": added_by,
          "last_date": last_date,
          "time": Timestamp.now()
        }
    );
  }

  getMessageStrem(classId){
    return  _firestore.collection("class").doc(classId).collection("messages").orderBy('time', descending: true).snapshots();
  }


  sendMessage(text, name, type, classId) async {
    await _firestore.collection("class").doc(classId).collection("messages").doc().set(
      {
        "name": name,
        "text": text,
        "type": type,
        "time": Timestamp.now()
      }
    );
  }

  void uploadInstructorData(GoogleSignInAccount UserInfo, String? profilePicUrl,
      String name, String phone, String department) async {
    await _firestore.collection("instructor").doc(UserInfo.id).set({
      'id': UserInfo.id,
      'name': name,
      'photo': profilePicUrl,
      'email': UserInfo.email,
      'phone': phone,
      'department': department,
      'user_type': 'Teacher'
    });
  }

  void uploadStudentData(GoogleSignInAccount UserInfo, String? profilePicUrl,
      String name, String phone, String department, String semister) async {
    await _firestore.collection("student").doc(UserInfo.id).set({
      'id': UserInfo.id,
      'name': name,
      'photo': profilePicUrl,
      'email': UserInfo.email,
      'phone': phone,
      'department': department,
      'user_type': 'Student',
      'semister': semister
    });
  }

  updateProfilePicture(String? profilePicUrl) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    var url;
    Reference ref = storage.ref().child("profilePicUrl");
    UploadTask uploadTask = ref.putFile(File(profilePicUrl!));
    await uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });

    return url;
  }

  getInstructorData(uid) async {
    var data;
    await _firestore
        .collection("instructor")
        .doc(uid)
        .get()
        .then((value) async => data = await value.data());
    //print(data);
    return data;
  }

  getStudentData(uid) async {
    var data;
    await _firestore
        .collection("student")
        .doc(uid)
        .get()
        .then((value) async => data = await value.data());
    //print(data);
    return data;
  }

  uploadClassData(
      className, classCode, instructorName, userInfo, crId, Color color) async {
    String classID = "${userInfo.id}-${DateTime.now().millisecondsSinceEpoch}";

    await _firestore.collection("class").doc(classID).set({
      'c_nale': className,
      'c_code': classCode,
      'instructor_name': instructorName,
      "cr_id": crId.id,
      "cr_name": crId.name,
      'class_id': classID,
      "color": color.value,
    });
    return classID;
  }

  uploadStudentInAClass(String classID, userId) async {
    await _firestore
        .collection("class")
        .doc(classID)
        .collection("students")
        .doc(userId)
        .set({
      "id": userId,
    });
  }

  uploadClassIdToInstractor(String classID, userId) async {
    await _firestore
        .collection('instructor')
        .doc(userId)
        .collection('classes')
        .doc(classID)
        .set({
      "class_id": classID,
    });
  }

  uploadClassIdToStudents(String classID, userId) async {
    await _firestore
        .collection('student')
        .doc(userId)
        .collection('classes')
        .doc(classID)
        .set({
      "class_id": classID,
    });
  }
}
