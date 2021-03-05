import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class PrintCore {
  static final PrintCore _instance = PrintCore._internal();

  factory PrintCore() => _instance;
  PrintCore._internal();

  get paper => PaperSize.mm58;
  get profile async => await CapabilityProfile.load();
  get printer => NetworkPrinter(paper, profile);
  get connectPrinter async => await printer.connect('127.0.0.1', port: 8080);

  get pingSusccess => connectPrinter == PosPrintResult.success;
}
