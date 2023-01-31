import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class TestEvent {}

class StartProcessingEvent extends TestEvent {
  Isolate isolate;

  StartProcessingEvent(this.isolate);
}

class UpdateProcessingEvent extends TestEvent {
  String label;
  double processingPercent;

  UpdateProcessingEvent(this.label, this.processingPercent);
}

class CancelProcessingEvent extends TestEvent {}

class CompleteProcessingEvent extends TestEvent {
  Uint8List data;

  CompleteProcessingEvent(this.data);
}

class UpdateImageDataEvent extends TestEvent {
  final Uint8List data;

  UpdateImageDataEvent(this.data);
}

class UpdateSettingsEvent extends TestEvent {
  final int? fps;
  final double? signalTime;
  final double? tweenTime;


  UpdateSettingsEvent({this.fps, this.signalTime, this.tweenTime});
}


class StartPreviewEvent extends TestEvent {}

class StopPreviewEvent extends TestEvent {}

class IncrementPreviewFrameEvent extends TestEvent {}

class UpdateTextEvent extends TestEvent {
  String text;

  UpdateTextEvent(this.text);
}

class InitiateProcessingEvent extends TestEvent{}