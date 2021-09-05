import 'package:easy_class/functions/database_function.dart';
import 'package:easy_class/wigets/button.dart';
import 'package:easy_class/wigets/search_CR.dart';
import 'package:easy_class/wigets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CreateClass extends StatelessWidget {
  final color;
  final GoogleSignInAccount userInfo;

  const CreateClass({Key? key, @required this.color, required this.userInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _classNameTextController =
        new TextEditingController();
    TextEditingController _classCodeTextController =
        new TextEditingController();
    TextEditingController _instructorTextController =
        new TextEditingController();

    bool validate = false;

    StudentTextFieldValidate(
      TextEditingController _classNameTextController,
      TextEditingController _classCodeTextController,
      TextEditingController _instructorTextController,
    ) {
      if (_classNameTextController.text.isNotEmpty &&
          _classCodeTextController.text.isNotEmpty &&
          _instructorTextController.text.isNotEmpty) {
        validate = true;
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text("Please Fill The Form"),
                ));
      }
    }

    return Container(
      color: color,
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
                  ..text = userInfo.displayName!,
                hintColor: Colors.white,
                textColor: Colors.white,
                hintText: ""),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                searchCr(context);
              },
              child: Text(
                "Assign A CR",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Button(
                buttonText: "Create Class",
                onPressed: () {
                  StudentTextFieldValidate(_classNameTextController,
                      _classCodeTextController, _instructorTextController);

                  if (validate) {
                    Database().uploadClassData(
                        _classNameTextController.text,
                        _classCodeTextController.text,
                        _instructorTextController.text,
                        userInfo);
                    Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

searchCr(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => SelectCR()),
  );
}
