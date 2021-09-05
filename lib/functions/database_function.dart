import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void uploadInstructorData(GoogleSignInAccount UserInfo, String? profilePicUrl,
      String name, String phone, String department) async {
    await _firestore.collection("user").doc(UserInfo.id).set({
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
    await _firestore.collection("user").doc(UserInfo.id).set({
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

  getUserData(uid) async {
    var data;
    await _firestore
        .collection("user")
        .doc(uid)
        .get()
        .then((value) async => data = await value.data());
    //print(data);
    return data;
  }

  uploadClassData(className, classCode, instructorName, userInfo) async {
    await _firestore
        .collection("class")
        .doc("${userInfo.id}-${DateTime.now().millisecondsSinceEpoch}")
        .set({
      'c_nale': className,
      'c_code': classCode,
      'instructor_name': instructorName,
      'total_student': 0,
    });
  }
}
