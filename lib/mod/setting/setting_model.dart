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
    notifyListeners();
  }

  FileIO fileIO = FileIO();

  Future<void> readConfig() async {
    _printers = await Printing.listPrinters();
    try {
      _unitController.text = await fileIO.readFile(ShareName.unit);
      notifyListeners();
    } catch (_) {
      print('err');
    }
  }

  Future<void> save() async {
    try {
      await fileIO.write(
          fileName: ShareName.unit, value: '${_unitController.text.trim()}');
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
