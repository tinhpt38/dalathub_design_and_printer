import 'package:design_and_printer/core/matt_q/matt_q.dart';
import 'package:design_and_printer/core/values/app_color.dart';
import 'package:design_and_printer/core/widgets/button.dart';
import 'package:design_and_printer/core/widgets/input.dart';
import 'package:design_and_printer/mod/setting/setting_model.dart';
import 'package:flutter/material.dart';

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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text('Copyright @ 2021 DaLatHub',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.start),
                          ),
                        ],
                      )),
                  flex: 1),
              Expanded(child: Container(color: Colors.green), flex: 1),
            ],
          ),
        ),
      );
    };
  }

  @override
  SettingModel model() => SettingModel();
}
