import 'package:compass/constants/app_color.dart';
import 'package:flutter/material.dart';

import '../widgets/compass_View_painter.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomPaint(
        size: size,
        painter: CompassViewPainter(color: AppColor.grey),
      ),
    );
  }
}
