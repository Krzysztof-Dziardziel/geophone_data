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

    // var data1 = serialData1.map((element) => element.toDouble()).toList();
    // var data2 = serialData2.map((element) => element.toDouble()).toList();
    // var data3 = serialData3.map((element) => element.toDouble()).toList();
    // var window = new Window(WindowType.HAMMING);

    // var fft1 = new FFT().Transform(window.apply(data1));

    // var fftRePoints1 = fft1.map((complex) => complex.modulus.toInt());

    doFFTPoints(List<num> serialData) {
      var data = serialData.map((element) => element.toDouble()).toList();
      var window = new Window(WindowType.HAMMING);
      var fft = new FFT().Transform(window.apply(data));
      var fftRePoints = fft.map((complex) => complex.modulus.toInt());
      return valuesToPoints(fftRePoints.toList(), 500);
    }

    return TimerBuilder.periodic(Duration(milliseconds: 1), builder: (context) {
      List<GraphPoint> points0 = doFFTPoints(serialData1);
      List<GraphPoint> points1 = doFFTPoints(serialData2);
      List<GraphPoint> points2 = doFFTPoints(serialData3);
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
          if (isGreenActive)
            charts.Series(
                id: "1",
                data: points1,
                domainFn: (GraphPoint series, _) => series.x,
                measureFn: (GraphPoint series, _) => series.y,
                colorFn: (GraphPoint series, _) =>
                    charts.MaterialPalette.green.shadeDefault),
          if (isBlueActive)
            charts.Series(
                id: "2",
                data: points2,
                domainFn: (GraphPoint series, _) => series.x,
                measureFn: (GraphPoint series, _) => series.y,
                colorFn: (GraphPoint series, _) =>
                    charts.MaterialPalette.blue.shadeDefault)
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
