
import 'package:flutter_bloc/flutter_bloc.dart';
import 'TestEvent.dart';
import 'TestState.dart';

class TestBloc extends Bloc<TestEvent, TestState>
{
  TestBloc() : super(TestState.init()) {
    on<StartProcessingEvent>(_handleStartProcessingEvent);
    on<StopProcessingEvent>(_handleStopProcessingEvent);
    on<UpdateProcessingevent>(_handleUpdateProcessingevent);
    on<UpdateImageDataEvent>(_handleUpdateImageDataEvent);
  }

  void _handleStartProcessingEvent(StartProcessingEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, processing: true, label: "Waiting to start", percentProcessing: 0));
  }
  void _handleStopProcessingEvent(StopProcessingEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, processing: false, label: "", percentProcessing: 0));
  }
  void _handleUpdateProcessingevent(UpdateProcessingevent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, processing: true, label: event.label, percentProcessing: event.processingPercent));
  }
  void _handleUpdateImageDataEvent(UpdateImageDataEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, data:  event.data));
  }
}