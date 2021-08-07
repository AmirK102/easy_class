import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_class/Screens/home_screen.dart';
import 'package:easy_class/functions/database_function.dart';
import 'package:easy_class/wigets/button.dart';
import 'package:easy_class/wigets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class TeacherLoginForm extends StatefulWidget {
  final GoogleSignInAccount userInfo;

  TeacherLoginForm({@required required this.userInfo});

  @override
  _TeacherLoginFormState createState() => _TeacherLoginFormState();
}

class _TeacherLoginFormState extends State<TeacherLoginForm> {
  String? name, profilePicUrl;
  bool validate = false;
  bool isSelectedImage = false;
  bool loading = false;

  TextEditingController _nameTextController = new TextEditingController();
  final ImagePicker _picker = ImagePicker();

  TextEditingController _phoneNumberTextController =
      new TextEditingController();
  TextEditingController _departmentTextController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nameTextController.text = widget.userInfo.displayName!;
    profilePicUrl = widget.userInfo.photoUrl;
  }

  //functions

  textFieldValidate(
      TextEditingController nameController,
      TextEditingController departmentController,
      TextEditingController phoneController) {
    if (nameController.text.isNotEmpty &&
        departmentController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      validate = true;
    } else {
      validate = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instructor Login Form"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.vertical -
                    60,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Text(
                              'Welcome ${widget.userInfo.displayName!}',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'To easy class ',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Stack(
                            children: [
                              isSelectedImage
                                  ? Image.file(
                                      File(profilePicUrl!),
                                      height: 96,
                                      width: 96,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : CachedNetworkImage(
                                      height: 96,
                                      width: 96,
                                      imageUrl: profilePicUrl!,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                              Positioned.fill(
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      splashRadius: 1,
                                      splashColor: Colors.lightBlue,
                                      padding:
                                          EdgeInsets.only(right: 3, bottom: 0),
                                      alignment: Alignment.bottomRight,
                                      onPressed: () async {
                                        print("pressed");
                                        var image = await _picker.pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 60);
                                        setState(() {
                                          isSelectedImage = true;
                                          profilePicUrl = image!.path;
                                        });
                                      },
                                      icon: Icon(Icons.camera_alt),
                                    )),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 30,
                          ),

                          //name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name : ",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                    height: 20,
                                    child: CustomTextFields(
                                        nameController: _nameTextController)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          //Department
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Department : ",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                    height: 20,
                                    child: CustomTextFields(
                                        nameController:
                                            _phoneNumberTextController)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          //phone number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Phone : ",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                    height: 20,
                                    child: CustomTextFields(
                                        nameController:
                                            _departmentTextController)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Button(
                          buttonText: "Save",
                          onPressed: () async {
                            //validate text filed
                            textFieldValidate(
                                _nameTextController,
                                _phoneNumberTextController,
                                _departmentTextController);
                            //show eror
                            if (!validate) {
                              print("please fill the form");
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Text("Please Fill The Form"),
                                      ));
                            } else {
                              setState(() {
                                loading = true;
                              });

                              if (isSelectedImage) {
                                profilePicUrl = await Database()
                                    .updateProfilePicture(profilePicUrl!);
                              }
                              //update data to firebase
                              Database().uploadInstructorData(
                                  widget.userInfo,
                                  profilePicUrl,
                                  _nameTextController.text,
                                  _departmentTextController.text,
                                  _phoneNumberTextController.text);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                return HomeScreen(
                                  userInfo: widget.userInfo,
                                );
                              }), ModalRoute.withName('/'));
                            }
                          }),
                      SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
