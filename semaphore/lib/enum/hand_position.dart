import 'dart:math';

enum HandPosition {
  down,
  leftDown,
  left,
  leftUp,
  up,
  rightUp,
  right,
  rightDown
}

extension HandPositionExt on HandPosition {
  double get handPositionAngle {
    double angleDegrees;
    switch (this) {
      case HandPosition.leftDown:
        angleDegrees = 0;
        break;
      case HandPosition.left:
        angleDegrees = 0;
        break;
      case HandPosition.leftUp:
        angleDegrees = 0;
        break;
      case HandPosition.up:
        angleDegrees = 0;
        break;
      case HandPosition.rightUp:
        angleDegrees = 0;
        break;
      case HandPosition.right:
        angleDegrees = 0;
        break;
      case HandPosition.rightDown:
        angleDegrees = 0;
        break;
      case HandPosition.down:
      default:
        angleDegrees = 0;
    }
    return angleDegrees * pi / 180;
  }
}
