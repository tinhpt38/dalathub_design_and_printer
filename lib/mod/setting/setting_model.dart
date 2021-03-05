import 'package:design_and_printer/core/utils/io.dart';
import 'package:design_and_printer/core/values/share_name.dart';
import 'package:flutter/material.dart';

class SettingModel extends ChangeNotifier {
// Vars
//  Controller
//    Set
  TextEditingController _unitController =
      TextEditingController(text: 'DaLatHub');
  TextEditingController _widthController = TextEditingController(text: '30');
  TextEditingController _heightController = TextEditingController(text: '22');
  TextEditingController _printerAddress =
      TextEditingController(text: '121.0.0.1');
  TextEditingController _printerPort = TextEditingController(text: '8080');
  //    Get
  TextEditingController get unitController => _unitController;
  TextEditingController get widthController => _widthController;
  TextEditingController get heightController => _heightController;
  TextEditingController get printerAddres => _printerAddress;
  TextEditingController get printerPort => _printerPort;
  // Status
  //    Set
  bool _error = false;
  bool _success = false;
  String _message = '';
  //    Get
  bool get error => _error;
  bool get success => _success;
  String get message => _message;
  String url = 'http://dalathub.com/';

  // Original
  //    Set
  int _width = 30;
  int _height = 20;
  // Util
  //    Set
  FileIO fileIO = FileIO();

  Future<void> readConfig() async {
    try {
      _unitController.text = await fileIO.readFile(ShareName.unit);
      String sizeContent = await fileIO.readFile(ShareName.size);
      List<String> temp = sizeContent.split("x");
      _widthController.text = temp[0].trim();
      _heightController.text = temp[1].trim();
      notifyListeners();
    } catch (_) {
      print('err');
    }
  }

  Future<void> save() async {
    try {
      _width = int.parse(_widthController.text.trim());
      _height = int.parse(_heightController.text.trim());
      await fileIO.write(fileName: ShareName.size, value: '$_width x $_height');
      await fileIO.write(
          fileName: ShareName.unit, value: '${_unitController.text.trim()}');
      _success = true;
      _message = 'Lưu không thành cônng';
      _error = false;
      _message = 'Lưu thành công';
      notifyListeners();
    } catch (_e) {
      _error = true;
      _message = 'Khổ giấy sai định dạng! Lưu không thành công';
      notifyListeners();
    }
  }
}
