import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class TestEvent {}

class StartProcessingEvent extends TestEvent {}

class UpdateProcessingEvent extends TestEvent {
  String label;
  double processingPercent;

  UpdateProcessingEvent(this.label, this.processingPercent);
}

class StopProcessingEvent extends TestEvent {}

class UpdateImageDataEvent extends TestEvent {
  final Uint8List data;

  UpdateImageDataEvent(this.data);
}