import 'package:flutter/material.dart';
import 'package:invisquery/Core/widgets/bouncing_widget.dart';

class CustomRoundedButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final bool isEnable;
  final Color? backgroundColor;
  final Function()? onTap;
  final Border? border;
  final BorderRadius? borderRadius;
  const CustomRoundedButton(
      {super.key,
      required this.child,
      this.onTap,
      this.width = 120,
      this.height = 50,
      this.isEnable = true,
      this.backgroundColor = Colors.transparent,
      this.border,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: isEnable ? onTap : null, child: Center(child: container()));
  }

  container() => BouncingWidget(
        duration: const Duration(milliseconds: 300),
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            color: isEnable ? backgroundColor : Colors.grey.shade500,
            border: border,
          ),
          child: Center(
            child: child,
          ),
        ),
      );
}
