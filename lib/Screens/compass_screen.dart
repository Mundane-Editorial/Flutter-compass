import 'package:compass/constants/app_color.dart';
import 'package:compass/widgets/neumorphism.dart';
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
      body: Stack(
        children: [
          Neumorphism(
            margin: EdgeInsets.all(size.width * 0.05),
            padding: EdgeInsets.all(10),
            child: CustomPaint(
              size: size,
              painter: CompassViewPainter(color: AppColor.grey),
            ),
          ),
          Neumorphism(
              margin: EdgeInsets.all(size.width * 0.25),
              distance: 2.5,
              blur: 5,
              child: Neumorphism(
                  margin: EdgeInsets.all(size.width * 0.01),
                  distance: 0,
                  blur: 0,
                  innerShadow: true,
                  isReverse: true,
                  child: Neumorphism(
                      margin: EdgeInsets.all(size.width * 0.05),
                      distance: 4,
                      blur: 5,
                      child: TopGradientContainer(
                          padding: EdgeInsets.all(size.width * 0.2),
                          child: Container())))),
        ],
      ),
    );
  }
}
