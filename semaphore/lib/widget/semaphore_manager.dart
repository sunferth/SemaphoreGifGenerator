import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:semaphore/enum/hand_position.dart';

import '../classes/angle_signal.dart';
import '../data/animation_manager.dart';
import '../data/bloc/TestBloc.dart';
import '../data/bloc/TestEvent.dart';
import '../enum/alphabetical_signal.dart';
import '../enum/signal_type.dart';
import 'package:collection/collection.dart';

class SemaphoreManager {
  //startAnimationGeneration(signals, manager, bloc);

  static List<AngleSignal> convertStringToSignals(String text) {
    List<AngleSignal> signals = [];

    for(String char in text.characters)
    {
      AlphabeticalSignal? signal = AlphabeticalSignal.values.firstWhereOrNull((element) => element.name.toLowerCase() == char.toLowerCase());
      if(signal == null && char == " ")
      {
        signals.add(AngleSignal(type: SignalType.endOfWord, left: 280/180 * pi, right: -100/180 * pi));
      }
      else if(signal != null)
      {
        signals.add(AngleSignal(type: SignalType.alphabetical, left: signal.signal.left.handPositionAngle, right: signal.signal.right.handPositionAngle));
      }
    }

    signals.add(AngleSignal(type: SignalType.endOfWord, left: 280/180 * pi, right: 260/180 * pi));
    signals.add(AngleSignal(type: SignalType.endOfWord, left: 280/180 * pi, right: 260/180 * pi));

    return signals;
  }

  static void generateAnimation(SendPort sendPort) async {

    ReceivePort receivePort = ReceivePort();
    sendPort.send({"message":"sender", "value":receivePort.sendPort});

    Completer<List<dynamic>> c1 = Completer();

    receivePort.listen((message) {
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



  static void startAnimationGeneration(List<AngleSignal> signals, AnimationManager manager, TestBloc bloc) async {
    ReceivePort port = ReceivePort();

    List<Uint8List?> signalImages = await manager.generateSignalImages(signals);
    List<Uint8List?> tweenImages = await manager.generateTweenFrames(signals);

    Completer<SendPort> sendPortCompleter = Completer();

    port.listen((message) {
      Map<String, dynamic> messageMap = message;
      if(message["message"] == "sender")
      {
        sendPortCompleter.complete(messageMap["value"]);
      }
      else if(message["message"] != "Done")
      {
        bloc.add(UpdateProcessingEvent(message["message"], (message["value"] is int) ? ((message["value"] as int).toDouble) : message["value"]));
      }
      else
      {
        //FileSaver.instance.saveFile("Test", message["value"], ".gif");
        bloc.add(CompleteProcessingEvent(message["value"] as Uint8List));
      }
    });

    List<dynamic> toSend = [signals, signalImages, tweenImages, manager];
    sendPortCompleter.future.then((value) => value.send({"message":"data", "value":toSend}));

    bloc.add(UpdateProcessingEvent("Generating Images", 1));

    SendPort sendPort = port.sendPort;

    Isolate.spawn<SendPort>(generateAnimation, sendPort).then((value) =>
      bloc.add(StartProcessingEvent(value))
    );
  }
}