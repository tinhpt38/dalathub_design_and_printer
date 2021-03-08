import 'dart:async';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class PrintCore {
  static final PrintCore _instance = PrintCore._internal();

  factory PrintCore() => _instance;
  PrintCore._internal();

  get paper => PaperSize.mm58;

  NetworkPrinter _printer;

  get printer => _printer;
  int _requestCount = 5;
  Timer _timer;
  Future<NetworkPrinter> fetch(Function(PosPrintResult) status) async {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (_requestCount == 0) {
        _timer.cancel();
      }
      CapabilityProfile profile = await CapabilityProfile.load();
      _printer = NetworkPrinter(paper, profile);
      PosPrintResult connector =
          await _printer.connect('127.0.0.1', port: 8080);
      status(connector);
      if (connector == PosPrintResult.success) {
        _timer.cancel();
        return _printer;
      } else {
        _requestCount--;
      }
    });
  }

  void listPrinter() {
    var a = Printer
  }
}
