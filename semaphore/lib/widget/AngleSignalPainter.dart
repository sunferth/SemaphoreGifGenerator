import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/angle_signal.dart';


class AngleSignalPainter extends CustomPainter {
  final AngleSignal signal;

  AngleSignalPainter(this.signal);

  @override
  void paint(Canvas canvas, Size size) {
    double legLength = 60;
    double torsoLength = 45;
    double legGap = 2;
    double legWidth = 15;
    double armLength = 35;
    double armWidth = 11;
    double shoulderHeight = 12;
    double flagOffset = 10;
    double flagSize = 30;
    double headSize = 15;
    double headOffset = 55;
    double shoulderMax = 20;




    Paint personFill = Paint();
    personFill.style = PaintingStyle.fill;
    personFill.color = Colors.white;

    //Actually Draw arms to canvas
    Paint strokePaint = Paint();

    strokePaint.strokeWidth =  3;
    strokePaint.color = Colors.black;
    strokePaint.style = PaintingStyle.stroke;

    Paint flagMainStroke = Paint();
    flagMainStroke.strokeWidth =  2;
    flagMainStroke.color = Colors.red;
    flagMainStroke.style = PaintingStyle.stroke;
    flagMainStroke.strokeJoin = StrokeJoin.round;

    Paint flagOuterStroke = Paint();
    flagOuterStroke.strokeWidth =  4;
    flagOuterStroke.color = Colors.white;
    flagOuterStroke.style = PaintingStyle.stroke;

    Paint flagMainFill = Paint();
    flagMainFill.color = Colors.red;
    flagMainFill.style = PaintingStyle.fill;

    Paint flagBaseFill = Paint();
    flagBaseFill.color = Colors.white;
    flagBaseFill.style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width/2, size.height/2 - headOffset ), headSize, personFill);

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

    //Draw main body to canvas
    canvas.drawPath(path, personFill);

    //Get left hand angle
    double leftArmAngle = signal.left + pi;

    //Calculate rotation point and base shoulder points
    Offset topLeftShoulder = Offset(size.width/2, size.height/2 + 22)  - Offset(-legGap/2 - legWidth, torsoLength + shoulderHeight);
    Offset bottomLeftShoulder = Offset(size.width/2, size.height/2 + 22)  - Offset(-legGap/2 - legWidth, torsoLength);
    Offset leftRotationPoint = (bottomLeftShoulder) + Offset(shoulderHeight/2 + 5 , -shoulderHeight/2);
    //Calculate base arm points by rotating as necessary
    Offset leftArmBase = leftRotationPoint + Offset(2*shoulderHeight/3 * cos(leftArmAngle), 2*shoulderHeight/3 * sin(leftArmAngle));
    Offset leftInsideArmBase = leftArmBase + Offset(armWidth/2 * cos(pi/2 + leftArmAngle), armWidth/2 * sin(pi/2 + leftArmAngle));
    Offset leftOutsideArmBase = leftArmBase + Offset(armWidth/2 * cos(-pi/2 + leftArmAngle), armWidth/2 * sin(-pi/2 + leftArmAngle));
    //Start the path
    Path leftArm = Path();
    //Move to the bottom left shoulder
    leftArm.moveTo(bottomLeftShoulder.dx, bottomLeftShoulder.dy);
    //Draw armpit
    leftArm.quadraticBezierTo(getXIntersect(bottomLeftShoulder, leftInsideArmBase, leftInsideArmBase + Offset(armLength * cos(leftArmAngle), armLength * sin(leftArmAngle)), shoulderMax), bottomLeftShoulder.dy, leftInsideArmBase.dx, leftInsideArmBase.dy);
    //Draw inside arm
    leftArm.relativeLineTo(armLength * cos(leftArmAngle), armLength * sin(leftArmAngle));
    //Draw hand
    leftArm.relativeArcToPoint(leftOutsideArmBase - leftInsideArmBase, radius: Radius.circular(armWidth /2), clockwise: false);
    //Draw outside arm
    leftArm.relativeLineTo(-armLength * cos(leftArmAngle), -armLength * sin(leftArmAngle));
    //Draw shoulder
    leftArm.quadraticBezierTo(getXIntersect(topLeftShoulder, leftOutsideArmBase, leftOutsideArmBase + Offset(armLength * cos(leftArmAngle), armLength * sin(leftArmAngle)), shoulderMax ), topLeftShoulder.dy, topLeftShoulder.dx, topLeftShoulder.dy);
    //Close arm
    leftArm.relativeLineTo(0, shoulderHeight);

    //Draw stroke using portion of arm (Important when overlaping arm and body)
    Path leftArmStroke = Path();
    leftArmStroke.moveTo(leftInsideArmBase.dx + armLength * .2 * cos(leftArmAngle), leftInsideArmBase.dy + .2 * armLength * sin(leftArmAngle));
    leftArmStroke.relativeLineTo(.8* armLength * cos(leftArmAngle), .8 * armLength * sin(leftArmAngle));
    leftArmStroke.relativeArcToPoint(leftOutsideArmBase - leftInsideArmBase, radius: Radius.circular(armWidth /2), clockwise: false);
    leftArmStroke.relativeLineTo(-0.8 * armLength * cos(leftArmAngle), -0.8 * armLength * sin(leftArmAngle));

    Offset leftHand = leftInsideArmBase + Offset(armLength * cos(leftArmAngle), armLength * sin(leftArmAngle)) + (leftOutsideArmBase - leftInsideArmBase)/2 + Offset(flagOffset * cos(leftArmAngle), flagOffset * sin(leftArmAngle));


    //Get right hand angle
    double rightArmAngle = signal.right + pi;
    //Calculate rotation point and base shoulder points
    Offset topRightShoulder = Offset(size.width/2, size.height/2 + 22)  + Offset(-legGap/2 - legWidth, -torsoLength - shoulderHeight);
    Offset bottomRightShoulder = Offset(size.width/2, size.height/2 + 22)  + Offset(-legGap/2 - legWidth, -torsoLength);
    Offset rightRotationPoint = (bottomRightShoulder) + Offset(-shoulderHeight/2 - 5 , -shoulderHeight/2);
    //Calculate base arm points by rotating as necessary
    Offset rightArmBase = rightRotationPoint + Offset(2*shoulderHeight/3 * cos(rightArmAngle), 2*shoulderHeight/3 * sin(rightArmAngle));
    Offset rightInsideArmBase = rightArmBase + Offset(armWidth/2 * cos(-pi/2 + rightArmAngle), armWidth/2 * sin(-pi/2 + rightArmAngle));
    Offset rightOutsideArmBase = rightArmBase + Offset(armWidth/2 * cos(pi/2 + rightArmAngle), armWidth/2 * sin(pi/2 + rightArmAngle));
    //Start the path
    Path rightArm = Path();
    //Move to the bottom right shoulder
    rightArm.moveTo(bottomRightShoulder.dx, bottomRightShoulder.dy);
    //Draw right armpit
    rightArm.quadraticBezierTo(getXIntersect(bottomRightShoulder, rightInsideArmBase, rightInsideArmBase + Offset(armLength * cos(rightArmAngle), armLength * sin(rightArmAngle)), shoulderMax), bottomRightShoulder.dy, rightInsideArmBase.dx, rightInsideArmBase.dy);
    //Draw right inside arm
    rightArm.relativeLineTo(armLength * cos(rightArmAngle), armLength * sin(rightArmAngle));
    //Draw hand
    rightArm.relativeArcToPoint(rightOutsideArmBase - rightInsideArmBase, radius: Radius.circular(armWidth /2), clockwise: true);
    //Draw right outside arm
    rightArm.relativeLineTo(-armLength * cos(rightArmAngle), -armLength * sin(rightArmAngle));
    //Draw right shoulder
    rightArm.quadraticBezierTo(getXIntersect(topRightShoulder, rightOutsideArmBase, rightOutsideArmBase + Offset(armLength * cos(rightArmAngle), armLength * sin(rightArmAngle)), shoulderMax ), topRightShoulder.dy, topRightShoulder.dx, topRightShoulder.dy);
    //Close arm
    rightArm.relativeLineTo(0, shoulderHeight);
    //Draw stroke using portion of arm (Important when overlaping arm and body)
    Path rightArmStroke = Path();
    rightArmStroke.moveTo(rightInsideArmBase.dx + armLength * .2 * cos(rightArmAngle), rightInsideArmBase.dy + .2 * armLength * sin(rightArmAngle));
    rightArmStroke.relativeLineTo(.8* armLength * cos(rightArmAngle), .8 * armLength * sin(rightArmAngle));
    rightArmStroke.relativeArcToPoint(rightOutsideArmBase - rightInsideArmBase, radius: Radius.circular(armWidth /2), clockwise: true);
    rightArmStroke.relativeLineTo(-0.8 * armLength * cos(rightArmAngle), -0.8 * armLength * sin(rightArmAngle));

    Offset rightHand = rightInsideArmBase + Offset(armLength * cos(rightArmAngle), armLength * sin(rightArmAngle)) + (rightOutsideArmBase - rightInsideArmBase)/2 + Offset(flagOffset * cos(rightArmAngle), flagOffset * sin(rightArmAngle));

    canvas.drawPath(rightArm, personFill);
    canvas.drawPath(rightArmStroke, strokePaint);
    canvas.drawPath(rightArmStroke, personFill);

    canvas.drawPath(leftArm, personFill);
    canvas.drawPath(leftArmStroke, strokePaint);
    canvas.drawPath(leftArmStroke, personFill);

    //Draw Right Flag
    Path rightFlagPath = Path();
    //Move to hand location
    rightFlagPath.moveTo(rightHand.dx, rightHand.dy);
    //Draw main box
    rightFlagPath.relativeLineTo(flagSize * cos(rightArmAngle), flagSize * sin(rightArmAngle));
    rightFlagPath.relativeLineTo(flagSize * cos(rightArmAngle - pi/2), flagSize * sin(rightArmAngle - pi/2));
    rightFlagPath.relativeLineTo(flagSize * cos(rightArmAngle + pi), flagSize * sin(rightArmAngle + pi));
    rightFlagPath.relativeLineTo(flagSize * cos(rightArmAngle - 1.5 * pi), flagSize * sin(rightArmAngle - 1.5 * pi));
    //Close the path so it has nice rounded edges
    rightFlagPath.close();
    //Stroke with white
    canvas.drawPath(rightFlagPath, flagOuterStroke);
    //Fill with white
    canvas.drawPath(rightFlagPath, flagBaseFill);
    //Stoke with red
    canvas.drawPath(rightFlagPath, flagMainStroke);

    //Draw the triangle inside of the flag
    Path rightFlagInnerShapePath = Path();
    rightFlagInnerShapePath.moveTo(rightHand.dx, rightHand.dy);
    rightFlagInnerShapePath.relativeLineTo(-flagSize * cos(rightArmAngle - 1.5 * pi), -flagSize * sin(rightArmAngle - 1.5 * pi));
    rightFlagInnerShapePath.relativeLineTo(-flagSize * cos(rightArmAngle + pi), -flagSize * sin(rightArmAngle + pi));
    rightFlagInnerShapePath.lineTo(rightHand.dx, rightHand.dy);
    //Fill Triangle with red
    canvas.drawPath(rightFlagInnerShapePath, flagMainFill);

    //Draw left Flag
    Path leftFlagPath = Path();
    //Move to hand location
    leftFlagPath.moveTo(leftHand.dx, leftHand.dy);
    //Draw main box
    leftFlagPath.relativeLineTo(flagSize * cos(leftArmAngle), flagSize * sin(leftArmAngle));
    leftFlagPath.relativeLineTo(flagSize * cos(leftArmAngle + pi/2), flagSize * sin(leftArmAngle + pi/2));
    leftFlagPath.relativeLineTo(flagSize * cos(leftArmAngle + pi), flagSize * sin(leftArmAngle + pi));
    leftFlagPath.relativeLineTo(flagSize * cos(leftArmAngle + 1.5 * pi), flagSize * sin(leftArmAngle + 1.5 * pi));
    //Close the path so it has nice rounded edges
    leftFlagPath.close();
    //Stroke with white
    canvas.drawPath(leftFlagPath, flagOuterStroke);
    //Fill with white
    canvas.drawPath(leftFlagPath, flagBaseFill);
    //Stoke with red
    canvas.drawPath(leftFlagPath, flagMainStroke);

    //Draw the triangle inside of the flag
    Path leftFlagInnerShapePath = Path();
    leftFlagInnerShapePath.moveTo(leftHand.dx, leftHand.dy);
    leftFlagInnerShapePath.relativeLineTo(-flagSize * cos(leftArmAngle + 1.5 * pi), -flagSize * sin(leftArmAngle + 1.5 * pi));
    leftFlagInnerShapePath.relativeLineTo(-flagSize * cos(leftArmAngle + pi), -flagSize * sin(leftArmAngle + pi));
    leftFlagInnerShapePath.lineTo(leftHand.dx, leftHand.dy);
    //Fill Triangle with red
    canvas.drawPath(leftFlagInnerShapePath, flagMainFill);

    // Paint test = Paint();
    // test.color = Colors.red;
    //
    // canvas.drawCircle(Offset(100,100), 100, test);



  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double getXIntersect(Offset shoulderPoint, Offset point1, Offset point2, double shoulderOffset)
  {
    double divisor = (point1.dx - point2.dx);
    if(divisor == 0)
    {
      divisor = 0.000001;
    }
    double? m = (point1.dy - point2.dy)/divisor;

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

    if(x > shoulderOffset + shoulderPoint.dx)
    {
      x = shoulderPoint.dx + shoulderOffset;
    }

    if(x < shoulderPoint.dx - shoulderOffset)
    {
      x = shoulderPoint.dx - shoulderOffset;
    }

    return x;
  }

}