
import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semaphore/data/bloc/TestEvent.dart';
import 'package:semaphore/enum/hand_position.dart';
import 'package:semaphore/widget/AngleSignalPainter.dart';

import 'classes/angle_signal.dart';
import 'data/bloc/TestBloc.dart';
import 'data/bloc/TestState.dart';
import 'enum/alphabetical_signal.dart';
import 'enum/animation_manager.dart';
import 'enum/signal_type.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    startAnimationGeneration(signals, manager, bloc);
  }

  static void generateAnimation(SendPort sendPort) async {

    ReceivePort receivePort = ReceivePort();
    sendPort.send({"message":"sender", "value":receivePort.sendPort});

    Completer<List<dynamic>> c1 = Completer();

    receivePort.listen((message) {
      print("From main: $message");

      Map<String, dynamic> messageMap = message;
      if(message["message"] == "data")
      {
        c1.complete(messageMap["value"]);
      }
    });

    c1.future.then((value){
      sendPort.send({"message": "Starting processing", "value": .5});
      value[3].generateAnimation(value[0], value[1], value[2], sendPort);
    });


  }

  TestBloc bloc = TestBloc();
  List<AngleSignal> signals = [
    AngleSignal(type: SignalType.alphabetical,
        left: AlphabeticalSignal.a.signal.left.handPositionAngle,
        right: AlphabeticalSignal.a.signal.right.handPositionAngle),
    AngleSignal(type: SignalType.alphabetical,
        left: AlphabeticalSignal.l.signal.left.handPositionAngle,
        right: AlphabeticalSignal.l.signal.right.handPositionAngle),
    AngleSignal(type: SignalType.alphabetical,
        left: AlphabeticalSignal.m.signal.left.handPositionAngle,
        right: AlphabeticalSignal.m.signal.right.handPositionAngle),
    AngleSignal(type: SignalType.alphabetical,
        left: AlphabeticalSignal.o.signal.left.handPositionAngle,
        right: AlphabeticalSignal.o.signal.right.handPositionAngle),
    AngleSignal(type: SignalType.alphabetical,
        left: AlphabeticalSignal.s.signal.left.handPositionAngle,
        right: AlphabeticalSignal.s.signal.right.handPositionAngle),
    AngleSignal(type: SignalType.alphabetical,
        left: AlphabeticalSignal.t.signal.left.handPositionAngle,
        right: AlphabeticalSignal.t.signal.right.handPositionAngle),
    AngleSignal(type: SignalType.alphabetical,
        left: -80 / 180 * pi,
        right: -100 / 180 * pi),
    AngleSignal(type: SignalType.alphabetical,
        left: AlphabeticalSignal.d.signal.left.handPositionAngle,
        right: AlphabeticalSignal.d.signal.right.handPositionAngle),
    AngleSignal(type: SignalType.alphabetical,
        left: AlphabeticalSignal.o.signal.left.handPositionAngle,
        right: AlphabeticalSignal.o.signal.right.handPositionAngle),
    AngleSignal(type: SignalType.alphabetical,
        left: AlphabeticalSignal.n.signal.left.handPositionAngle,
        right: AlphabeticalSignal.n.signal.right.handPositionAngle),
    AngleSignal(type: SignalType.alphabetical,
        left: AlphabeticalSignal.e.signal.left.handPositionAngle,
        right: AlphabeticalSignal.e.signal.right.handPositionAngle),
    AngleSignal(type: SignalType.alphabetical,
        left: -80 / 180 * pi,
        right: -100 / 180 * pi),
    AngleSignal(type: SignalType.alphabetical,
        left: -80 / 180 * pi,
        right: -100 / 180 * pi),
  ];


  AnimationManager manager = AnimationManager(tweenTime: 0.5,
      fps: 20,
      waitTime: 0.5,
      width: 250,
      height: 250);



  void startAnimationGeneration(List<AngleSignal> signals, AnimationManager manager, TestBloc bloc) async {
    ReceivePort port = ReceivePort();

    List<Uint8List?> signalImages = await manager.generateSignalImages(signals);
    List<Uint8List?> tweenImages = await manager.generateTweenFrames(signals);

    Completer<SendPort> sendPortCompleter = Completer();

    port.listen((message) {
      print("From isolate: $message");

      Map<String, dynamic> messageMap = message;
      if(message["message"] == "sender")
      {
        sendPortCompleter.complete(messageMap["value"]);
      }
      else if(message["message"] != "Done")
      {
        bloc.add(UpdateProcessingEvent(message["message"], message["value"]));
      }
      else
      {
        FileSaver.instance.saveFile("Test", message["value"], ".gif");
        bloc.add(StopProcessingEvent());
      }
    });

     List<dynamic> toSend = [signals, signalImages, tweenImages, manager];
     sendPortCompleter.future.then((value) => value.send({"message":"data", "value":toSend}));

    bloc.add(UpdateProcessingEvent("Generating Images", 1));

    SendPort sendPort = port.sendPort;

    await Isolate.spawn<SendPort>(generateAnimation, sendPort);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("redrawing");

    return MaterialApp(
        home: Scaffold(
            body: MultiBlocProvider(providers: [
              BlocProvider<TestBloc>(create: (_) => bloc)
            ], child: Builder(
                builder: (context) {
                  return BlocBuilder<TestBloc, TestState>(
                    builder: (context, state) {
                      print("redrawing");
                      return Center(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: state.processing ? [
                              Text(state.label),
                              CircularProgressIndicator(
                                value: state.percentProcessing,)
                            ] : [Container(color: Colors.black, width: 250, height: 250,  child: CustomPaint(painter: AngleSignalPainter(
                              AngleSignal(type: SignalType.alphabetical,
                                  left: -80 / 180 * pi,
                                  right: -100 / 180 * pi),
                            ),))]
                        ),
                      );
                    },
                  );
                }
            ))));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
