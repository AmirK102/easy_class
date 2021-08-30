import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_class/Screens/sign_up_form.dart';
import 'package:easy_class/Screens/splash_screen.dart';
import 'package:easy_class/functions/database_function.dart';
import 'package:easy_class/utilitis/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.userInfo,
    required this.profileImage,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
  final GoogleSignInAccount userInfo;
  final profileImage;
}

class _HomeScreenState extends State<HomeScreen> {
  //variable
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var userData;
  late String photoUrl;
  int i = 0;

  //functions

  void signOutGoogle() async {
    await _googleSignIn.signOut();
    _googleSignIn.disconnect();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplasScreen()),
        (route) => false);

    print("User Sign Out");
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    userData = await Database().getUserData(widget.userInfo.id);
    print("............................${userData['photo']}");
    setState(() {
      photoUrl = userData['photo'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            userInfo: widget.userInfo, isStudent: false)));
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
                child: Icon(Icons.menu_outlined),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    /*Color randomColor = Const().listOfColor[
                        Random().nextInt(Const().listOfColor.length)];*/
                    if (i >= Const().listOfColor.length) {
                      i = 0;
                    }
                    Color randomColor = Const().listOfColor[i];
                    i++;
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
                                colors: [
                                  randomColor.withOpacity(0.6),
                                  randomColor
                                ]),
                            color: randomColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: [
                                Text(
                                  "CSE-1234",
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
                                  "Software Development Lab",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
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
                                      "Instructor: Md Aminul Islam",
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
                                      "Class Representative: Sudipto Kundu",
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
                                      "Total Student: 28",
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
                  }),
            )
          ],
        ));
  }
}
