import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_class/Screens/home_screen.dart';
import 'package:easy_class/Screens/sign_up_form.dart';
import 'package:easy_class/functions/google_sign_in.dart';
import 'package:easy_class/wigets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SplasScreen extends StatefulWidget {
  const SplasScreen({Key? key}) : super(key: key);

  @override
  _SplasScreenState createState() => _SplasScreenState();
}

class _SplasScreenState extends State<SplasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Image.asset(
              "assets/logo.png",
              height: 100,
              width: 100,
            ),
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Agne',
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'easy class',
                      speed: Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'Mange Your Class Easily',
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  repeatForever: false,
                  totalRepeatCount: 1,
                  onFinished: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogBox();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDialogBox extends StatefulWidget {
  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool loading = false;

  Future<bool?> isIdExistsInInstructor(id) async {
    bool isExist = true;
    await _firestore.collection("instructor").doc(id).get().then((value) {
      if (!value.exists) {
        isExist = false;
      }
    });
    return isExist;
  }

  Future<bool?> isIdExistsInStudent(id) async {
    bool isExist = true;
    await _firestore.collection("student").doc(id).get().then((value) {
      if (!value.exists) {
        isExist = false;
      }
    });
    return isExist;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(23),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: <Widget>[
              Container(
                height: 300,
                padding:
                    EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                margin: EdgeInsets.only(top: 45),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment(0, -0.3),
                  child: Text(
                    "Do You Want To Log In As ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment(0, 0.2),
                  child: Button(
                      buttonText: "Instructor",
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          await googleSignIN().then((value) async {
                            if (value == null) {
                              setState(() {
                                loading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Text(
                                            "Log In Failed! Please Try Again"),
                                      ));
                              return;
                            }

                            if (await isIdExistsInStudent(value.id) == false) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                return SignUpForm(
                                  userInfo: value,
                                  isStudent: false,
                                );
                              }), ModalRoute.withName('/'));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Text(
                                            "You Have Already LoggedIn As A Student"),
                                      ));
                              setState(() {
                                loading = false;
                              });
                            }
                          });
                        } catch (e) {
                          print(e);
                          setState(() {
                            loading = false;
                          });
                        }
                      }),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment(0, 0.8),
                  child: Button(
                      buttonText: "Student",
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          await googleSignIN().then((value) async {
                            if (await isIdExistsInInstructor(value!.id) ==
                                false) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                return SignUpForm(
                                  userInfo: value,
                                  isStudent: true,
                                );
                              }), ModalRoute.withName('/'));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Text(
                                            "You have already logged in as a Instructor"),
                                      ));
                              loading = false;
                              setState(() {});
                            }
                          });
                        } catch (e) {
                          print(e);
                        }
                      }),
                ),
              ),
            ],
          );
  }
}
