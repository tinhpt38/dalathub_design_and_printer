import 'package:design_and_printer/core/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class DatePicker extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final VoidCallback onChange;

  DatePicker({this.title, this.controller, this.onChange});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  TextEditingController _controller = TextEditingController();
  String _title;

  @override
  void initState() {
    _controller = widget.controller;
    _title = widget.title;
    super.initState();
  }

  Future<void> onDatePicker() async {
    DateTime newDateTime = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      borderRadius: 16,
    );
    _controller.text =
        '${newDateTime.day}/${newDateTime.month}/${newDateTime.year}';
    widget.onChange();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            _title,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.titleColor,
            ),
          ),
        ),
        TextField(
          controller: _controller,
          onChanged: (_) {
            widget.onChange();
          },
          decoration: InputDecoration(
            suffixIcon: InkWell(
                child: Icon(Icons.calendar_today_rounded),
                onTap: () async {
                  await onDatePicker();
                }),
            fillColor: AppColor.textFieldBackground,
            filled: true,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ]),
    );
  }
}
