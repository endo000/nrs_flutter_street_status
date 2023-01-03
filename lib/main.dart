import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_project/screens/port_screen.dart';
import 'package:flutter_project/widgets/street_status.dart';

void main() => runApp(const StreetStatusApp());

class StreetStatusApp extends StatefulWidget {
  const StreetStatusApp({super.key});

  @override
  State<StreetStatusApp> createState() => _StreetStatusAppState();
}

class _StreetStatusAppState extends State<StreetStatusApp> {
  var availablePorts = [];

  @override
  void initState() {
    super.initState();
    initPorts();
  }

  void initPorts() {
    setState(() => availablePorts = SerialPort.availablePorts);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Serial Port example'),
        ),
        body: Scrollbar(
          child: ListView.builder(
              itemCount: availablePorts.length,
              itemBuilder: (BuildContext context, int index) {
                final port = SerialPort(availablePorts[index]);
                return ListTile(
                  title: Text(availablePorts[index]),
                  subtitle: Text(port.productName ?? "Unknown product name"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PortScreen(availablePorts[index])));
                  },
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: initPorts,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
