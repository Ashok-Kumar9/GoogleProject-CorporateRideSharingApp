import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/material.dart';

class AnimatedBorder extends StatefulWidget {
  const AnimatedBorder({
    Key? key,
    required this.child,
    this.thickness = 2,
    this.gradientColors = const [
      ColorShades.googleBlue,
      ColorShades.googleRed,
      ColorShades.googleYellow,
      ColorShades.googleGreen,
    ],
    this.centerColorWidth = 5,
    this.radius = 8.0,
  }) : super(key: key);

  final Widget child;
  final double thickness;
  final List<Color> gradientColors;
  final double centerColorWidth;
  final double radius;

  @override
  State<AnimatedBorder> createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<AnimatedBorder>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _animationController.reverse();
          break;
        case AnimationStatus.dismissed:
          _animationController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(widget.thickness),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1, -1),
                  end: const Alignment(1, 1),
                  colors: widget.gradientColors,
                  stops: [
                    _animationController.value - widget.centerColorWidth,
                    _animationController.value,
                    _animationController.value,
                    _animationController.value + widget.centerColorWidth
                  ],
                ),
                // border: Border.all(color: Color(0xff757575), width: 2),
                borderRadius: BorderRadius.circular(widget.radius)),
            child: widget.child,
          ),
        );
      },
    );
  }
}
