import 'package:flutter/material.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/home_sections.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/home_welcome_banner.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/quote_carousel.dart';
import 'package:cbyk_flutter_challenge/features/home/utils/mappers/home_page_mapper.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.userName,
    required this.horizontalPadding,
    required this.onAutomovel,
    required this.onComingSoon,
    required this.onFamilyTap,
  });

  final String userName;
  final double horizontalPadding;
  final VoidCallback onAutomovel;
  final ValueChanged<String> onComingSoon;
  final VoidCallback onFamilyTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeWelcomeBanner(userName: userName),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              24,
              horizontalPadding,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HomePageMapper.quoteTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 14),
                QuoteCarousel(
                  onAutomovel: onAutomovel,
                  onComingSoon: onComingSoon,
                ),
                const SizedBox(height: 28),
                HomeSections(onFamilyTap: onFamilyTap),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
