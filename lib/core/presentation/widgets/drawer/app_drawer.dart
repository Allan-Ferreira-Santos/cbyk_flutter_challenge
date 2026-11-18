import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';
import 'package:cbyk_flutter_challenge/core/domain/entities/user_entity.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/drawer/drawer_mapper.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/drawer/widgets/drawer_help_banner.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/drawer/widgets/drawer_menu_item.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/drawer/widgets/drawer_user_header.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.user,
    required this.onLogout,
  });

  final UserEntity? user;
  final Future<void> Function() onLogout;

  void _openPlaceholder(String title) {
    Get.back();
    Get.toNamed(AppRoutesMapper.placeholder, arguments: title);
  }

  @override
  Widget build(BuildContext context) {
    final name = (user?.name.isNotEmpty ?? false)
        ? user!.name.toUpperCase()
        : DrawerMapper.defaultUserName;

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerUserHeader(
              userName: name,
              onMyAccountTap: () => _openPlaceholder(DrawerMapper.myAccount),
            ),
            const Divider(color: AppColors.border, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  DrawerMenuItem(
                    label: DrawerMapper.menuHome,
                    onTap: () => Get.back(),
                  ),
                  DrawerMenuItem(
                    label: DrawerMapper.menuContracts,
                    onTap: () => _openPlaceholder(DrawerMapper.menuContracts),
                  ),
                  DrawerMenuItem(
                    label: DrawerMapper.menuClaims,
                    onTap: () => _openPlaceholder(DrawerMapper.menuClaims),
                  ),
                  DrawerMenuItem(
                    label: DrawerMapper.menuFamily,
                    onTap: () => _openPlaceholder(DrawerMapper.menuFamily),
                  ),
                  DrawerMenuItem(
                    label: DrawerMapper.menuAssets,
                    onTap: () => _openPlaceholder(DrawerMapper.menuAssets),
                  ),
                  DrawerMenuItem(
                    label: DrawerMapper.menuPayments,
                    onTap: () => _openPlaceholder(DrawerMapper.menuPayments),
                  ),
                  DrawerMenuItem(
                    label: DrawerMapper.menuCoverage,
                    onTap: () => _openPlaceholder(DrawerMapper.menuCoverage),
                  ),
                  DrawerMenuItem(
                    label: DrawerMapper.menuValidateSlip,
                    onTap: () =>
                        _openPlaceholder(DrawerMapper.menuValidateSlip),
                  ),
                  DrawerMenuItem(
                    label: DrawerMapper.menuPhones,
                    onTap: () => _openPlaceholder(DrawerMapper.menuPhones),
                  ),
                  DrawerMenuItem(
                    label: DrawerMapper.menuSettings,
                    onTap: () => _openPlaceholder(DrawerMapper.menuSettings),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () async {
                          Get.back();
                          await onLogout();
                        },
                        child: Text(
                          DrawerMapper.logout,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppColors.tealBright,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const DrawerHelpBanner(),
          ],
        ),
      ),
    );
  }
}
