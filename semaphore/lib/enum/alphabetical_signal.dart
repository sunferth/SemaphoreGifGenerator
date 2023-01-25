import 'dart:math';

import 'package:semaphore/enum/hand_position.dart';
import 'package:semaphore/enum/signal_type.dart';

import '../classes/signal.dart';
import '../classes/simple_signal.dart';

enum AlphabeticalSignal {
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  h,
  i,
  j,
  k,
  l,
  m,
  n,
  o,
  p,
  q,
  r,
  s,
  t,
  u,
  v,
  w,
  x,
  y,
  z,
  eow
}

extension AphabeticalSignalExt on AlphabeticalSignal {
  SimpleSignal get signal {
    switch(this)
    {
      case AlphabeticalSignal.a:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.down, right: HandPosition.rightDown);
      case AlphabeticalSignal.b:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.down, right: HandPosition.right);
      case AlphabeticalSignal.c:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.down, right: HandPosition.rightUp);
      case AlphabeticalSignal.d:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.down, right: HandPosition.up);
      case AlphabeticalSignal.e:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.leftUp, right: HandPosition.down);
      case AlphabeticalSignal.f:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.left, right: HandPosition.down);
      case AlphabeticalSignal.g:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.leftDown, right: HandPosition.down);
      case AlphabeticalSignal.h:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.rightDown, right: HandPosition.right);
      case AlphabeticalSignal.i:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.rightDown, right: HandPosition.rightUp);
      case AlphabeticalSignal.j:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.left, right: HandPosition.up);
      case AlphabeticalSignal.k:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.up, right: HandPosition.rightDown);
      case AlphabeticalSignal.l:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.leftUp, right: HandPosition.rightDown);
      case AlphabeticalSignal.m:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.left, right: HandPosition.rightDown);
      case AlphabeticalSignal.n:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.leftDown, right: HandPosition.rightDown);
      case AlphabeticalSignal.o:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.right, right: HandPosition.rightUp);
      case AlphabeticalSignal.p:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.up, right: HandPosition.right);
      case AlphabeticalSignal.q:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.leftUp, right: HandPosition.right);
      case AlphabeticalSignal.r:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.left, right: HandPosition.right);
      case AlphabeticalSignal.s:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.leftDown, right: HandPosition.right);
      case AlphabeticalSignal.t:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.up, right: HandPosition.rightUp);
      case AlphabeticalSignal.u:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.leftUp, right: HandPosition.rightUp);
      case AlphabeticalSignal.v:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.leftDown, right: HandPosition.up);
      case AlphabeticalSignal.w:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.leftUp, right: HandPosition.left);
      case AlphabeticalSignal.x:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.leftUp, right: HandPosition.leftDown);
      case AlphabeticalSignal.y:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.left, right: HandPosition.rightUp);
      case AlphabeticalSignal.z:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.left, right: HandPosition.leftDown);
      case AlphabeticalSignal.eow:
        return SimpleSignal(type: SignalType.alphabetical, left: HandPosition.down, right: HandPosition.down);
    }
  }
}

