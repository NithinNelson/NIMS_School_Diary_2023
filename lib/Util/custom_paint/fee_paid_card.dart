import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final greenPaint = Paint()
      ..color = const Color(0xff26de81)
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    final whiteLine = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final paint1 = Paint()
      ..color = Colors.grey.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final greenPath = Path()
      ..moveTo(size.width * 0.0, size.height * 0.2)
      ..arcToPoint(Offset(size.width * 2/33, size.height * 0.0), radius: Radius.circular(20.sp))
      ..lineTo(size.width * 3/11, size.height * 0.0)
      ..arcToPoint(Offset(size.width * 1/3, size.height * 0.2), radius: Radius.circular(20.sp), clockwise: false)
      ..lineTo(size.width * 1/3, size.height * 0.24)
      ..lineTo(size.width * 19/55, size.height * 0.24)
      ..lineTo(size.width * 19/55, size.height * 0.28)
      ..lineTo(size.width * 1/3, size.height * 0.28)
      ..lineTo(size.width * 1/3, size.height * 0.32)
      ..lineTo(size.width * 19/55, size.height * 0.32)
      ..lineTo(size.width * 19/55, size.height * 0.36)
      ..lineTo(size.width * 1/3, size.height * 0.36)
      ..lineTo(size.width * 1/3, size.height * 0.4)
      ..lineTo(size.width * 19/55, size.height * 0.4)
      ..lineTo(size.width * 19/55, size.height * 0.44)
      ..lineTo(size.width * 1/3, size.height * 0.44)
      ..lineTo(size.width * 1/3, size.height * 0.48)
      ..lineTo(size.width * 19/55, size.height * 0.48)
      ..lineTo(size.width * 19/55, size.height * 0.52)
      ..lineTo(size.width * 1/3, size.height * 0.52)
      ..lineTo(size.width * 1/3, size.height * 0.56)
      ..lineTo(size.width * 19/55, size.height * 0.56)
      ..lineTo(size.width * 19/55, size.height * 0.6)
      ..lineTo(size.width * 1/3, size.height * 0.6)
      ..lineTo(size.width * 1/3, size.height * 0.64)
      ..lineTo(size.width * 19/55, size.height * 0.64)
      ..lineTo(size.width * 19/55, size.height * 0.68)
      ..lineTo(size.width * 1/3, size.height * 0.68)
      ..lineTo(size.width * 1/3, size.height * 0.72)
      ..lineTo(size.width * 19/55, size.height * 0.72)
      ..lineTo(size.width * 19/55, size.height * 0.76)
      ..lineTo(size.width * 1/3, size.height * 0.76)
      ..lineTo(size.width * 1/3, size.height * 0.8)
      ..arcToPoint(Offset(size.width * 3/11, size.height), radius: Radius.circular(20.sp), clockwise: false)
      ..lineTo(size.width * 2/33, size.height)
      ..arcToPoint(Offset(size.width * 0.0, size.height * 0.8), radius: Radius.circular(20.sp))
      ..close();

    final path1 = Path()
      ..moveTo(size.width * 0.01, size.height * 0.8)
      ..arcToPoint(Offset(size.width * 2/33, size.height), radius: Radius.circular(20.sp), clockwise: false)
      ..lineTo(size.width * 4/15, size.height)
      ..arcToPoint(Offset(size.width * 1/3, size.height * 0.8), radius: Radius.circular(20.sp))
      ..arcToPoint(Offset(size.width * 0.4, size.height), radius: Radius.circular(20.sp))
      ..lineTo(size.width * 31/33, size.height)
      ..arcToPoint(Offset(size.width * 0.99, size.height * 0.8), radius: Radius.circular(20.sp), clockwise: false);

    final whitePath = Path()
      ..moveTo(size.width * 13/33, size.height)
      ..arcToPoint(Offset(size.width * 1/3, size.height * 0.8), radius: Radius.circular(20.sp), clockwise: false)
      ..lineTo(size.width * 1/3, size.height * 0.76)
      ..lineTo(size.width * 19/55, size.height * 0.76)
      ..lineTo(size.width * 19/55, size.height * 0.72)
      ..lineTo(size.width * 1/3, size.height * 0.72)
      ..lineTo(size.width * 1/3, size.height * 0.68)
      ..lineTo(size.width * 19/55, size.height * 0.68)
      ..lineTo(size.width * 19/55, size.height * 0.64)
      ..lineTo(size.width * 1/3, size.height * 0.64)
      ..lineTo(size.width * 1/3, size.height * 0.6)
      ..lineTo(size.width * 19/55, size.height * 0.6)
      ..lineTo(size.width * 19/55, size.height * 0.56)
      ..lineTo(size.width * 1/3, size.height * 0.56)
      ..lineTo(size.width * 1/3, size.height * 0.52)
      ..lineTo(size.width * 19/55, size.height * 0.52)
      ..lineTo(size.width * 19/55, size.height * 0.48)
      ..lineTo(size.width * 1/3, size.height * 0.48)
      ..lineTo(size.width * 1/3, size.height * 0.44)
      ..lineTo(size.width * 19/55, size.height * 0.44)
      ..lineTo(size.width * 19/55, size.height * 0.4)
      ..lineTo(size.width * 1/3, size.height * 0.4)
      ..lineTo(size.width * 1/3, size.height * 0.36)
      ..lineTo(size.width * 1/3, size.height * 0.36)
      ..lineTo(size.width * 19/55, size.height * 0.36)
      ..lineTo(size.width * 19/55, size.height * 0.32)
      ..lineTo(size.width * 1/3, size.height * 0.32)
      ..lineTo(size.width * 1/3, size.height * 0.28)
      ..lineTo(size.width * 19/55, size.height * 0.28)
      ..lineTo(size.width * 19/55, size.height * 0.24)
      ..lineTo(size.width * 1/3, size.height * 0.24)
      ..lineTo(size.width * 1/3, size.height * 0.2)
      ..arcToPoint(Offset(size.width * 13/33, size.height * 0.0), radius: Radius.circular(20.sp), clockwise: false)
      ..lineTo(size.width * 31/33, size.height * 0.0)
      ..arcToPoint(Offset(size.width, size.height * 0.2), radius: Radius.circular(20.sp))
      ..lineTo(size.width, size.height * 0.8)
      ..arcToPoint(Offset(size.width * 31/33, size.height), radius: Radius.circular(20.sp))
      ..close();

    canvas.drawPath(path1, paint1);
    canvas.drawPath(greenPath, greenPaint);
    canvas.drawLine(Offset(size.width * 1/3, size.height * 0.24), Offset(size.width * 1/3, size.height * 0.76), whiteLine);
    canvas.drawPath(whitePath, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
