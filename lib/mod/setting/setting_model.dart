import 'dart:convert';
import 'dart:math';

import 'package:design_and_printer/core/utils/io.dart';
import 'package:design_and_printer/core/values/share_name.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class SettingModel extends ChangeNotifier {
// Vars
//  Controller
//    Set
  TextEditingController _unitController =
      TextEditingController(text: 'DaLatHub');
  //    Get
  TextEditingController get unitController => _unitController;

  // Status
  //    Set
  bool _error = false;
  bool _success = false;
  String _message = '';
  //    Get
  bool get error => _error;
  bool get success => _success;
  String get message => _message;
  String url = 'https://dalathub.com/';

  List<Printer> _printers = [];

  List<Printer> get printers => _printers;
  Printer _seletedPrinter = Printer(url: '');
  Printer get seletedPrinter => _seletedPrinter;

  setPrinter(Printer value) {
    _seletedPrinter = value;
    print(_seletedPrinter.toString());
    notifyListeners();
  }

  FileIO fileIO = FileIO();

  Future<void> readConfig() async {
    _printers = await Printing.listPrinters();
    // _printers = _printers.where((element) => element.isAvailable);
    try {
      _unitController.text = await fileIO.readFile(ShareName.unit);
      String printerFormDB = await fileIO.readFile(ShareName.device);
      if (printerFormDB != null) {
        Map<String, dynamic> json = jsonDecode(printerFormDB);
        _seletedPrinter = Printer.fromMap(json);
        print('read config');
        print(_seletedPrinter);
      }
    } catch (_) {
      print('err');
    }
    notifyListeners();
  }

  Future<void> save() async {
    try {
      await fileIO.write(
          fileName: ShareName.unit, value: '${_unitController.text.trim()}');
      String printerInfo = jsonEncode(_seletedPrinter.toJson());
      print(printerInfo);
      await fileIO.write(fileName: ShareName.device, value: '$printerInfo');
      _success = true;
      _error = false;
      _message = 'Lưu thành công';
      notifyListeners();
    } catch (_e) {
      _error = true;
      _message = 'Lưu không thành công';
      notifyListeners();
    }
  }
}

extension value on Printer {
  Map<String, dynamic> toJson() => {
        'url': this.url,
        'location': this.location,
        'model': this.model,
        'comment': this.comment,
        'isDefault': this.isDefault,
        'isAvailable': this.isAvailable
      };
}
