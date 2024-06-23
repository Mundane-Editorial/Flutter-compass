import 'dart:math';

import 'package:compass/constants/app_color.dart';
import 'package:flutter/material.dart';

class CompassViewPainter extends CustomPainter {
  final Color color;
  final int majorTickerCount;
  final int minorTickerCount;
  final CardinalityMap cardinalityMap;

  CompassViewPainter({
    required this.color,
    this.majorTickerCount = 18,
    this.minorTickerCount = 90,
    this.cardinalityMap = const {0: 'N', 90: 'E', 180: 'S', 270: 'W'},
  });

  late final majorScalePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = color
    ..strokeWidth = 2.0;

  late final minorScalePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = color.withOpacity(0.7)
    ..strokeWidth = 1.0;

  late final majorScaleStyle = TextStyle(
    color: color,
    fontSize: 12.0,
  );

  late final cardinalityStyle = const TextStyle(
    color: AppColor.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  late final _majorTicks = _layoutScale(majorTickerCount);
  late final _minorTicks = _layoutScale(minorTickerCount);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    const origin = Offset.zero;
    final center = size.center(origin);
    final radius = size.width / 2;

    final majorTickLength = size.width * 0.08;
    final minorTickLength = size.width * 0.055;

    canvas.save();

    //TODO : Paint major scale code block
    for (final angle in _majorTicks) {
      final tickStart = Offset.fromDirection(
        _correctAngle(angle).toRadian(),
        radius,
      );
      final tickEnd = Offset.fromDirection(
        _correctAngle(angle).toRadian(),
        radius - majorTickLength,
      );
      canvas.drawLine(center + tickStart, center + tickEnd, majorScalePaint);
    }

    //TODO : Paint minor scale code block
    for (final angle in _minorTicks) {
      final tickStart = Offset.fromDirection(
        _correctAngle(angle).toRadian(),
        radius,
      );
      final tickEnd = Offset.fromDirection(
        _correctAngle(angle).toRadian(),
        radius - minorTickLength,
      );
      canvas.drawLine(center + tickStart, center + tickEnd, minorScalePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

  List<double> _layoutScale(int ticks) {
    final scale = 360 / ticks;
    return List.generate(ticks, (index) => index * scale);
  }

  double _correctAngle(double angle) => angle - 90;
}

typedef CardinalityMap = Map<num, String>;

extension on num {
  double toRadian() => this * pi / 180;
}
