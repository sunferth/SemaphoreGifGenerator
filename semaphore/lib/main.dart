import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semaphore/data/bloc/TestEvent.dart';
import 'package:semaphore/enum/alphabetical_signal.dart';
import 'package:semaphore/enum/animation_manager.dart';
import 'package:semaphore/enum/hand_position.dart';
import 'package:semaphore/widget/AngleSignalPainter.dart';
import 'package:semaphore/widget/SimpleSignalPainter.dart';

import 'classes/angle_signal.dart';
import 'data/bloc/TestBloc.dart';
import 'data/bloc/TestState.dart';
import 'enum/signal_type.dart';
import 'package:image/image.dart' as img;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    TestBloc bloc = TestBloc();

    AnimationManager manager = AnimationManager(tweenTime: 0.5, fps: 20, waitTime: 0.5, width: 250, height: 250, bloc: bloc);
    manager.generateAnimation([
      AngleSignal(type: SignalType.alphabetical, left: AlphabeticalSignal.a.signal.left.handPositionAngle, right: AlphabeticalSignal.a.signal.right.handPositionAngle),
      AngleSignal(type: SignalType.alphabetical, left: AlphabeticalSignal.l.signal.left.handPositionAngle, right: AlphabeticalSignal.l.signal.right.handPositionAngle),
      AngleSignal(type: SignalType.alphabetical, left: AlphabeticalSignal.m.signal.left.handPositionAngle, right: AlphabeticalSignal.m.signal.right.handPositionAngle),
      AngleSignal(type: SignalType.alphabetical, left: AlphabeticalSignal.o.signal.left.handPositionAngle, right: AlphabeticalSignal.o.signal.right.handPositionAngle),
      AngleSignal(type: SignalType.alphabetical, left: AlphabeticalSignal.s.signal.left.handPositionAngle, right: AlphabeticalSignal.s.signal.right.handPositionAngle),
      AngleSignal(type: SignalType.alphabetical, left: AlphabeticalSignal.t.signal.left.handPositionAngle, right: AlphabeticalSignal.t.signal.right.handPositionAngle),
      AngleSignal(type: SignalType.alphabetical, left: -110/180 * pi, right: -110/180 * pi),
      AngleSignal(type: SignalType.alphabetical, left: AlphabeticalSignal.d.signal.left.handPositionAngle, right: AlphabeticalSignal.d.signal.right.handPositionAngle),
      AngleSignal(type: SignalType.alphabetical, left: AlphabeticalSignal.o.signal.left.handPositionAngle, right: AlphabeticalSignal.o.signal.right.handPositionAngle),
      AngleSignal(type: SignalType.alphabetical, left: AlphabeticalSignal.n.signal.left.handPositionAngle, right: AlphabeticalSignal.n.signal.right.handPositionAngle),
      AngleSignal(type: SignalType.alphabetical, left: AlphabeticalSignal.e.signal.left.handPositionAngle, right: AlphabeticalSignal.e.signal.right.handPositionAngle),
      AngleSignal(type: SignalType.alphabetical, left: -110/180 * pi, right: -110/180 * pi),
      AngleSignal(type: SignalType.alphabetical, left: -110/180 * pi, right: -110/180 * pi),
    ]);

    return MaterialApp(
        home: Scaffold(
      body: MultiBlocProvider(providers: [
          BlocProvider<TestBloc>(create: (_) => bloc)
        ], child: Builder(
          builder: (context) {
            return BlocBuilder<TestBloc, TestState>(
            builder: (context, state){
              return Column(
                children: state.processing ? [
                  Text(state.label),
                  CircularProgressIndicator(value: state.percentProcessing,)
                ] :[Text("Not Processing")]
              );
            },
      );
          }
        ))));
  }
}
