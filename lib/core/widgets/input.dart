import 'package:design_and_printer/core/values/app_color.dart';
import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final Function(String) onChange;
  final TextInputType textInputType;
  final int maxLen;

  Input(
      {this.controller,
      this.title,
      this.onChange,
      this.textInputType = TextInputType.text,
      this.maxLen = 1000});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.titleColor,
            ),
          ),
        ),
        TextField(
          maxLength: maxLen,
          onChanged: onChange,
          controller: controller,
          keyboardType: textInputType,
          decoration: InputDecoration(
            fillColor: AppColor.textFieldBackground,
            filled: true,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ]),
    );
  }
}
