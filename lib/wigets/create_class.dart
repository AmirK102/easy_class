import 'package:easy_class/functions/database_function.dart';
import 'package:easy_class/utilitis/user_data_model.dart';
import 'package:easy_class/wigets/button.dart';
import 'package:easy_class/wigets/search_CR.dart';
import 'package:easy_class/wigets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CreateClass extends StatefulWidget {
  final color, setStateC;
  final GoogleSignInAccount userInfo;

  const CreateClass(
      {Key? key, @required this.color, required this.userInfo, this.setStateC})
      : super(key: key);

  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  TextEditingController _classNameTextController = new TextEditingController();
  TextEditingController _classCodeTextController = new TextEditingController();
  TextEditingController _instructorTextController = new TextEditingController();
  var getCallBackValue;
  bool validate = false;

  @override
  Widget build(BuildContext context) {
    StudentTextFieldValidate(
      TextEditingController _classNameTextController,
      TextEditingController _classCodeTextController,
      TextEditingController _instructorTextController,
    ) {
      if (_classNameTextController.text.isNotEmpty &&
          _classCodeTextController.text.isNotEmpty &&
          _instructorTextController.text.isNotEmpty &&
          getCallBackValue != null) {
        validate = true;
      } else {
        validate = false;
      }
    }

    return Container(
      color: widget.color,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFields(
                nameController: _classNameTextController,
                hintText: "Class Name",
                hintColor: Colors.white,
                textColor: Colors.white,
              ),
              CustomTextFields(
                nameController: _classCodeTextController,
                hintText: 'Class Code',
                hintColor: Colors.white,
                textColor: Colors.white,
              ),
              CustomTextFields(
                  nameController: _instructorTextController
                    ..text = widget.userInfo.displayName!,
                  hintColor: Colors.white,
                  textColor: Colors.white,
                  hintText: ""),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  getCallBackValue = await searchCr(context);
                  print("setstate");
                  print(getCallBackValue.name);
                  print(getCallBackValue == null);
                  widget.setStateC(() {});
                },
                child: getCallBackValue == null
                    ? Text(
                        "Assign A CR",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : UserListView(
                        name: getCallBackValue.name,
                        email: getCallBackValue.email,
                        imageUrl: getCallBackValue.imageUrl,
                      ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Button(
                  buttonText: "Create Class",
                  onPressed: () async {
                    StudentTextFieldValidate(_classNameTextController,
                        _classCodeTextController, _instructorTextController);

                    if (validate) {
                      var classID;
                      classID = await Database().uploadClassData(
                          _classNameTextController.text,
                          _classCodeTextController.text,
                          _instructorTextController.text,
                          widget.userInfo,
                          getCallBackValue,
                          widget.color);
                      await Database()
                          .uploadStudentInAClass(classID, getCallBackValue.id);
                      await Database().uploadClassIdToInstractor(
                          classID, widget.userInfo.id);
                      await Database().uploadClassIdToStudents(
                          classID, getCallBackValue.id);
                      Navigator.pop(context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text(
                                    "Please Fill The Form and Assign a CR"),
                              ));
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  searchCr(BuildContext context) async {
    print("sadas");
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectCR((value) {
                  return value;
                })));
    print("sadas");
  }
}
