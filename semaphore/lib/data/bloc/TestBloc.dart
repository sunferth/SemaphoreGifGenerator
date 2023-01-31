
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semaphore/classes/angle_signal.dart';
import 'package:semaphore/data/animation_manager.dart';
import 'package:semaphore/widget/semaphore_manager.dart';
import 'TestEvent.dart';
import 'TestState.dart';

class TestBloc extends Bloc<TestEvent, TestState>
{
  TestBloc() : super(TestState.init()) {
    on<StartProcessingEvent>(_handleStartProcessingEvent);
    on<CompleteProcessingEvent>(_handleCompleteProcessingEvent);
    on<UpdateProcessingEvent>(_handleUpdateProcessingEvent);
    on<UpdateImageDataEvent>(_handleUpdateImageDataEvent);
    on<UpdateSettingsEvent>(_handleUpdateSettingsEvent);
    on<StartPreviewEvent>(_handleStartPreviewEvent);
    on<StopPreviewEvent>(_handleStopPreviewEvent);
    on<IncrementPreviewFrameEvent>(_handleIncrementPreviewFrameEvent);
    on<UpdateTextEvent>(_handleUpdateTextEvent);
    on<InitiateProcessingEvent>(_handleInitiateProcessingEvent);
    on<CancelProcessingEvent>(_handleCancelProcessingEvent);
  }

  void _handleStartProcessingEvent(StartProcessingEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, processing: true, label: "Waiting to start", percentProcessing: 0));
  }
  void _handleCompleteProcessingEvent(CompleteProcessingEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, processing: false, label: "", percentProcessing: 0, data: event.data));
  }
  void _handleCancelProcessingEvent(CancelProcessingEvent event, Emitter<TestState> emit)
  {
    state.isolate?.kill();
    emit(TestState.of(TestState.clearIsolate(state), processing: false, label: "", percentProcessing: 0));
  }
  void _handleUpdateProcessingEvent(UpdateProcessingEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, processing: true, label: event.label, percentProcessing: event.processingPercent));
  }
  void _handleUpdateImageDataEvent(UpdateImageDataEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, data:  event.data));
  }

  void _handleUpdateSettingsEvent(UpdateSettingsEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, fps: event.fps, signalTime: event.signalTime, tweenTime: event.tweenTime));
  }
  void _handleStartPreviewEvent(StartPreviewEvent event, Emitter<TestState> emit)
  {
    AnimationManager manager = AnimationManager(tweenTime: state.tweenTime, fps: state.fps.toDouble(), waitTime: state.signalTime, width: 256, height: 256);
    List<AngleSignal> signals = SemaphoreManager.convertStringToSignals(state.text);
    signals = manager.generatePreviewSignals(signals);
    Timer timer = Timer.periodic(Duration(milliseconds: (1000/state.fps).ceil()), (timer) {
      add(IncrementPreviewFrameEvent());
    });
    emit(TestState.of(state, previewing: true, frameIndex: 0, previewSignals: signals, previewTimer: timer));
  }
  void _handleStopPreviewEvent(StopPreviewEvent event, Emitter<TestState> emit)
  {
    state.previewTimer?.cancel();
    emit(TestState.of(TestState.clearTimer(state), previewing: false, frameIndex: 0, previewSignals: [], ));
  }

  void _handleIncrementPreviewFrameEvent(IncrementPreviewFrameEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, frameIndex: state.currentPreviewFrameIndex + 1));
  }


  void _handleUpdateTextEvent(UpdateTextEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, text: event.text));
  }

  void _handleInitiateProcessingEvent(InitiateProcessingEvent event, Emitter<TestState> emit)
  {
    AnimationManager manager = AnimationManager(tweenTime: state.tweenTime, fps: state.fps.toDouble(), waitTime: state.signalTime, width: 256, height: 256);
    SemaphoreManager.startAnimationGeneration(SemaphoreManager.convertStringToSignals(state.text), manager, this);
  }
}

