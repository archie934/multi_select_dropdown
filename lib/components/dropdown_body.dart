import 'package:flutter/material.dart';
import 'package:searchable_dropdown/models/dropdown_body_box.dart';

import '../models/dropdown_scroll_notification.dart';

class DropdownBody extends StatefulWidget {
  final DropdownBodyBox dropdownBodyBox;
  final FocusNode parentFocus;
  final List<Widget> options;

  const DropdownBody({
    super.key,
    required this.dropdownBodyBox,
    required this.options,
    required this.parentFocus,
  });

  @override
  State<DropdownBody> createState() => _DropdownBodyState();
}

class _DropdownBodyState extends State<DropdownBody>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.dropdownBodyBox.offset.dy,
      left: widget.dropdownBodyBox.offset.dx,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: widget.dropdownBodyBox.width,
          height: widget.dropdownBodyBox.height,
          color: Colors.white,
          child: FocusScope(
            autofocus: true,
            parentNode: widget.parentFocus,
            child: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollNotification) {
                  DropdownScrollNotification(
                          metrics: notification.metrics,
                          context: notification.context)
                      .dispatch(context);
                }
                return true;
              },
              child: CustomScrollView(
                primary: true,
                slivers: [
                  SliverFixedExtentList(
                    itemExtent: widget.dropdownBodyBox.itemExtent,
                    delegate: SliverChildListDelegate(widget.options),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
