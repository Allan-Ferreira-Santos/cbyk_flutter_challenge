import 'package:flutter/material.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_gradients.dart';


class GradientCircleButton extends StatelessWidget {
  const GradientCircleButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
    this.size = 64,
    this.enabled = true,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        elevation: 6,
        shadowColor: Colors.black54,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled && !isLoading ? onPressed : null,
          child: Ink(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.primaryButton,
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Icon(icon, color: Colors.white, size: size * 0.4),
            ),
          ),
        ),
      ),
    );
  }
}
