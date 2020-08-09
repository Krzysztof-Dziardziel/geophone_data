import 'dart:typed_data';

import 'package:fft/fft.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'channelSelectors.dart';
import 'graph.dart';
import 'main.dart';

class FFTWidget extends StatefulWidget {
  @override
  _FFTWidgetState createState() => _FFTWidgetState();
}

class _FFTWidgetState extends State<FFTWidget> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // Float64List reals = Float64List(1001);

    // for (var i = 0; i <= 1000; i++) {
    //   reals[i] = i.toDouble();
    // }

    // List serialDataFloat1 =
    //     Float64List.fromList(serialData1.map((i) => i.toDouble()).toList());
    // FFT.transform(reals, serialDataFloat1);

    // var data = serialData1.map((element) => element.toDouble());
    // var fft = new FFT().Transform(data.toList());

    var data = serialData1.map((element) => element.toDouble());

    var fft = new FFT().Transform(data.toList());

    var fftRePoints = fft.map((complex) => complex.imaginary.toInt());

    return TimerBuilder.periodic(Duration(milliseconds: 1), builder: (context) {
      List<GraphPoint> points0 =
          valuesToPoints(fftRePoints.toList() ?? List.filled(512, 0));
      // List<GraphPoint> points1 = valuesToPoints(serialData2 ?? [0, 0, 0]);
      // List<GraphPoint> points2 = valuesToPoints(serialData3 ?? [0, 0, 0]);
      getSeriesData() {
        List<charts.Series<GraphPoint, int>> series = [
          if (isRedActive)
            charts.Series(
                id: "0",
                data: points0,
                domainFn: (GraphPoint series, _) => series.x,
                measureFn: (GraphPoint series, _) => series.y,
                colorFn: (GraphPoint series, _) =>
                    charts.MaterialPalette.red.shadeDefault),
          // if (isGreenActive)
          //   charts.Series(
          //       id: "1",
          //       data: points1,
          //       domainFn: (GraphPoint series, _) => series.x,
          //       measureFn: (GraphPoint series, _) => series.y,
          //       colorFn: (GraphPoint series, _) =>
          //           charts.MaterialPalette.green.shadeDefault),
          // if (isBlueActive)
          //   charts.Series(
          //       id: "2",
          //       data: points2,
          //       domainFn: (GraphPoint series, _) => series.x,
          //       measureFn: (GraphPoint series, _) => series.y,
          //       colorFn: (GraphPoint series, _) =>
          //           charts.MaterialPalette.blue.shadeDefault)
        ];
        return series;
      }

      return Container(
        height: height,
        width: width,
        child: charts.LineChart(
          getSeriesData(),
          animate: false,
          domainAxis: charts.NumericAxisSpec(
            showAxisLine: true,
            renderSpec: charts.GridlineRendererSpec(
              lineStyle: charts.LineStyleSpec(dashPattern: [4, 4]),
            ),
          ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            showAxisLine: true,
            renderSpec: charts.GridlineRendererSpec(
              lineStyle: charts.LineStyleSpec(dashPattern: [4, 4]),
            ),
          ),
        ),
      );
    });
  }
}
