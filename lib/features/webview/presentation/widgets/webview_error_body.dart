import 'package:flutter/material.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';
import 'package:cbyk_flutter_challenge/features/webview/utils/mappers/webview_page_mapper.dart';


class WebViewErrorBody extends StatelessWidget {
  const WebViewErrorBody({
    super.key,
    required this.url,
    required this.error,
  });

  final String url;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.public_off, size: 48, color: AppColors.tealBright),
            const SizedBox(height: 16),
            Text(
              WebViewPageMapper.loadErrorTitle,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              url,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.tealBright,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
