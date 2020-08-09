import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_esp32_usb_serial/graph.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

import 'channelSelectors.dart';
import 'fft.dart';
import 'fftText.dart';

void main() => runApp(MyApp());

List<int> serialData1 = [];
List<int> serialData2 = [];
List<int> serialData3 = [];
bool isActive = false;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UsbPort _port;
  // ignore: unused_field
  String status = "Idle";
  List<Widget> _ports = [];
  List<GraphPoint> data1 = [];
  List<GraphPoint> data2 = [];
  List<GraphPoint> data3 = [];

  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  // ignore: unused_field
  TextEditingController _textController = TextEditingController();

  Future<bool> _connectTo(device) async {
    serialData1.clear();
    serialData2.clear();
    serialData3.clear();

    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port.close();
      _port = null;
    }

    if (device == null) {
      _deviceId = null;
      setState(() {
        status = "Disconnected";
        isActive = false;
      });
      return true;
    }

    _port = await device.create();
    if (!await _port.open()) {
      setState(() {
        status = "Failed to open port";
        isActive = false;
      });
      return false;
    }

    _deviceId = device.deviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(
        100000, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port.inputStream, Uint8List.fromList([10]));

    _subscription = _transaction.stream.listen((String line) {
      setState(() {
        var workingArr = line.split(' ');
        serialData1.add(hexToDec(workingArr[0]));
        serialData2.add(hexToDec(workingArr[1]));
        serialData3.add(hexToDec(workingArr[2]));
        if (serialData1.length > 1024) serialData1.removeAt(1);
        if (serialData2.length > 1024) serialData2.removeAt(1);
        if (serialData3.length > 1024) serialData3.removeAt(1);
      });
    });

    setState(() {
      status = "Connected";
      isActive = true;
    });
    return true;
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);

    devices.forEach((device) {
      _ports.add(ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName),
          subtitle: Text(device.manufacturerName),
          trailing: RaisedButton(
            child:
                Text(_deviceId == device.deviceId ? "Disconnect" : "Connect"),
            onPressed: () {
              _connectTo(_deviceId == device.deviceId ? null : device)
                  .then((res) {
                _getPorts();
              });
            },
          )));
    });

    setState(() {
      print(_ports);
    });
  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Material(
          child: Column(
            children: <Widget>[
              if (!isActive) ..._ports,
              if (isActive)
                Expanded(
                  flex: 1,
                  child: ChannelSelectors(),
                ),
              Expanded(
                flex: 4,
                child: Graph(),
              ),
              // Expanded(
              //   flex: 4,
              //   child: FFTWidget(),
              // ),
              // Expanded(
              //   flex: 1,
              //   child: FFTText(),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

hexToDec(String hex) {
  if (int.parse(hex, radix: 16) > 32768) {
    return int.parse(hex, radix: 16) - 65536;
  }
  return int.parse(hex, radix: 16);
}
