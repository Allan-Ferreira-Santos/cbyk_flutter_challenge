import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';
import 'package:cbyk_flutter_challenge/core/helper/app_toast_helper.dart';
import 'package:cbyk_flutter_challenge/core/helper/mask_input_helper.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_gradients.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/core/config/responsive/app_responsive.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/widgets/brand_header.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/cubit/register_cubit.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/cubit/register_state.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/widgets/register_card.dart';
import 'package:cbyk_flutter_challenge/features/register/utils/mappers/register_page_mapper.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterCubit _cubit = Get.find<RegisterCubit>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final MaskTextInputFormatter _cpfMask = MaskInputHelper.cpfMaskWithInitial(
    null,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      _cubit.enableAutovalidate();
      return;
    }
    _cubit.register();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final horizontalPadding = responsive.when(
      mobile: 20.0,
      tablet: 48.0,
      desktop: 48.0,
    );
    final heroFlex = responsive.when(mobile: 4, tablet: 5, desktop: 5);
    final bodyFlex = responsive.when(mobile: 4, tablet: 5, desktop: 5);
    final formMaxWidth = responsive.when(
      mobile: 520.0,
      tablet: 520.0,
      desktop: 560.0,
    );
    final brandAlignment =
        responsive.isMobile ? Alignment.centerLeft : Alignment.center;
    final titleAlignment =
        responsive.isMobile ? Alignment.centerLeft : Alignment.center;
    final titleTextAlign =
        responsive.isMobile ? TextAlign.left : TextAlign.center;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>
            !identical(previous.submitResult, current.submitResult) &&
            (current.submitResult.isError || current.submitResult.isSuccess),
        listener: (context, state) {
          if (state.submitResult.isError) {
            AppToastHelper.show(
              state.submitResult.titleMessage,
              state.submitResult.descriptionMessage,
            );
          }
          if (state.submitResult.isSuccess) {
            Get.offAllNamed(AppRoutesMapper.home);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: heroFlex,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: AppGradients.hero,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: bodyFlex,
                      child: Container(color: AppColors.background),
                    ),
                  ],
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        16,
                        horizontalPadding,
                        16 + MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: formMaxWidth),
                        child: Column(
                          children: [
                            BrandHeader(alignment: brandAlignment),
                            const SizedBox(height: 28),
                            Align(
                              alignment: titleAlignment,
                              child: Text(
                                RegisterPageMapper.welcomeTitle,
                                textAlign: titleTextAlign,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: titleAlignment,
                              child: Text(
                                RegisterPageMapper.welcomeSubtitle,
                                textAlign: titleTextAlign,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.92,
                                      ),
                                      height: 1.35,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            RegisterCard(
                              formKey: _formKey,
                              nameController: _nameController,
                              cpfController: _cpfController,
                              passwordController: _passwordController,
                              cpfMask: _cpfMask,
                              obscurePassword: state.obscurePassword,
                              autovalidate: state.autovalidate,
                              isLoading: state.submitResult.isLoading,
                              onNameChanged: _cubit.onNameChanged,
                              onCpfChanged: _cubit.onCpfChanged,
                              onPasswordChanged: _cubit.onPasswordChanged,
                              onToggleObscurePassword:
                                  _cubit.toggleObscurePassword,
                              onSubmit: _submit,
                            ),
                            const SizedBox(height: 52),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
