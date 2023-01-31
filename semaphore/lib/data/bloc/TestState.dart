import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import '../../classes/angle_signal.dart';

@immutable
class TestState {
  String text;

  List<AngleSignal> previewSignals;
  int currentPreviewFrameIndex;
  bool previewing;
  Timer? previewTimer;
  //Processing Information
  final double percentProcessing;
  final String label;
  //Processing fields
  final bool processing;
  final Uint8List? data;
  final Isolate? isolate;
  //Settings
  final int fps;
  final double signalTime;
  final double tweenTime;

  TestState.init() :
        percentProcessing = 0,
        label = "",
        fps = 24,
        signalTime = 0.5,
        tweenTime = 0.5,
        processing = false,
        data = null,
        previewing = false,
        previewSignals = [],
        currentPreviewFrameIndex = 0,
        previewTimer = null,
        isolate = null,
        text = "";

  TestState.of(TestState prev, {double? percentProcessing, Uint8List? data, bool? processing, String? label, int? fps, double? signalTime, double? tweenTime, List<AngleSignal>? previewSignals, int? frameIndex, bool? previewing, Timer? previewTimer, String? text, Isolate? isolate}) :
      percentProcessing = percentProcessing ?? prev.percentProcessing,
      processing = processing ?? prev.processing,
      label = label ?? prev.label,
      data = data ?? prev.data,
      fps = fps ?? prev.fps,
      signalTime = signalTime ?? prev.signalTime,
      tweenTime = tweenTime ?? prev.tweenTime,
      previewSignals = previewSignals ?? prev.previewSignals,
      previewing = previewing ?? prev.previewing,
      currentPreviewFrameIndex = frameIndex ?? prev.currentPreviewFrameIndex,
      previewTimer = previewTimer ?? prev.previewTimer,
      text = text ?? prev.text,
      isolate = isolate ?? prev.isolate;

  TestState.clearTimer(TestState prev) :
        percentProcessing = prev.percentProcessing,
        processing = prev.processing,
        label = prev.label,
        data = prev.data,
        fps = prev.fps,
        signalTime = prev.signalTime,
        tweenTime = prev.tweenTime,
        previewSignals = prev.previewSignals,
        previewing = prev.previewing,
        currentPreviewFrameIndex = prev.currentPreviewFrameIndex,
        previewTimer = null,
        text = prev.text,
        isolate = prev.isolate;

  TestState.clearIsolate(TestState prev) :
        percentProcessing = prev.percentProcessing,
        processing = prev.processing,
        label = prev.label,
        data = prev.data,
        fps = prev.fps,
        signalTime = prev.signalTime,
        tweenTime = prev.tweenTime,
        previewSignals = prev.previewSignals,
        previewing = prev.previewing,
        currentPreviewFrameIndex = prev.currentPreviewFrameIndex,
        previewTimer = prev.previewTimer,
        text = prev.text,
        isolate = null;
}
