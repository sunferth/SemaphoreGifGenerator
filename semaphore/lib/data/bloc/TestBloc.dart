import 'package:flutter_bloc/flutter_bloc.dart';

import 'TestEvent.dart';
import 'TestState.dart';
import 'TestState.dart';

class TestBloc extends Bloc<TestEvent, TestState>
{
  TestBloc() : super(const TestState.init()) {
    on<ChangeAngleEvent>(_handleChangeAngleEvent);
  }

  void _handleChangeAngleEvent(ChangeAngleEvent event, Emitter<TestState> emit)
  {
    emit(TestState.of(state, angle: event.angle));
  }
}