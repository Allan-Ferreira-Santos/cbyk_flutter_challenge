import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';
import 'package:cbyk_flutter_challenge/features/home/utils/mappers/home_page_mapper.dart';

class QuoteCarousel extends StatelessWidget {
  const QuoteCarousel({
    super.key,
    required this.onAutomovel,
    required this.onComingSoon,
    @visibleForTesting this.enableMouseDrag,
  });

  final VoidCallback onAutomovel;
  final ValueChanged<String> onComingSoon;
  final bool? enableMouseDrag;

  static const _cardWidth = 120.0;
  static const _cardHeight = 112.0;
  static const _spacing = 12.0;
  static const _itemCount = 6;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        _card(
          label: HomePageMapper.auto,
          icon: Icons.directions_car_outlined,
          onTap: onAutomovel,
        ),
        const SizedBox(width: _spacing),
        _card(
          label: HomePageMapper.residence,
          icon: Icons.home_outlined,
          onTap: () => onComingSoon(HomePageMapper.residence),
        ),
        const SizedBox(width: _spacing),
        _card(
          label: HomePageMapper.life,
          icon: Icons.favorite_outline,
          onTap: () => onComingSoon(HomePageMapper.life),
        ),
        const SizedBox(width: _spacing),
        _card(
          label: HomePageMapper.accidents,
          icon: Icons.personal_injury_outlined,
          onTap: () => onComingSoon(HomePageMapper.accidents),
        ),
        const SizedBox(width: _spacing),
        _card(
          label: HomePageMapper.moto,
          icon: Icons.two_wheeler_outlined,
          onTap: () => onComingSoon(HomePageMapper.moto),
        ),
        const SizedBox(width: _spacing),
        _card(
          label: HomePageMapper.company,
          icon: Icons.apartment_outlined,
          onTap: () => onComingSoon(HomePageMapper.company),
        ),
      ],
    );

    final totalWidth = _itemCount * _cardWidth + (_itemCount - 1) * _spacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final needsScroll = constraints.maxWidth < totalWidth;

        if (!needsScroll) {
          return SizedBox(
            height: _cardHeight,
            child: Align(alignment: Alignment.centerLeft, child: row),
          );
        }

        final carousel = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: row,
        );

        final useMouseDrag = enableMouseDrag ?? kIsWeb;
        if (!useMouseDrag) {
          return SizedBox(height: _cardHeight, child: carousel);
        }

        return SizedBox(
          height: _cardHeight,
          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: carousel,
          ),
        );
      },
    );
  }

  Widget _card({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: _cardWidth,
      height: _cardHeight,
      child: _QuoteTile(label: label, icon: icon, onTap: onTap),
    );
  }
}

class _QuoteTile extends StatelessWidget {
  const _QuoteTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.tealBright, size: 28),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.tealBright,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
