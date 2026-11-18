import 'package:cbyk_flutter_challenge/core/helper/mask_input_helper.dart';
import 'package:cbyk_flutter_challenge/core/utils/mappers/validate_mapper.dart';

abstract class ValidatorHelper {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return ValidateMapper.nameEmpty;
    if (value.trim().length < 3) return ValidateMapper.nameTooShort;

    final regex = RegExp(r'^[A-Za-zÀ-ÖØ-öø-ÿ\s]+$');
    if (!regex.hasMatch(value.trim())) return ValidateMapper.nameInvalid;

    return null;
  }

  static String? cpf(String? value) {
    if (value == null || value.trim().isEmpty) return ValidateMapper.cpfEmpty;

    final digits = MaskInputHelper.unmaskCpf(value);
    if (digits.length != 11) return ValidateMapper.cpfInvalid;

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidateMapper.passwordEmpty;
    }
    if (value.length < 6) return ValidateMapper.passwordLength;

    return null;
  }
}
