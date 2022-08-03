import 'package:flutter_d8_user_settings/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future saveSettings(Settings settings) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString('username', settings.username);
    await preferences.setBool('isEmployeed', settings.isEmployed);
    await preferences.setInt('gender', settings.gender.index);
    //convert to string
    List<String> list = settings.programmingLanguage.map((lang) {
      return lang.index.toString();
    }).toList();
    await preferences.setStringList('programmingLanguage', list);

    print('Saved Settings');
  }

  Future<Settings> getSettings() async {
    final preferences = await SharedPreferences.getInstance();

    final username = preferences.getString('username') ?? "";
    final isEmployed = preferences.getBool('isEmployed') ?? false;
    final gender = Gender.values[preferences.getInt('gender') ?? 0];

    List<String> programmingLanguageIndicies =
        preferences.getStringList('programmingLanguage') as List<String>;

    final programmingLanguages =
        programmingLanguageIndicies.map((stringIndex) {
      return ProgrammingLanguage.values[int.parse(stringIndex)];
    }).toSet();

    return Settings(
        username: username,
        gender: gender,
        programmingLanguage: programmingLanguages,
        isEmployed: isEmployed);
  }
}
