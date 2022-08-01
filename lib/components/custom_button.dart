import 'package:corporate_ride_sharing/components/reusable_widgets.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final double border;
  final bool isActive;
  final bool isLoading;
  final Color color;
  final double borderRadius;

  const CustomButton(
      {Key? key,
        required this.onPressed,
        required this.child,
        this.border = 4.0,
        this.borderRadius = 200,
        this.isActive = true,
        this.color = const Color.fromRGBO(63, 81, 181, 1),
        this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isActive && !isLoading) ? onPressed : () => {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: (isActive && !isLoading) ? color : Colors.grey[600],
          border: Border.all(
            color: ColorShades.backGroundGrey,
            width: border,
          ),
        ),
        child:
        isLoading ? ReusableWidgets().threeBounceLoader() : child,
      ),
    );
  }
}
