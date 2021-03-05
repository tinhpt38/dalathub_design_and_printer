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
        child: render(),
      ),
    );
  }

  Widget render() {
    return Container(
        padding: const EdgeInsets.all(64),
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
                      child: Text(stamp.unitName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(stamp.productName),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("NNH: ${stamp.createAt}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("HSD: ${stamp.expriedAt}"),
                    )
                  ])),
        ));
  }
}
