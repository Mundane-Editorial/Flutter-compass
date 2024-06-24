import 'dart:math';

import 'package:compass/constants/app_color.dart';
import 'package:compass/widgets/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../widgets/compass_View_painter.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen>
    with SingleTickerProviderStateMixin {
  double? direction;
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _updatedDirection(double newDirection) {
    if (direction != null) {
      double startDirection = direction!;
      double endDirection = newDirection;

      if ((endDirection - startDirection).abs() > 180) {
        if (endDirection > startDirection) {
          startDirection += 360;
        } else {
          endDirection += 360;
        }
      }

      _animation = Tween<double>(
        begin: startDirection,
        end: endDirection,
      ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));
      _controller!.forward(from: 0);
    }

    setState(() {
      direction = newDirection;
    });
  }

  // TODO : add smooth rotation effect........

  double headingToDegree(double heading) {
    return heading < 0 ? 360 - heading.abs() : heading;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Error Reading Coordinates");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            direction = snapshot.data!.heading;

            if (direction == null) {
              return const Text(
                  "Your Device does not have Magnetometer i.e used to sense directions.");
            }

            return Stack(
              children: [
                Neumorphism(
                  margin: EdgeInsets.all(size.width * 0.05),
                  padding: EdgeInsets.all(10),
                  child: Transform.rotate(
                    angle: (direction! * (pi / 180) * -1),
                    child: CustomPaint(
                      size: size,
                      painter: CompassViewPainter(color: AppColor.grey),
                    ),
                  ),
                ),
                CenterDisplayMeter(direction: headingToDegree(direction!)),
                Positioned.fill(
                  top: size.height * 0.28,
                  child: Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration:
                            BoxDecoration(color: AppColor.red, boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 5,
                            offset: Offset(10, 10),
                          )
                        ]),
                      ),
                      Container(
                        width: 5,
                        height: size.width * 0.21,
                        decoration: BoxDecoration(
                          color: AppColor.red,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              blurRadius: 5,
                              offset: Offset(10, 10),
                            )
                          ],
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}

class CenterDisplayMeter extends StatelessWidget {
  const CenterDisplayMeter({
    super.key,
    required this.direction,
  });

  final double direction;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Neumorphism(
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
                    padding: EdgeInsets.all(size.width * 0.02),
                    child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: AppColor.greenColor,
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                begin: Alignment(-5, -5),
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColor.greenDarkColor,
                                  AppColor.greenColor,
                                ])),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${direction.toInt().toString().padLeft(3, '0')}°",
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: size.width * 0.075,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              getDirection(direction),
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ))))));
  }

  String getDirection(double direction) {
    if (direction >= 337.5 || direction < 22.5) {
      return "N";
    } else if (direction >= 22.5 && direction < 67.5) {
      return "NE";
    } else if (direction >= 67.5 && direction < 112.5) {
      return "E";
    } else if (direction >= 112.5 && direction < 157.5) {
      return "SE";
    } else if (direction >= 157.5 && direction < 202.5) {
      return "S";
    } else if (direction >= 202.5 && direction < 247.5) {
      return "SW";
    } else if (direction >= 247.5 && direction < 292.5) {
      return "W";
    } else if (direction >= 292.5 && direction < 337.5) {
      return "NW";
    }
    return "";
  }
}
