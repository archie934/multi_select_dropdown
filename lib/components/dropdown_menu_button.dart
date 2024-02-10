import 'package:flutter/material.dart';


class DropdownMenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final Widget child;

  const DropdownMenuButton({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 0.1,
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.pink.withOpacity(.3) : Colors.transparent,
        child: child,
      ),
    );
  }
}
