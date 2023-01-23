import 'package:flutter/material.dart';
import 'package:semaphore/enum/alphabetical_signal.dart';
import 'package:semaphore/widget/SimpleSignalPainter.dart';

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
      body: Container(
        color: Colors.grey,
        child: Center(
          child: Container(
            width: 150,
            height: 300,
            color: Colors.white,
            child: CustomPaint(
              painter: SimpleSignalPainter(AlphabeticalSignal.a.signal),
            ),
          ),
        ),
      ),
    ));
  }
}
