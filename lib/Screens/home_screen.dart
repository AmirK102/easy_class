import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_class/Screens/class_screen.dart';
import 'package:easy_class/Screens/sign_up_form.dart';
import 'package:easy_class/Screens/splash_screen.dart';
import 'package:easy_class/functions/database_function.dart';
import 'package:easy_class/utilitis/const.dart';
import 'package:easy_class/wigets/create_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.userInfo,
    required this.profileImage,
    @required this.isStudent,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
  final GoogleSignInAccount userInfo;
  final profileImage;
  final isStudent;
}

class _HomeScreenState extends State<HomeScreen> {
  //variable
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var userData;
  late String photoUrl;
  int i = 0;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //functions

  void signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
    } on Exception catch (e) {
      // TODO
      print(e);
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplasScreen()),
        (route) => false);

    print("User Sign Out");
  }

  getClassDataByID(classID) async {
    String classCode, className, instructorName, crName;
    int color, totalStudent;
    var data = await _firestore.collection("class").doc(classID).get();
    className = (data.data() as dynamic)["c_nale"];
    classCode = (data.data() as dynamic)["c_code"];
    instructorName = (data.data() as dynamic)["instructor_name"];
    crName = (data.data() as dynamic)["cr_name"];
    color = (data.data() as dynamic)["color"];
    totalStudent = await _firestore
        .collection("class")
        .doc(classID)
        .collection("students")
        .get()
        .then((value) {
      return value.docs.length;
    });
    setState(() {});

    return {
      "classCode": classCode,
      "className": className,
      "instructorName": instructorName,
      "crName": crName,
      "color": color,
      "totalStudent": totalStudent
    };
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    if (widget.isStudent) {
      userData = await Database().getStudentData(widget.userInfo.id);
    } else {
      userData = await Database().getInstructorData(widget.userInfo.id);
    }

    print("............................${userData['photo']}");
    setState(() {
      photoUrl = userData['photo'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: !widget.isStudent
            ? FloatingActionButton(
                onPressed: () {
                  Color randomColor = Const().listOfColor[
                      Random().nextInt(Const().listOfColor.length)];
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            contentPadding: EdgeInsets.zero,
                            content: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                CreateClass(
                                    setStateC: setState,
                                    color: randomColor,
                                    userInfo: widget.userInfo),
                                Positioned(
                                  right: -20.0,
                                  top: -20.0,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: CircleAvatar(
                                      child: Icon(Icons.close),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      });
                },
                child: Icon(Icons.add),
              )
            : Container(),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text("easy class"),
          leading: Container(),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpForm(
                            userInfo: widget.userInfo,
                            isStudent: widget.isStudent)));
              },
              child: CachedNetworkImage(
                imageUrl: widget.profileImage,
                imageBuilder: (context, imageProvider) => Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10000),
                onTap: () {
                  signOutGoogle();
                },
                child: Icon(Icons.logout),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('instructor')
                    .doc(widget.userInfo.id)
                    .collection("classes")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var classID = (snapshot.data!.docs
                                as dynamic)[index]["class_id"];

                            return FutureBuilder(
                                future: getClassDataByID(classID),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData)
                                    return snapshot.data != null
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ClassScreen(
                                                            className: (snapshot
                                                                        .data
                                                                    as dynamic)[
                                                                "className"],
                                                            color: (snapshot
                                                                        .data
                                                                    as dynamic)[
                                                                "color"],
                                                            classId: classID,
                                                            userInfo:
                                                                widget.userInfo,
                                                          )));
                                            },
                                            child: classView(
                                              color: (snapshot.data
                                                  as dynamic)["color"],
                                              classCode: (snapshot.data
                                                  as dynamic)["classCode"],
                                              className: (snapshot.data
                                                  as dynamic)["className"],
                                              crName: (snapshot.data
                                                  as dynamic)["crName"],
                                              instructorName: (snapshot.data
                                                  as dynamic)["instructorName"],
                                              totalStudent: (snapshot.data
                                                  as dynamic)["totalStudent"],
                                            ),
                                          )
                                        : Center(
                                            child: Text(
                                                "You Don't Have any Class Yet!"),
                                          );
                                  return Container();
                                });
                          }),
                    );
                  }
                  return Container();
                })
          ],
        ));
  }

  void addClass(BuildContext context, Color randomColor) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => CreateClass(
                color: randomColor,
                userInfo: widget.userInfo,
              )),
    );
  }
}

class classView extends StatelessWidget {
  final classCode, className, instructorName, crName, totalStudent, color;

  classView({
    this.classCode,
    this.className,
    this.instructorName,
    this.crName,
    this.totalStudent,
    this.color,
  });
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [Color(color).withOpacity(0.6), Color(color)]),
            color: Color(color),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Text(
                  classCode,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  className,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Divider(
                    color: Colors.white,
                    thickness: 1.5,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Instructor: $instructorName",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Class Representative: $crName",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Total Student: $totalStudent",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
