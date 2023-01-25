import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semaphore/classes/simple_signal.dart';

class SimpleSignalPainter extends CustomPainter {
  final SimpleSignal signal;
  final double angle;

  SimpleSignalPainter(this.signal, this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    double legLength = 120;
    double torsoLength = 95;
    double legGap = 5;
    double legWidth = 30;
    double armLength = 90;
    double shoulderGap = 4;
    double armWidth = 22;
    double shoulderHeight = 23;

    double rightArmAngle = angle / 180 * pi;

    Paint personFill = Paint();
    personFill.style = PaintingStyle.fill;
    personFill.color = Colors.black;

    Paint inside = Paint();
    inside.style = PaintingStyle.fill;
    inside.color = Colors.blue;

    Paint outside = Paint();
    outside.style = PaintingStyle.fill;
    outside.color = Colors.green;

    Paint rotation = Paint();
    rotation.style = PaintingStyle.fill;
    rotation.color = Colors.yellow;

    canvas.drawCircle(Offset(size.width/2, size.height/2 - 125 ), 25, personFill);

    Path path = new Path();
    //Move to center of the drawing
    path.moveTo(size.width/2, size.height/2 + 22);
    //Draw right half of leg gap
    path.relativeLineTo(legGap/2, 0);
    //Draw right leg inside
    path.relativeLineTo(0, legLength);
    //Draw foot
    path.relativeArcToPoint(Offset(legWidth, 0), radius: Radius.circular(legWidth/2), clockwise: false);
    //Draw right left outside
    path.relativeLineTo(0, -legLength);
    //Draw Torso right outside
    path.relativeLineTo(0, -torsoLength);
    //Draw Right Shoulder Straight
    path.relativeLineTo(0, -shoulderHeight);
    //Draw neck line
    path.relativeLineTo(-(legWidth * 2 + legGap), 0);
    //Draw Left shoulder straight
    path.relativeLineTo(0, shoulderHeight);
    //Draw left torso outside
    path.relativeLineTo(0, torsoLength);
    //Draw left leg outside
    path.relativeLineTo(0, legLength);
    //Draw left foot
    path.relativeArcToPoint(Offset(legWidth, 0), radius: Radius.circular(legWidth/2), clockwise: false);
    //Draw left leg inside
    path.relativeLineTo(0, -legLength);
    //Draw left leg gap
    path.relativeLineTo(legGap/2, 0);
    //TODO round shoulders

    canvas.drawPath(path, personFill);

    Offset topRightShoulder = Offset(size.width/2, size.height/2 + 22)  - Offset(-legGap/2 - legWidth, torsoLength + shoulderHeight);
    Offset bottomRightShoulder = Offset(size.width/2, size.height/2 + 22)  - Offset(-legGap/2 - legWidth, torsoLength);
    Offset rightRotationPoint = (bottomRightShoulder) + Offset(shoulderHeight/2 + 5 , -shoulderHeight/2);

    Offset rightArmBase = rightRotationPoint + Offset(2*shoulderHeight/3 * cos(rightArmAngle), 2*shoulderHeight/3 * sin(rightArmAngle));
    Offset rightInsideArmBase = rightArmBase + Offset(armWidth/2 * cos(pi/2 + rightArmAngle), armWidth/2 * sin(pi/2 + rightArmAngle));
    Offset rightOutsideArmBase = rightArmBase + Offset(armWidth/2 * cos(-pi/2 + rightArmAngle), armWidth/2 * sin(-pi/2 + rightArmAngle));

    Path rightArm = Path();
    rightArm.moveTo(bottomRightShoulder.dx, bottomRightShoulder.dy);

    rightArm.quadraticBezierTo(getXIntersect(bottomRightShoulder, rightInsideArmBase, rightInsideArmBase + Offset(armLength * cos(rightArmAngle), armLength * sin(rightArmAngle))), bottomRightShoulder.dy, rightInsideArmBase.dx, rightInsideArmBase.dy);

    rightArm.relativeLineTo(armLength * cos(rightArmAngle), armLength * sin(rightArmAngle));
    rightArm.relativeArcToPoint(rightOutsideArmBase - rightInsideArmBase, radius: Radius.circular(armWidth /2), clockwise: false);
    rightArm.relativeLineTo(-armLength * cos(rightArmAngle), -armLength * sin(rightArmAngle));
    rightArm.quadraticBezierTo(getXIntersect(topRightShoulder, rightOutsideArmBase, rightOutsideArmBase + Offset(armLength * cos(rightArmAngle), armLength * sin(rightArmAngle)) ), topRightShoulder.dy, topRightShoulder.dx, topRightShoulder.dy);
    rightArm.relativeLineTo(0, shoulderHeight);

    Path rightArmStroke = Path();
    rightArmStroke.moveTo(rightInsideArmBase.dx + armLength * .2 * cos(rightArmAngle), rightInsideArmBase.dy + .2 * armLength * sin(rightArmAngle));
    rightArmStroke.relativeLineTo(.8* armLength * cos(rightArmAngle), .8 * armLength * sin(rightArmAngle));
    rightArmStroke.relativeArcToPoint(rightOutsideArmBase - rightInsideArmBase, radius: Radius.circular(armWidth /2), clockwise: false);
    rightArmStroke.relativeLineTo(-0.8 * armLength * cos(rightArmAngle), -0.8 * armLength * sin(rightArmAngle));

    //Left Arm
    double leftArmAngle = pi + rightArmAngle;

    Offset topLeftShoulder = Offset(size.width/2, size.height/2 + 22)  + Offset(-legGap/2 - legWidth, -torsoLength - shoulderHeight);
    Offset bottomLeftShoulder = Offset(size.width/2, size.height/2 + 22)  + Offset(-legGap/2 - legWidth, -torsoLength);
    Offset leftRotationPoint = (bottomLeftShoulder) + Offset(-shoulderHeight/2 - 5 , -shoulderHeight/2);

    Offset leftArmBase = leftRotationPoint + Offset(2*shoulderHeight/3 * cos(leftArmAngle), 2*shoulderHeight/3 * sin(leftArmAngle));
    Offset leftInsideArmBase = leftArmBase + Offset(armWidth/2 * cos(-pi/2 + leftArmAngle), armWidth/2 * sin(-pi/2 + leftArmAngle));
    Offset leftOutsideArmBase = leftArmBase + Offset(armWidth/2 * cos(pi/2 + leftArmAngle), armWidth/2 * sin(pi/2 + leftArmAngle));

    Path leftArm = Path();
    leftArm.moveTo(bottomLeftShoulder.dx, bottomLeftShoulder.dy);

    leftArm.quadraticBezierTo(getXIntersect(bottomLeftShoulder, leftInsideArmBase, leftInsideArmBase + Offset(armLength * cos(leftArmAngle), armLength * sin(leftArmAngle))), bottomLeftShoulder.dy, leftInsideArmBase.dx, leftInsideArmBase.dy);

    leftArm.relativeLineTo(armLength * cos(leftArmAngle), armLength * sin(leftArmAngle));
    leftArm.relativeArcToPoint(leftOutsideArmBase - leftInsideArmBase, radius: Radius.circular(armWidth /2), clockwise: true);
    leftArm.relativeLineTo(-armLength * cos(leftArmAngle), -armLength * sin(leftArmAngle));
    leftArm.quadraticBezierTo(getXIntersect(topLeftShoulder, leftOutsideArmBase, leftOutsideArmBase + Offset(armLength * cos(leftArmAngle), armLength * sin(leftArmAngle)) ), topLeftShoulder.dy, topLeftShoulder.dx, topLeftShoulder.dy);
    leftArm.relativeLineTo(0, shoulderHeight);

    Path leftArmStroke = Path();
    leftArmStroke.moveTo(leftInsideArmBase.dx + armLength * .2 * cos(leftArmAngle), leftInsideArmBase.dy + .2 * armLength * sin(leftArmAngle));
    leftArmStroke.relativeLineTo(.8* armLength * cos(leftArmAngle), .8 * armLength * sin(leftArmAngle));
    leftArmStroke.relativeArcToPoint(leftOutsideArmBase - leftInsideArmBase, radius: Radius.circular(armWidth /2), clockwise: true);
    leftArmStroke.relativeLineTo(-0.8 * armLength * cos(leftArmAngle), -0.8 * armLength * sin(leftArmAngle));






    Paint strokePaint = Paint();

    strokePaint.strokeWidth =  3;
    strokePaint.color = Colors.white;
    strokePaint.style = PaintingStyle.stroke;

    canvas.drawPath(rightArm, personFill);
    canvas.drawPath(rightArmStroke, strokePaint);
    canvas.drawPath(rightArmStroke, personFill);

    canvas.drawPath(leftArm, personFill);
    canvas.drawPath(leftArmStroke, strokePaint);
    canvas.drawPath(leftArmStroke, personFill);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! SimpleSignalPainter && signal != (oldDelegate as SimpleSignalPainter).signal;
  }

  double getXIntersect(Offset shoulderPoint, Offset point1, Offset point2)
  {
    double m = (point1.dy - point2.dy)/(point1.dx - point2.dx);

    if(m < 0)
    {
      m = m*-1;
      if(m < 0.00000001)
      {
        m = -1;
      }
      else
      {
        m = m* -1;
      }
    }
    if(m > 0)
    {
      if(m < 0.00000001)
      {
        m = 1;
      }
    }
    double b = point1.dy - m * point1.dx;
    double x = (shoulderPoint.dy - b)/m;

    if(x > 35 + shoulderPoint.dx)
    {
      x = shoulderPoint.dx + 35;
    }

    if(x < shoulderPoint.dx - 35)
    {
      x = shoulderPoint.dx - 35;
    }

    return x;
  }

}