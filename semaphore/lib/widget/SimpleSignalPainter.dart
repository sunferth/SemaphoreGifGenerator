import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semaphore/classes/simple_signal.dart';

class SimpleSignalPainter extends CustomPainter {
  final SimpleSignal signal;

  SimpleSignalPainter(this.signal);

  @override
  void paint(Canvas canvas, Size size) {
    double legLength = 100;
    double torsoLength = 80;
    double legGap = 5;
    double legWidth = 20;
    double armLength = 80;
    double shoulderGap = 5;
    double armWidth = 15;
    double shoulderHeight = 20;

    Paint personFill = Paint();
    personFill.style = PaintingStyle.fill;

    Paint personStroke = Paint();
    personStroke.style = PaintingStyle.stroke;
    //personStroke.color = Colors.white;

    canvas.drawCircle(Offset(size.width/2, size.height/2 - 130 ), 25, personFill);

    Path path = new Path();
    path.moveTo(size.width/2, size.height/2);
    path.relativeLineTo(legGap/2, 0);
    path.relativeLineTo(0, 100);
    path.relativeArcToPoint(Offset(legWidth, 0), radius: Radius.circular(legWidth/2), clockwise: false);
    path.relativeLineTo(0, -legLength);
    path.relativeLineTo(0, -torsoLength);
    path.relativeLineTo(shoulderGap, 0);
    path.relativeLineTo(0, armLength);
    path.relativeArcToPoint(Offset(armWidth, 0), radius: Radius.circular(armWidth/2), clockwise: false);
    path.relativeLineTo(0, -armLength);
    path.relativeLineTo(0, -shoulderHeight);
    path.relativeLineTo(-(armWidth * 2 + shoulderGap * 2 + legWidth * 2 + legGap), 0);
    path.relativeLineTo(0, shoulderHeight);
    path.relativeLineTo(0, armLength);
    path.relativeArcToPoint(Offset(armWidth, 0), radius: Radius.circular(armWidth/2), clockwise: false);
    path.relativeLineTo(0, -armLength);
    path.relativeLineTo(shoulderGap, 0);
    path.relativeLineTo(0, torsoLength);
    path.relativeLineTo(0, legLength);
    path.relativeArcToPoint(Offset(legWidth, 0), radius: Radius.circular(legWidth/2), clockwise: false);
    path.relativeLineTo(0, -legLength);
    path.relativeLineTo(legGap/2, 0);
    //TODO round shoulders

    canvas.drawPath(path, personFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! SimpleSignalPainter && signal != (oldDelegate as SimpleSignalPainter).signal;
  }

}