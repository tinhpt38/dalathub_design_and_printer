import 'package:design_and_printer/core/models/stamp.dart';
import 'package:design_and_printer/core/utils/io.dart';
import 'package:design_and_printer/core/values/share_name.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeModel extends ChangeNotifier {
  //Vars
  //  Controller
  //    Set
  TextEditingController _unitController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _createAtController = TextEditingController();
  TextEditingController _expriedAtController = TextEditingController();
  TextEditingController _printQuantityController =
      TextEditingController(text: '1');
  //    Get
  TextEditingController get unitController => _unitController;
  TextEditingController get productController => _productController;
  TextEditingController get createAtController => _createAtController;
  TextEditingController get expriedAtController => _expriedAtController;
  TextEditingController get printQuantityController => _printQuantityController;
  //  Object
  //    Set
  Stamp _stamp = Stamp('DaLatHub', 'Coffe', '30/02/2021', '02/04/2021', 30, 20);
  //    Get
  Stamp get stamp => _stamp;
  //  Original
  //    Set
  int _printQuantity = 1;
  int _width = 30;
  int _height = 20;
  //    Get
  int get printQuantiry => _printQuantity;
  //  Status
  //    Set
  bool _error = false;
  String _message = '';
  //    Get
  bool get error => _error;
  String get message => _message;

  HomeModel();

  void preview() {
    _stamp = Stamp(unitController.text, productController.text,
        createAtController.text, expriedAtController.text, 30, 20);
    notifyListeners();
  }

  void setError(bool err) {
    _error = err;
    notifyListeners();
  }

  void setQuantity() {
    try {
      _printQuantity = int.parse(_printQuantityController.text);
    } catch (_) {
      _error = true;
      _message = 'Số lượng in không hợp lệ';
      notifyListeners();
    }
  }

  FileIO fileIO = FileIO();

  Future<void> readConfig() async {
    try {
      _unitController.text = await fileIO.readFile(ShareName.unit);
      String sizeContent = await fileIO.readFile(ShareName.size);
      List<String> temp = sizeContent.split("x");
      _width = int.parse(temp[0].trim());
      _height = int.parse(temp[1].trim());
      _stamp = Stamp(_unitController.text, '', '', '', 30, 20);

      notifyListeners();
    } catch (_) {}
  }

  void print() async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    final PosPrintResult res =
        await printer.connect('192.168.0.123', port: 9100);
    if (res == PosPrintResult.success) {
      makeReceipt(printer);
      printer.disconnect();
    }
  }

  void makeReceipt(NetworkPrinter printer) {
    printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));

    // printer.text('Bold text', styles: PosStyles(bold: true));
    // printer.text('Reverse text', styles: PosStyles(reverse: true));
    // printer.text('Underlined text',
    //     styles: PosStyles(underline: true), linesAfter: 1);
    printer.text(_unitController.text.trim(),
        styles: PosStyles(align: PosAlign.center), linesAfter: 2);
    printer.text(_productController.text.trim(),
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);
    printer.text(_createAtController.text.trim(),
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);
    printer.text(_expriedAtController.text.trim(),
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);
    printer.feed(2);
    printer.cut();
  }
}
