import 'dart:typed_data';

import 'package:flutter/material.dart';

String statusCodeToString(int statusCode) {
  List<String> statusString = [
    "tilted to right",
    "tilted to left",
    "left side pit",
    "right side pit",
    "front pit",
    "tilted down",
    "tilted up"
  ];

  if(statusCode == 0) {
    return "Normal";
  }

  String output = "";
  for (int i = 0; i < 7; ++i) {
    if (((statusCode >> i) & 1) == 1) {
      if (output.isEmpty) {
        output = statusString[i];
      } else {
        output += ", ${statusString[i]}";
      }
    }
  }

  output = "${output[0].toUpperCase()}${output.substring(1).toLowerCase()}";
  return output;
}
