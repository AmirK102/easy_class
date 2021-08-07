import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {
  CustomTextFields({
    required this.nameController,
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
