import 'package:design_and_printer/core/widgets/button.dart';
import 'package:design_and_printer/core/widgets/datepicker.dart';
import 'package:design_and_printer/core/widgets/input.dart';
import 'package:design_and_printer/core/widgets/stamp_preview.dart';
import 'package:design_and_printer/mod/home/home_model.dart';
import 'package:design_and_printer/mod/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:matt_q/matt_q.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends MattQ<HomePage, HomeModel> {
  @override
  void widgetsBindingAsyncCallback(
      BuildContext context, HomeModel model) async {
    await model.readConfig();
  }

  @override
  Function(BuildContext context, HomeModel model, Widget child) builder() {
    return (context, model, child) {
      Future.delayed(Duration(), () {
        if (model.error) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(SnackBar(
              content: Text(model.message), backgroundColor: Colors.red));
          model.setError(false);
        }
        if (model.success) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(SnackBar(
              content: Text(model.message), backgroundColor: Colors.green));
          model.setSuccess(false);
        }
      });
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 255,
                      height: 50,
                      child: Image.asset('assets/dalathub_logo_4x.png'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SettingPage()));
                      },
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Image.asset('assets/settings_1x.png'),
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Input(
                                maxLen: 30,
                                controller: model.unitController,
                                title: "Tên đơn vị",
                                onChange: (_) {
                                  model.preview();
                                }),
                            Input(
                                maxLen: 30,
                                controller: model.productController,
                                title: "Tên sản phẩm",
                                onChange: (_) {
                                  model.preview();
                                }),
                            DatePicker(
                                controller: model.createAtController,
                                title: "Ngày nhập",
                                onChange: () {
                                  model.preview();
                                }),
                            DatePicker(
                                controller: model.expriedAtController,
                                title: "Ngày hết hạn",
                                onChange: () {
                                  model.preview();
                                }),
                          ],
                        )),
                    flex: 1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        children: [
                          StampPreview(model.stamp),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Input(
                                    controller: model.printQuantityController,
                                    title: "Số lượng",
                                    onChange: (_) {}),
                              ),
                              SizedBox(width: 100),
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 26),
                                    child: Button('IN', () async {
                                      model.setQuantity();
                                      await model.print();
                                    }),
                                  ),
                                  flex: 1),
                            ],
                          ),
                        ],
                      ),
                    ),
                    flex: 1,
                  ),
                ]),
              ],
            ),
          ),
        ),
      );
    };
  }

  @override
  HomeModel model() => HomeModel();
}
