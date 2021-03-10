import 'dart:async';

import 'package:design_and_printer/core/models/stamp.dart';
import 'package:design_and_printer/core/utils/io.dart';
import 'package:design_and_printer/core/values/share_name.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HomeModel extends ChangeNotifier {
  //Vars
  //  Controller
  //    Set
  TextEditingController _unitController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _createAtController = TextEditingController(
      text:
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}');
  TextEditingController _expriedAtController = TextEditingController(
      text:
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}');
  TextEditingController _printQuantityController =
      TextEditingController(text: '1');
  //    Get
  TextEditingController get unitController => _unitController;
  TextEditingController get productController => _productController;
  TextEditingController get createAtController => _createAtController;
  TextEditingController get expriedAtController => _expriedAtController;
  TextEditingController get printQuantityController => _printQuantityController;
  Stamp _stamp;
  Stamp get stamp => _stamp;
  int _printQuantity = 1;
  int get printQuantiry => _printQuantity;
  bool _error = false;
  bool _success = false;
  String _message = '';
  bool get error => _error;
  bool get success => _success;
  String get message => _message;

  Printer _printer;

  Printer get printer => _printer;

  HomeModel() {
    _stamp = Stamp(_unitController.text.trim(), 'Coffe',
        _createAtController.text, _expriedAtController.text);
  }

  void preview() {
    if (expriedAtController.text.isEmpty) {
      _error = true;
      _message = 'Ngày hết hạn không được để trống';
      notifyListeners();
    } else {
      _error = false;
      _stamp = Stamp(unitController.text, productController.text,
          createAtController.text, expriedAtController.text);
      notifyListeners();
    }
  }

  void setError(bool err) {
    _error = err;
    notifyListeners();
  }

  void setSuccess(bool suceess) {
    _success = success;
    notifyListeners();
  }

  FileIO fileIO = FileIO();

  Future<void> readConfig() async {
    try {
      _unitController.text = await fileIO.readFile(ShareName.unit);
      _stamp = Stamp(unitController.text, productController.text,
          createAtController.text, expriedAtController.text);
      notifyListeners();
    } catch (_) {}
  }

  // Future<void> print() async {
  //   final doc = pw.Document();
  //   PdfPageFormat format = PdfPageFormat(87.5, 55, marginAll: 5);
  //   doc.addPage(pw.Page(
  //       pageFormat: format,
  //       build: (pw.Context context) {
  //         return pw.Container(
  //             width: double.infinity,
  //             decoration: pw.BoxDecoration(
  //               border: pw.Border.all(color: PdfColors.black, width: 1),
  //             ),
  //             child: generatePdf());
  //       })); // Page
  //   await Printing.layoutPdf(
  //       onLayout: (PdfPageFormat format) async => doc.save());
  // }

  setPrinter(Printer value) {
    _printer = value;
  }

  Future<void> print() async {
    if (_productController.text.isEmpty) {
      _error = true;
      _message = 'Tên sản phẩm đang trống';
      notifyListeners();
      return;
    }
    try {
      _printQuantity = int.parse(_printQuantityController.text);
      if (_printQuantity < 0) {
        _printQuantity = 0;
        _error = true;
        _message = 'Số lượng in không hợp lệ. Số lượng là một số';
        notifyListeners();
        return;
      }
    } catch (_) {
      _printQuantity = 0;
      _error = true;
      _message = 'Số lượng in không hợp lệ';
      notifyListeners();
      return;
    }

    final doc = pw.Document();
    PdfPageFormat format = PdfPageFormat(180, 50);
    for (int i = 0; i < _printQuantity; i++) {
      doc.addPage(renderPage(format));
    }
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());

    // await Printing.directPrintPdf(
    //     printer: _printer,
    //     onLayout: (PdfPageFormat format) async {
    //       return await doc.save();
    //     });
  }

  pw.Page renderPage(PdfPageFormat format) {
    return pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    width: double.infinity,
                    // margin: const pw.EdgeInsets.only(right: 8),
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 1),
                    ),
                    child: generatePdf(),
                  ),
                ),
                pw.SizedBox(width: 16),
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                      // margin: const pw.EdgeInsets.only(left: 8),
                      width: double.infinity,
                      alignment: pw.Alignment.center,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black, width: 1),
                      ),
                      child: generatePdf()),
                ),
              ]);
        }); // Pa
  }

  pw.Widget generatePdf() {
    return pw.Column(children: [
      _unitController.text.isNotEmpty
          ? pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              child: pw.Text(_stamp.unitName,
                  style: pw.TextStyle(fontSize: 6),
                  textAlign: pw.TextAlign.center),
            )
          : pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
            ),
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Text(_stamp.productName.toUpperCase(),
            style: pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center),
      ),
      _stamp.createAt.isNotEmpty
          ? pw.Text('NNH: ' + _stamp.createAt,
              style: pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center)
          : pw.Container(),
      pw.Text('HSD: ' + _stamp.expriedAt,
          style: pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center),
    ]);
  }
}
