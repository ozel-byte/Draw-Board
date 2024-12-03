library draw_board;

import 'package:flutter/material.dart';

class DrawBoard extends StatelessWidget {
  final Size size;
  final Color color;
  final double strokeWidth;

  DrawBoard(
      {super.key,
      this.color = Colors.black,
      required this.size,
      this.strokeWidth = 10});

  final ValueNotifier<List<Point>> points = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        if (details.localPosition.dx > 0 && details.localPosition.dy > 0) {
          points.value = [
            ...points.value,
            Point(points: [details.localPosition])
          ];
        }
      },
      onPanUpdate: (details) => drawLines(details.localPosition),
      onPanEnd: (details) => drawLines(details.localPosition),
      child: ValueListenableBuilder(
        valueListenable: points,
        builder: (context, value, child) => CustomPaint(
          size: size,
          painter:
              _Canva(points: value, color: color, strokeWidth: strokeWidth),
        ),
      ),
    );
  }

  drawLines(Offset localPosition) {
    if (localPosition.dx > 0 &&
        localPosition.dy > 0 &&
        localPosition.dy < size.height) {
      points.value.last.points.add(localPosition);
      points.value = [
        ...points.value,
      ];
    }
  }
}

class _Canva extends CustomPainter {
  List<Point> points;
  final Color color;
  final double strokeWidth;

  _Canva(
      {required this.points, required this.color, required this.strokeWidth});
  @override
  void paint(Canvas canvas, Size size) {
    for (var e in points) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      final path = Path();
      path.addPolygon(e.points, false);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Point {
  final List<Offset> points;
  Point({required this.points});
}
