import 'package:design_and_printer/core/values/app_color.dart';
import 'package:design_and_printer/core/widgets/button.dart';
import 'package:design_and_printer/core/widgets/input.dart';
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
          elevation: 0.1,
          backgroundColor: AppColor.previewBackground,
        ),
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
                              controller: model.unitController,
                              title: 'Tên đơn vị',
                              onChange: null),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text('Khổ giấy'),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Input(
                                    textInputType: TextInputType.number,
                                    controller: model.widthController,
                                    title: "Chiều ngang",
                                    onChange: null),
                              ),
                              SizedBox(width: 200),
                              Expanded(
                                flex: 1,
                                child: Input(
                                    textInputType: TextInputType.number,
                                    controller: model.heightController,
                                    title: "Chiều dọc",
                                    onChange: null),
                              ),
                            ],
                          ),
                          Spacer(),
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
                          "Tên phần mềm: DaLatHub Desige and Printer",
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
                                    text: 'http://dalathub.com',
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
                          "0387577092 - Nguyễn Văn Huy Dũng",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "0387577092 - Phan Trung Tính",
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
