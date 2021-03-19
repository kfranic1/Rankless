import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

class CustomLoader extends StatefulWidget {
  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        children: [
          Expanded(child: Loader()),
          Expanded(
              child: Loader(
            direction: false,
          )),
          Expanded(child: Loader()),
        ],
      ),
    );
  }
}

class Loader extends StatefulWidget {
  const Loader({
    Key key,
    this.color = Colors.blue,
    this.size = 30.0,
    this.duration = const Duration(milliseconds: 1400),
    this.animate = true,
    this.allowAnimation = true,
    this.direction = true,
  }) : super(key: key);

  final Color color;
  final double size;
  final Duration duration;
  final bool animate;
  final bool allowAnimation;
  final bool direction;

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool animating = true;

  @override
  void initState() {
    super.initState();

    _controller = (AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), border: Border.all()),
          child: SizedBox.fromSize(
            size: Size(widget.size * 2, widget.size),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (i) {
                return ScaleTransition(
                  scale: DelayTween(
                          begin: 0.0,
                          end: 1.0,
                          delay: ((widget.direction ? i : (2 - i))) - 1 * .2)
                      .animate(_controller),
                  child: SizedBox.fromSize(
                      size: Size.square(widget.size * 0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: _itemBuilder(i),
                      )),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => DecoratedBox(
      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle));
}

class DelayTween extends Tween<double> {
  DelayTween({double begin, double end, @required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp((sin((t - delay) * 2 * pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
