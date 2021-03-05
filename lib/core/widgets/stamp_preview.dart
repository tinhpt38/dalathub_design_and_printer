import 'package:auto_size_text/auto_size_text.dart';
import 'package:design_and_printer/core/models/stamp.dart';
import 'package:design_and_printer/core/values/app_color.dart';
import 'package:flutter/material.dart';

class StampPreview extends StatelessWidget {
  final Stamp stamp;

  StampPreview(this.stamp);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 1,
        child: render(context),
      ),
    );
  }

  Widget render(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.all(size.width * 1 / 20),
        color: AppColor.previewBackground,
        child: AspectRatio(
          aspectRatio: stamp.height / stamp.width,
          child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(stamp.unitName,
                          textAlign: TextAlign.center,
                          minFontSize: 12,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(stamp.productName, minFontSize: 8),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: stamp.createAt.isEmpty
                          ? Container()
                          : AutoSizeText("NNH: ${stamp.createAt}",
                              minFontSize: 8),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText("HSD: ${stamp.expriedAt}",
                          minFontSize: 8),
                    )
                  ])),
        ));
  }
}
