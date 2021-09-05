import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_class/Screens/home_screen.dart';
import 'package:easy_class/functions/database_function.dart';
import 'package:easy_class/wigets/button.dart';
import 'package:easy_class/wigets/text_field.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class SignUpForm extends StatefulWidget {
  final GoogleSignInAccount userInfo;
  final bool isStudent;

  SignUpForm({
    @required required this.userInfo,
    required this.isStudent,
  });

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String? profilePicUrl;
  bool validate = false;
  bool isSelectedImage = false;
  bool loading = false;
  var userData;

  TextEditingController _nameTextController = new TextEditingController();
  final ImagePicker _picker = ImagePicker();

  TextEditingController _phoneNumberTextController =
      new TextEditingController();
  TextEditingController _departmentTextController = new TextEditingController();
  TextEditingController _SemesterTextController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //profilePicUrl = widget.userInfo.photoUrl!;

    setValues(widget.userInfo.id).whenComplete(() {
      setState(() {});
    });
  }

  //functions

  setValues(id) async {
    userData = await Database().getUserData(id);
    print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
    print(userData);
    if (userData != null) {
      profilePicUrl = userData["photo"];
      _phoneNumberTextController.text = userData["phone"];
      _departmentTextController.text = userData["department"];

      _nameTextController.text = userData["name"];
      //  _SemesterTextController.text = userData["semister"];

      print("________________________________________________");
      print(userData["photo"]);

      print(userData["name"]);
    } else {
      profilePicUrl = widget.userInfo.photoUrl!;
      _phoneNumberTextController.text = "";
      _departmentTextController.text = "";
      _nameTextController.text = widget.userInfo.displayName!;

      // _SemesterTextController.text = userData["semister"] = "";

      print("________________________________________________");
      print(profilePicUrl);
      print("+++++++++++++++++++++++++++++++++++++");
      print(_nameTextController.text);
    }
  }

  InstructorTextFieldValidate(
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

  StudentTextFieldValidate(
      TextEditingController nameController,
      TextEditingController departmentController,
      TextEditingController phoneController,
      TextEditingController semisterControler) {
    if (nameController.text.isNotEmpty &&
        departmentController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        semisterControler.text.isNotEmpty) {
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
                              'Welcome ${_nameTextController.text}',
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
                                      fit: BoxFit.cover,
                                    )
                                  : profilePicUrl != null
                                      ? CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          height: 96,
                                          width: 96,
                                          imageUrl: profilePicUrl!,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                      : CircularProgressIndicator(),
                              Positioned.fill(
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 25,
                                      width: 35,
                                      margin: EdgeInsets.only(bottom: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50),
                                              bottomLeft: Radius.circular(50))),
                                      child: Center(
                                        child: IconButton(
                                          padding: EdgeInsets.only(
                                              bottom: 2, right: 5),
                                          iconSize: 20,
                                          color: Colors.white,
                                          splashRadius: 1,
                                          splashColor: Colors.lightBlue,
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
                                        ),
                                      ),
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
                                        hintText: _nameTextController.text,
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
                                        hintText: _departmentTextController
                                                    .value.text ==
                                                ""
                                            ? "CSE"
                                            : _departmentTextController.text,
                                        nameController:
                                            _departmentTextController)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          //Semister
                          Visibility(
                            visible: widget.isStudent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Semister : ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Container(
                                      height: 20,
                                      child: CustomTextFields(
                                          hintText: _SemesterTextController
                                                      .value.text ==
                                                  ""
                                              ? "3.1"
                                              : _SemesterTextController.text,
                                          nameController:
                                              _SemesterTextController)),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: widget.isStudent,
                            child: SizedBox(
                              height: 30,
                            ),
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
                                        hintText: _phoneNumberTextController
                                                    .value.text ==
                                                ""
                                            ? "01884546854987"
                                            : _phoneNumberTextController.text,
                                        nameController:
                                            _phoneNumberTextController)),
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
                            !widget.isStudent
                                ? InstructorTextFieldValidate(
                                    _nameTextController,
                                    _phoneNumberTextController,
                                    _departmentTextController)
                                : StudentTextFieldValidate(
                                    _nameTextController,
                                    _departmentTextController,
                                    _phoneNumberTextController,
                                    _SemesterTextController);
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
                                    .updateProfilePicture(profilePicUrl);
                              }
                              //update data to firebase
                              !widget.isStudent
                                  ? Database().uploadInstructorData(
                                      widget.userInfo,
                                      profilePicUrl,
                                      _nameTextController.text,
                                      _phoneNumberTextController.text,
                                      _departmentTextController.text)
                                  : Database().uploadStudentData(
                                      widget.userInfo,
                                      profilePicUrl,
                                      _nameTextController.text,
                                      _phoneNumberTextController.text,
                                      _departmentTextController.text,
                                      _SemesterTextController.text);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                return HomeScreen(
                                  isStudent: widget.isStudent,
                                  profileImage: profilePicUrl,
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
