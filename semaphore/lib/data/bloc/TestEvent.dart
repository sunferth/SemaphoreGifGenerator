import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class TestEvent {}

class StartProcessingEvent extends TestEvent {}

class UpdateProcessingevent extends TestEvent {
  String label;
  double processingPercent;

  UpdateProcessingevent(this.label, this.processingPercent);
}

class StopProcessingEvent extends TestEvent {}

class UpdateImageDataEvent extends TestEvent {
  final Uint8List data;

  UpdateImageDataEvent(this.data);
}