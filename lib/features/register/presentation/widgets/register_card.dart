import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cbyk_flutter_challenge/core/config/theme/app_colors.dart';
import 'package:cbyk_flutter_challenge/core/helper/validator_helper.dart';
import 'package:cbyk_flutter_challenge/core/config/routes/app_routes_mapper.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/input/app_text_field.dart';
import 'package:cbyk_flutter_challenge/features/register/presentation/widgets/auth_mode_bar.dart';
import 'package:cbyk_flutter_challenge/features/register/utils/mappers/register_page_mapper.dart';
import 'package:cbyk_flutter_challenge/core/presentation/widgets/button/gradient_circle_button.dart';

class RegisterCard extends StatelessWidget {
  const RegisterCard({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.cpfController,
    required this.passwordController,
    required this.cpfMask,
    required this.obscurePassword,
    required this.autovalidate,
    required this.isLoading,
    required this.onNameChanged,
    required this.onCpfChanged,
    required this.onPasswordChanged,
    required this.onToggleObscurePassword,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController cpfController;
  final TextEditingController passwordController;
  final MaskTextInputFormatter cpfMask;
  final bool obscurePassword;
  final bool autovalidate;
  final bool isLoading;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onCpfChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onToggleObscurePassword;
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
                  loginSelected: false,
                  loginLabel: RegisterPageMapper.tabEnter,
                  registerLabel: RegisterPageMapper.tabRegister,
                  onLoginTap: () => Get.offNamed(AppRoutesMapper.login),
                  onRegisterTap: () {},
                ),
                const SizedBox(height: 24),
                AppTextField(
                  hint: RegisterPageMapper.hintName,
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  onChanged: onNameChanged,
                  validator: ValidatorHelper.name,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  hint: RegisterPageMapper.hintCpf,
                  controller: cpfController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [cpfMask],
                  onChanged: onCpfChanged,
                  validator: ValidatorHelper.cpf,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  hint: RegisterPageMapper.hintPassword,
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
