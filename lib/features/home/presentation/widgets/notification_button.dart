import 'package:flutter/material.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.notifications_none),
        ),
        Positioned(
          right: 12,
          top: 12,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.badge,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
