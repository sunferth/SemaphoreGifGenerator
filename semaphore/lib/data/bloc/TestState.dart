import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

@immutable
class TestState {
  final double percentProcessing;
  final String label;
  final bool processing;
  final Uint8List? data;

  const TestState.init() : percentProcessing = 0, label = "", processing = false, data = null;

  TestState.of(TestState prev, {double? percentProcessing, Uint8List? data, bool? processing, String? label}) :
      percentProcessing = percentProcessing ?? prev.percentProcessing,
      processing = processing ?? prev.processing,
      label = label ?? prev.label,
      data = data ?? prev.data;// {
    //print("$label: $percentProcessing");
  //}
}
