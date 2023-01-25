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
        angleDegrees = -135;
        break;
      case HandPosition.left:
        angleDegrees = 180;
        break;
      case HandPosition.leftUp:
        angleDegrees = 135;
        break;
      case HandPosition.up:
        angleDegrees = 90;
        break;
      case HandPosition.rightUp:
        angleDegrees = 45;
        break;
      case HandPosition.right:
        angleDegrees = 0;
        break;
      case HandPosition.rightDown:
        angleDegrees = -45;
        break;
      case HandPosition.down:
      default:
        angleDegrees = -90;
    }
    return angleDegrees * pi / 180;
  }
}
