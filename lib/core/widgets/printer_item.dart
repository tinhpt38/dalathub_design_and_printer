import 'package:flutter/material.dart';

class PrinterItem extends StatefulWidget {
  final String title;
  final Function(bool) onSeleted;
  final bool isSelect;

  PrinterItem({this.title, this.onSeleted, this.isSelect = false});

  @override
  _PrinterItemState createState() => _PrinterItemState();
}

class _PrinterItemState extends State<PrinterItem> {
  Color _defaultColor = Colors.white;
  Color _seletecdColor = Colors.green;
  String _title;
  bool _isSelect;

  @override
  void initState() {
    _title = widget.title;
    _isSelect = widget.isSelect;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelect = !_isSelect;
        });
        widget.onSeleted(_isSelect);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: _isSelect ? _seletecdColor : _defaultColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_title,
              style: TextStyle(color: _isSelect ? Colors.white : Colors.black)),
        ),
      ),
    );
  }
}
