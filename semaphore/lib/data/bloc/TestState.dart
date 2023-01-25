import 'package:flutter/cupertino.dart';

@immutable
class TestState {
  final double angle;

  const TestState.init() : angle = 0;

  TestState.of(TestState prev, {double? angle}) :
      angle = angle ?? prev.angle;
}
