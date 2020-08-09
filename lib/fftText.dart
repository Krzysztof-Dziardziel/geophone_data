import 'package:fft/fft.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';

class FFTText extends StatefulWidget {
  @override
  _FFTTextState createState() => _FFTTextState();
}

class _FFTTextState extends State<FFTText> {
  @override
  Widget build(BuildContext context) {
    var data = serialData1.map((element) => element.toDouble());
    var fft = new FFT().Transform(data.toList());
    return Container(
      child: Text(
        // fft.toString(),
        fft.map((complex) => complex.real.toInt()).toList().toString(),
      ),
    );
  }
}
