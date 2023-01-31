import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressPainter extends CustomPainter {

  double value;
  double startAngle;
  double sweepAngle;
  Color baseColor;
  Color progressColor;
  double baseWidth;
  double progressWidth;

  CircularProgressPainter({required this.value, required this.startAngle, required this.sweepAngle, required this.baseColor, required this.progressColor, required this.baseWidth, required this.progressWidth});

  @override
  void paint(Canvas canvas, Size size) {

    Paint basePaint = Paint();
    basePaint.color = baseColor;
    basePaint.strokeWidth = baseWidth;
    basePaint.style = PaintingStyle.stroke;
    basePaint.strokeCap = StrokeCap.round;

    Paint progressPaint = Paint();
    progressPaint.color = progressColor;
    progressPaint.strokeWidth = progressWidth;
    progressPaint.style = PaintingStyle.stroke;
    progressPaint.strokeCap = StrokeCap.round;

    double dimension = size.shortestSide - max(baseWidth, progressWidth)/2;

    Path basePath = Path();
    basePath.addArc(Rect.fromCenter(center: Offset(size.width/2, size.height/2), width: dimension, height: dimension), startAngle, sweepAngle);
    canvas.drawPath(basePath, basePaint);

    Path progressPath = Path();
    progressPath.addArc(Rect.fromCenter(center: Offset(size.width/2, size.height/2), width: dimension, height: dimension), startAngle, sweepAngle * min(1, value));
    canvas.drawPath(progressPath, progressPaint);

    TextPainter textPainter = TextPainter(text: TextSpan(text: "${(value*100).toStringAsFixed(0)}%", style: TextStyle(color: Colors.white, fontSize: 32)));
    textPainter.textDirection = TextDirection.ltr;
    textPainter.layout();

    textPainter.paint(canvas, Offset(size.width/2 - textPainter.width/2, size.height/2 - textPainter.height/2));

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
