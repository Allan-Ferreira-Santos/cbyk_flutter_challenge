import 'package:flutter/material.dart';

import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';

class AuthModeBar extends StatelessWidget {
  const AuthModeBar({
    super.key,
    required this.loginSelected,
    required this.onLoginTap,
    required this.onRegisterTap,
    required this.loginLabel,
    required this.registerLabel,
  });

  final bool loginSelected;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;
  final String loginLabel;
  final String registerLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabItem(
          label: loginLabel,
          selected: loginSelected,
          onTap: onLoginTap,
        ),
        const SizedBox(width: 28),
        _TabItem(
          label: registerLabel,
          selected: !loginSelected,
          onTap: onRegisterTap,
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.tealBright : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: selected ? 48 : 0,
            color: AppColors.tealBright,
          ),
        ],
      ),
    );
  }
}
