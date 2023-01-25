import 'package:semaphore/classes/signal.dart';
import 'package:semaphore/enum/hand_position.dart';
import 'package:semaphore/enum/signal_type.dart';

class AngleSignal extends Signal {
  ///The position to draw the left hand of the flag bearer
  double left;
  ///The position to draw the right hand of the flag bearer
  double right;

  AngleSignal({required SignalType type, required this.left, required this.right}) : super(type: type);
}