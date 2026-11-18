import 'package:flutter/material.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onTwitterPressed,
    this.enabled = true,
  });

  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onTwitterPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialIconButton(
          tooltip: 'Google',
          onPressed: enabled ? onGooglePressed : null,
          child: Image.asset(
            'assets/images/icons/google.png',
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 20),
        _SocialIconButton(
          tooltip: 'Facebook',
          onPressed: enabled ? onFacebookPressed : null,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'assets/images/icons/facebook.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
        const SizedBox(width: 20),
        _SocialIconButton(
          tooltip: 'Twitter',
          onPressed: enabled ? onTwitterPressed : null,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'assets/images/icons/twitter.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    required this.tooltip,
    required this.child,
    this.onPressed,
  });

  final String tooltip;
  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: onPressed == null
                    ? AppColors.border.withValues(alpha: 0.5)
                    : AppColors.border,
              ),
            ),
            child: Opacity(opacity: onPressed == null ? 0.45 : 1, child: child),
          ),
        ),
      ),
    );
  }
}
