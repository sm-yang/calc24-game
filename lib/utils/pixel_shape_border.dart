import 'package:flutter/material.dart';

class PixelShapeBorder extends OutlinedBorder {
  final double radius;
  final int border;
  final double pixel;

  PixelShapeBorder({this.radius = 0, this.border = 0, this.pixel = 4});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  /// 绘制外边框路径
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final w = rect.width - radius * pixel * 2;
    final h = rect.height - radius * pixel * 2;
    final path = Path()..moveTo(radius * pixel, 0);
    for (var dir = 0; dir < 4; dir ++) {
      switch (dir) {
        case 0: path.relativeLineTo(w, 0); break;
        case 1: path.relativeLineTo(0, h); break;
        case 2: path.relativeLineTo(-w, 0); break;
        case 3: path.relativeLineTo(0, -h); break;
      }
      for (var i = 0, len = radius * 2; i < len; i ++) {
        double x = (i + dir) % 2 == 0 ? 0 : pixel;
        double y = (i + dir) % 2 == 1 ? 0 : pixel;
        switch (dir) {
          case 1: x *= -1; break;
          case 2: x *= -1; y *= -1; break;
          case 3: y *= -1; break;
        }
        path.relativeLineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    /// 边框宽度大于0才用canvas绘制边框
    if (border > 0) {
      final paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = pixel * border
        ..style = PaintingStyle.stroke;
      canvas.drawPath(getOuterPath(rect), paint);
    }
  }

  @override
  ShapeBorder scale(double t) => PixelShapeBorder(radius: radius * t);

  @override
  OutlinedBorder copyWith({BorderSide? side}) => this;
}
