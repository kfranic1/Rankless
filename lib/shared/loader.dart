import 'package:flutter/material.dart';
import 'dart:math';

class Loader extends StatefulWidget {
  const Loader({
    Key key,
    @required this.color,
    this.lineWidth = 7.0,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
    @required this.allowAnimation,
  }) : super(key: key);

  final Color color;
  final double lineWidth;
  final double size;
  final Duration duration;
  final AnimationController controller;
  final bool allowAnimation;

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  bool animate = false;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.identity()..rotateZ((_animation.value) * pi * 2),
        alignment: FractionalOffset.center,
        child: CustomPaint(
          painter: _TripleRingPainter(
              paintWidth: widget.lineWidth, color: widget.color),
          child: SizedBox.fromSize(
            size: Size.square(widget.size),
            child: TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {
                if (!widget.allowAnimation) return;
                if (animate)
                  _controller.stop();
                else
                  _controller.repeat();
                animate = !animate;
                
              },
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}

class _TripleRingPainter extends CustomPainter {
  _TripleRingPainter({@required double paintWidth, @required Color color})
      : ringPaint = Paint()
          ..color = color
          ..strokeWidth = paintWidth
          ..style = PaintingStyle.stroke;

  final Paint ringPaint;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    canvas.drawArc(rect, 0.0, getRadian(110.0), false, ringPaint);
    canvas.drawArc(rect, getRadian(140.0), getRadian(90.0), false, ringPaint);
    canvas.drawArc(rect, getRadian(260.0), getRadian(70.0), false, ringPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double getRadian(double angle) => pi / 180 * angle;
}
