import 'package:design_and_printer/core/values/app_color.dart';
import 'package:design_and_printer/core/widgets/button.dart';
import 'package:design_and_printer/core/widgets/input.dart';
import 'package:design_and_printer/core/widgets/printer_item.dart';
import 'package:design_and_printer/mod/setting/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:matt_q/matt_q.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends MattQ<SettingPage, SettingModel> {
  @override
  void widgetsBindingAsyncCallback(
      BuildContext context, SettingModel model) async {
    await model.readConfig();
  }

  @override
  Function(BuildContext context, SettingModel model, Widget child) builder() {
    return (context, model, child) {
      Future.delayed(Duration.zero, () {
        if (model.error) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(SnackBar(
              content: Text(model.message), backgroundColor: Colors.red));
        }
        if (model.success) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(SnackBar(
              content: Text(model.message), backgroundColor: Colors.green));
        }
      });
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text('Cài đặt', style: TextStyle(color: Colors.black)),
            elevation: 0.0,
            backgroundColor: AppColor.previewBackground),
        body: Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Input(
                              maxLen: 30,
                              controller: model.unitController,
                              title: 'Tên đơn vị',
                              onChange: null),
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text('Danh sách máy in',
                                  style:
                                      TextStyle(color: AppColor.titleColor))),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: RefreshIndicator(
                              key: GlobalKey(),
                              onRefresh: () async {
                                await model.readConfig();
                              },
                              child: model.printers.isEmpty
                                  ? ListView(
                                      children: [
                                        Container(
                                            child: Text(
                                                'Chưa tim thấy thiết bị nào'))
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: model.printers.length,
                                      itemBuilder: (context, index) {
                                        return PrinterItem(
                                            title: model.printers[index].name,
                                            isSelect: (model
                                                        .seletedPrinter.model ==
                                                    model.printers[index]
                                                        .model) &&
                                                (model.seletedPrinter.name ==
                                                    model.printers[index].name),
                                            onSeleted: (_) {
                                              model.setPrinter(
                                                  model.printers[index]);
                                            });
                                      }),
                            ),
                          )),
                          Button(
                            'Lưu',
                            () async {
                              await model.save();
                            },
                          ),
                        ],
                      )),
                  flex: 1),
              Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                          "GIỚI THIỆU",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Tên phần mềm: DaLatHub Design and Printer",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Bản quyền phần mềm thuộc về DaLatHub.",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            child: RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: 'Website:',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                                TextSpan(text: 'dalathub.com'),
                                TextSpan(
                                    text: 'https://dalathub.com',
                                    style: TextStyle(color: Colors.blue))
                              ]),
                            ),
                            onTap: () async {
                              await canLaunch(model.url)
                                  ? await launch(model.url)
                                  : throw 'Could not launch ${model.url}';
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                          "LIÊN HỆ",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Nguyễn Văn Huy Dũng: 0387-577-092",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Phan Trung Tính: 0865-802-659",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Image.asset("assets/dalathub_logo_4x.png")),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('Copyright @ 2021 DaLatHub',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                  flex: 1),
            ],
          ),
        ),
      );
    };
  }

  @override
  SettingModel model() => SettingModel();
}
