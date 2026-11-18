import 'package:flutter/material.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';

class TokioResolveMark extends StatelessWidget {
  const TokioResolveMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.tealBright, AppColors.lime],
            ),
          ),
          child: const Icon(Icons.bolt, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'tokio',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.tealBright,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              TextSpan(
                text: ' resolve',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
