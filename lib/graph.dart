import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_app_esp32_usb_serial/main.dart';
import 'package:timer_builder/timer_builder.dart';

import 'channelSelectors.dart';

class GraphPoint {
  final int x;
  final int y;
  GraphPoint(this.x, this.y);
}

valuesToPoints(List values) {
  List<GraphPoint> points = new List();
  for (var i = 1; i < 1000; i++) {
    points.add(GraphPoint(i, values[i]));
  }
  return points;
}

class Graph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return TimerBuilder.periodic(
        Duration(microseconds: 1), //updates every second
        builder: (context) {
      List<GraphPoint> points0 = valuesToPoints(serialData1);
      List<GraphPoint> points1 = valuesToPoints(serialData2);
      List<GraphPoint> points2 = valuesToPoints(serialData3);
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
