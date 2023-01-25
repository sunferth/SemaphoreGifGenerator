import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semaphore/data/bloc/TestEvent.dart';
import 'package:semaphore/enum/alphabetical_signal.dart';
import 'package:semaphore/widget/AngleSignalPainter.dart';
import 'package:semaphore/widget/SimpleSignalPainter.dart';

import 'classes/angle_signal.dart';
import 'data/bloc/TestBloc.dart';
import 'data/bloc/TestState.dart';
import 'enum/signal_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: MultiBlocProvider(providers: [
          BlocProvider<TestBloc>(create: (_) => TestBloc())
        ], child: Builder(
          builder: (context) {
            return BlocBuilder<TestBloc, TestState>(
            builder: (context, state){
              return Column(
                children: [
                  SizedBox(height: 100,),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: SimpleSignalPainter(AlphabeticalSignal.a.signal),
                              )),
                            ))),
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: SimpleSignalPainter(AlphabeticalSignal.l.signal),
                              )),
                            ))),
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: SimpleSignalPainter(AlphabeticalSignal.m.signal),
                              )),
                            ))),
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: SimpleSignalPainter(AlphabeticalSignal.o.signal),
                              )),
                            ))),
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: SimpleSignalPainter(AlphabeticalSignal.s.signal),
                              )),
                            ))),
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: SimpleSignalPainter(AlphabeticalSignal.t.signal),
                              )),
                            ))),
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: AngleSignalPainter(AngleSignal(type: SignalType.endOfWord, left: -83/180 * pi, right: -97/180 * pi )),
                              )),
                            ))),
                  ],),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: SimpleSignalPainter(AlphabeticalSignal.d.signal),
                              )),
                            ))),
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: SimpleSignalPainter(AlphabeticalSignal.o.signal),
                              )),
                            ))),
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: SimpleSignalPainter(AlphabeticalSignal.n.signal),
                              )),
                            ))),
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: SimpleSignalPainter(AlphabeticalSignal.e.signal),
                              )),
                            ))),
                    Container(
                        child: Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Transform.scale(scale: .7, child: CustomPaint(
                                painter: AngleSignalPainter(AngleSignal(type: SignalType.endOfWord, left: -83/180 * pi, right: -97/180 * pi )),
                              )),
                            ))),
                  ],)
                ],
              );
            },
      );
          }
        ))));
  }
}
