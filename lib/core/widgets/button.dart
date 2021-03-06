import 'package:design_and_printer/core/values/app_color.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String lable;
  final VoidCallback onTap;

  Button(this.lable, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: AppColor.violet,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.black38,
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            // color: AppColor.buttonColor,
            child: Text(lable.toUpperCase(),
                style: TextStyle(color: Colors.white))),
      ),
    );
  }
}
