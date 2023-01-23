import 'package:semaphore/classes/signal.dart';
import 'package:semaphore/enum/hand_position.dart';
import 'package:semaphore/enum/signal_type.dart';

class SimpleSignal extends Signal {
  ///The position to draw the left hand of the flag bearer
  HandPosition left;
  ///The position to draw the right hand of the flag bearer
  HandPosition right;

  SimpleSignal({required SignalType type, required this.left, required this.right}) : super(type: type);
}