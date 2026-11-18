import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskInputHelper {
  static MaskTextInputFormatter cpfMaskWithInitial(String? initialText) =>
      MaskTextInputFormatter(
        mask: '###.###.###-##',
        filter: {'#': RegExp('[0-9]')},
        initialText: initialText,
      );

  static String formatCpf(String? value) {
    if (value == null || value.isEmpty) return '';
    final digits = unmaskCpf(value);
    return cpfMaskWithInitial(null).maskText(digits);
  }

  static String unmaskCpf(String value) => value.replaceAll(RegExp(r'\D'), '');
}
