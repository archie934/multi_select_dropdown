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
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(.2)
            : Colors.transparent,
        child: child,
      ),
    );
  }
}
