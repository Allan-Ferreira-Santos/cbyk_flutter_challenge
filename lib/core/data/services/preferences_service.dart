import 'package:shared_preferences/shared_preferences.dart';

import 'package:cbyk_flutter_challenge/core/data/mappers/shared_prefs_keys_mapper.dart';

class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  bool get rememberAlways =>
      _prefs.getBool(SharedPrefsKeysMapper.rememberAlways) ?? false;

  Future<void> setRememberAlways(bool value) =>
      _prefs.setBool(SharedPrefsKeysMapper.rememberAlways, value);

  String? get savedCpf => _prefs.getString(SharedPrefsKeysMapper.savedCpf);

  Future<void> setSavedCpf(String? cpf) async {
    if (cpf == null || cpf.isEmpty) {
      await _prefs.remove(SharedPrefsKeysMapper.savedCpf);
      return;
    }
    await _prefs.setString(SharedPrefsKeysMapper.savedCpf, cpf);
  }
}
