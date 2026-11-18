import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';
import 'package:cbyk_flutter_challenge/core/helper/app_toast_helper.dart';
import 'package:cbyk_flutter_challenge/core/helper/validator_helper.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/features/auth/utils/mappers/login_page_mapper.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/input/app_text_field.dart';
import 'package:cbyk_flutter_challenge/features/auth/presentation/widgets/auth_mode_bar.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/button/gradient_circle_button.dart';


class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.formKey,
    required this.cpfController,
    required this.passwordController,
    required this.cpfMask,
    required this.obscurePassword,
    required this.rememberAlways,
    required this.autovalidate,
    required this.isLoading,
    required this.onCpfChanged,
    required this.onPasswordChanged,
    required this.onToggleObscurePassword,
    required this.onToggleRememberAlways,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController cpfController;
  final TextEditingController passwordController;
  final MaskTextInputFormatter cpfMask;
  final bool obscurePassword;
  final bool rememberAlways;
  final bool autovalidate;
  final bool isLoading;
  final ValueChanged<String> onCpfChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onToggleObscurePassword;
  final ValueChanged<bool?> onToggleRememberAlways;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            autovalidateMode: autovalidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthModeBar(
                  loginSelected: true,
                  loginLabel: LoginPageMapper.tabEnter,
                  registerLabel: LoginPageMapper.tabRegister,
                  onLoginTap: () {},
                  onRegisterTap: () => Get.offNamed(AppRoutesMapper.register),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  hint: LoginPageMapper.hintCpf,
                  controller: cpfController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [cpfMask],
                  onChanged: onCpfChanged,
                  validator: ValidatorHelper.cpf,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  hint: LoginPageMapper.hintPassword,
                  controller: passwordController,
                  obscureText: obscurePassword,
                  textInputAction: TextInputAction.done,
                  onChanged: onPasswordChanged,
                  onFieldSubmitted: (_) => onSubmit(),
                  validator: ValidatorHelper.password,
                  suffix: IconButton(
                    onPressed: onToggleObscurePassword,
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: rememberAlways,
                        onChanged: onToggleRememberAlways,
                        activeColor: AppColors.tealBright,
                        side: const BorderSide(color: AppColors.tealBright),
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        LoginPageMapper.rememberAlways,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        AppToastHelper.show(
                          'Recuperar senha',
                          LoginPageMapper.forgotPasswordSnack,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        LoginPageMapper.forgotPassword,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.tealBright,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -28,
          child: GradientCircleButton(
            onPressed: onSubmit,
            isLoading: isLoading,
            enabled: !isLoading,
          ),
        ),
      ],
    );
  }
}
