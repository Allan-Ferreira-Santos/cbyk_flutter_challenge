import 'package:flutter/material.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/empty_dashed_card.dart';
import 'package:cbyk_flutter_challenge/features/home/utils/mappers/home_page_mapper.dart';

class HomeSections extends StatelessWidget {
  const HomeSections({super.key, required this.onFamilyTap});

  final VoidCallback onFamilyTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          HomePageMapper.familyTitle,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        EmptyDashedCard(
          icon: Icons.add_circle_outline,
          message: HomePageMapper.familyEmpty,
          onTap: onFamilyTap,
        ),
        const SizedBox(height: 28),
        Text(
          HomePageMapper.contractedTitle,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        const EmptyDashedCard(
          icon: Icons.sentiment_dissatisfied_outlined,
          message: HomePageMapper.contractedEmpty,
        ),
      ],
    );
  }
}
