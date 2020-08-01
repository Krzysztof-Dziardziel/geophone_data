import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:timer_builder/timer_builder.dart';

class GraphPoint {
  final int x;
  final int y;
  GraphPoint(this.x, this.y);
}

valuesToPoints(List values) {
  List<GraphPoint> points = new List();
  for (int i = 0; i < 1023; i++) {
    points.add(GraphPoint(i, values[i]));
  }
  return points;
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    int dataPack = 0;
    return TimerBuilder.periodic(Duration(seconds: 1), //updates every second
        builder: (context) {
      // List<GraphPoint> points0 = valuesToPoints(exampleData[dataPack], 0);
      // List<GraphPoint> points1 = valuesToPoints(exampleData[dataPack], 1);
      // List<GraphPoint> points2 = valuesToPoints(exampleData[dataPack], 2);
      dataPack++;
      if (dataPack == 32) dataPack = 0;
      getSeriesData() {
        List<charts.Series<GraphPoint, int>> series = [
          charts.Series(
              id: "0",
              // data: points0,
              domainFn: (GraphPoint series, _) => series.x,
              measureFn: (GraphPoint series, _) => series.y,
              colorFn: (GraphPoint series, _) =>
                  charts.MaterialPalette.blue.shadeDefault),
          charts.Series(
              id: "1",
              // data: points1,
              domainFn: (GraphPoint series, _) => series.x,
              measureFn: (GraphPoint series, _) => series.y,
              colorFn: (GraphPoint series, _) =>
                  charts.MaterialPalette.red.shadeDefault),
          charts.Series(
              id: "2",
              // data: points2,
              domainFn: (GraphPoint series, _) => series.x,
              measureFn: (GraphPoint series, _) => series.y,
              colorFn: (GraphPoint series, _) =>
                  charts.MaterialPalette.green.shadeDefault)
        ];
        return series;
      }

      return Container(
        height: height,
        width: width,
        child: charts.LineChart(
          getSeriesData(),
          animate: false,
        ),
      );
    });
  }
}
