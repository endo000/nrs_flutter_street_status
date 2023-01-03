import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_project/street_status/status_code.dart';
import 'package:flutter_project/widgets/street_status.dart';

class PortScreen extends StatefulWidget {
  const PortScreen(this.portName, {Key? key}) : super(key: key);

  final String portName;

  @override
  State<PortScreen> createState() => _PortScreenState();
}

class _PortScreenState extends State<PortScreen> {
  late final SerialPort port;
  late StreamSubscription readerStream;
  String status = "";
  int statusCode = 0;

  @override
  void initState() {
    port = SerialPort(widget.portName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.portName),
      ),
      body: WillPopScope(
        onWillPop: () async {
          _closePort();
          return true;
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                    onPressed: port.isOpen ? null : _openPort,
                    child: const Text("Open port"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: port.isOpen ? _closePort : null,
                    child: const Text("Close port"),
                  ),
                ],
              ),
            ),
            Expanded(child: StreetStatus(statusCode: statusCode))
          ],
        ),
      ),
    );
  }

  _openPort() {
    setState(() {
      try {
        if (!port.isOpen){
          port.openRead();
          port.config = SerialPortConfig()
            ..baudRate = 9600
            ..bits = 8
            ..stopBits = 1
            ..parity = SerialPortParity.none
            ..setFlowControl(SerialPortFlowControl.none);
        }
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Can't open, error: ${e.toString()}")));
      }
    });

    if (port.isOpen) {
      SerialPortReader reader = SerialPortReader(port);
      readerStream = reader.stream.listen((data) {
        // print('received data: ${data}');
        if (data[0] == 0xAB && data[1] == 0xAC) {
          List<int> packetNumber = data.sublist(2, 2 + 2);
          // print('packet: ${packetNumber}');
          setState(() {
            statusCode = data[4];
            status = statusCodeToString(statusCode);
          });
        }
      });
    }
  }

  _closePort() {
    setState(() {
      if (port.isOpen) {
        readerStream.cancel().then((value) {
          port.close();
        });
      }
    });
  }
}
