import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semaphore/data/bloc/TestEvent.dart';
import 'package:semaphore/enum/alphabetical_signal.dart';
import 'package:semaphore/widget/SimpleSignalPainter.dart';

import 'data/bloc/TestBloc.dart';
import 'data/bloc/TestState.dart';

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
              return Stack(children: [
                Positioned(top: 100, child: Slider(min: -180, max: 180, value: state.angle, onChanged: (angle) =>BlocProvider.of<TestBloc>(context).add(ChangeAngleEvent(angle),))),
                // Center(
                //     child: Image.asset(
                //       "assets/images/Person.png",
                //       width: 150,
                //       height: 300,
                //     )),
                Container(
                    child: Center(
                        child: Container(
                          width: 150,
                          height: 300,
                          child: CustomPaint(
                            painter: SimpleSignalPainter(AlphabeticalSignal.a.signal, state.angle),
                          ),
                        ))),
              ]);
            },
      );
          }
        ))));
  }
}
