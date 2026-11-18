import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cbyk_flutter_challenge/core/config/app_config.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';
import 'package:cbyk_flutter_challenge/core/helper/app_toast_helper.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/core/config/responsive/app_responsive.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/cubit/home_cubit.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/cubit/home_state.dart';
import 'package:cbyk_flutter_challenge/features/home/utils/mappers/home_page_mapper.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/drawer/app_drawer.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/home_body.dart';
import 'package:cbyk_flutter_challenge/features/home/presentation/widgets/notification_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeCubit _cubit = Get.find<HomeCubit>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  Future<void> _logout() async {
    await _cubit.logout();
  }

  void _openAutomovel() {
    Get.toNamed(
      AppRoutesMapper.webview,
      arguments: {
        'title': HomePageMapper.auto,
        'url': AppConfig.webviewAutomovelUrl,
      },
    );
  }

  void _comingSoon(String label) {
    AppToastHelper.show(label, HomePageMapper.comingSoon);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final horizontalPadding = responsive.when(
      mobile: 16.0,
      tablet: 28.0,
      desktop: 48.0,
    );

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            !identical(previous.result, current.result) &&
            (current.result.isError || current.result.isSuccess),
        listener: (context, state) {
          if (state.result.isError) {
            AppToastHelper.show(
              state.result.titleMessage,
              state.result.descriptionMessage,
            );
          }
          if (state.result.isSuccess) {
            Get.offAllNamed(AppRoutesMapper.login);
          }
        },
        builder: (context, state) {
          final userName = state.user?.name.isNotEmpty == true
              ? state.user!.name
              : 'Usuário';

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.background,
            drawer: AppDrawer(user: state.user, onLogout: _logout),
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Menu',
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              title: const Text('Tokio Marine Seguradora'),
              actions: [
                NotificationButton(
                  onPressed: () => _comingSoon('Notificações'),
                ),
              ],
            ),
            body: HomeBody(
              userName: userName,
              horizontalPadding: horizontalPadding,
              onAutomovel: _openAutomovel,
              onComingSoon: _comingSoon,
              onFamilyTap: () => _comingSoon(HomePageMapper.familyTitle),
            ),
          );
        },
      ),
    );
  }
}
