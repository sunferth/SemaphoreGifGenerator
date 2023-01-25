import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class TestEvent {}

class ChangeAngleEvent extends TestEvent {
  final double angle;

  ChangeAngleEvent(this.angle);
}