import 'package:flutter/widgets.dart';

class DrodownBodyAnimation extends StatefulWidget {
  final Widget child;

  const DrodownBodyAnimation({
    super.key,
    required this.child,
  });

  @override
  State<DrodownBodyAnimation> createState() => _DrodownBodyAnimationState();
}

class _DrodownBodyAnimationState extends State<DrodownBodyAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: widget.child,
    );
  }
}
