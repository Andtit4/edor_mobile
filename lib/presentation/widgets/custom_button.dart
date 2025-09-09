import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;

  const CustomButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.padding,
    this.minimumSize,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    if (isLoading) {
      final loadingIndicator = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.primary
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      );

      switch (variant) {
        case ButtonVariant.primary:
          button = ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              padding: padding,
              minimumSize: minimumSize,
            ),
            child: loadingIndicator,
          );
          break;
        case ButtonVariant.secondary:
          button = ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              padding: padding,
              minimumSize: minimumSize,
            ),
            child: loadingIndicator,
          );
          break;
        case ButtonVariant.outline:
          button = OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(
              padding: padding,
              minimumSize: minimumSize,
            ),
            child: loadingIndicator,
          );
          break;
        case ButtonVariant.text:
          button = TextButton(
            onPressed: null,
            style: TextButton.styleFrom(
              padding: padding,
              minimumSize: minimumSize,
            ),
            child: loadingIndicator,
          );
          break;
      }
    } else {
      switch (variant) {
        case ButtonVariant.primary:
          button = ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: padding,
              minimumSize: minimumSize,
            ),
            child: child,
          );
          break;
        case ButtonVariant.secondary:
          button = ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              padding: padding,
              minimumSize: minimumSize,
            ),
            child: child,
          );
          break;
        case ButtonVariant.outline:
          button = OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              padding: padding,
              minimumSize: minimumSize,
            ),
            child: child,
          );
          break;
        case ButtonVariant.text:
          button = TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: padding,
              minimumSize: minimumSize,
            ),
            child: child,
          );
          break;
      }
    }

    return isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
