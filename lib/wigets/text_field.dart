import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {
  final String hintText;
  CustomTextFields({
    required this.nameController,
    @required this.hintText = "",
  });

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      style: TextStyle(
          color: Colors.lightBlue, fontWeight: FontWeight.bold, fontSize: 15),
      controller: nameController,
      onChanged: (value) {},
      decoration: InputDecoration(
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.grey.withOpacity(0.7),
        ),
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2),
        ),
      ),
    );
  }
}
