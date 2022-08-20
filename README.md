# flutter_d8_user_settings

- models.dart
```dart
enum Gender { FEMALE, MALE, OTHER }

enum ProgrammingLanguage { DART, JAVASCRIPT, KOTLIN, SWIFT }


class Settings{
  final String username;
  final Gender gender;
  final Set<ProgrammingLanguage> programmingLanguage;
  final bool isEmployed;

  Settings({required this.username,required this.gender, required this.programmingLanguage,required this.isEmployed});
}
```
- preferences_service.dart
```dart
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
```
- main.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_d8_user_settings/models.dart';
import 'package:flutter_d8_user_settings/preferences_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _preferencesService = PreferencesService();

  final _usernameController = TextEditingController();
  var _selectedGender = Gender.FEMALE;
  var _selectedLanguages = Set<ProgrammingLanguage>();
  var _isEmployed = false;

  @override
  void initState() {
    super.initState();
    _papulateFields();
  }

  void _papulateFields() async{
    final settings = await _preferencesService.getSettings();
    setState(() {
      _usernameController.text = settings.username;
      _selectedGender = settings.gender;
      _selectedLanguages = settings.programmingLanguage;
      _isEmployed = settings.isEmployed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("User Settings"),
        ),
        body: ListView(
          children: [
            ListTile(
              title: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
            ),
            RadioListTile(
              title: const Text('Female'),
              value: Gender.FEMALE,
              groupValue: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue as Gender;
                });
              },
            ),
            RadioListTile(
              title: const Text('Male'),
              value: Gender.MALE,
              groupValue: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue as Gender;
                });
              },
            ),
            RadioListTile(
              title: const Text('Other'),
              value: Gender.OTHER,
              groupValue: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue as Gender;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Dart'),
              value: _selectedLanguages.contains(ProgrammingLanguage.DART),
              onChanged: (_) {
                setState(() {
                  _selectedLanguages.contains(ProgrammingLanguage.DART)
                      ? _selectedLanguages.remove(ProgrammingLanguage.DART)
                      : _selectedLanguages.add(ProgrammingLanguage.DART);
                });
              },
            ),
            CheckboxListTile(
              title: const Text('JavaScript'),
              value:
                  _selectedLanguages.contains(ProgrammingLanguage.JAVASCRIPT),
              onChanged: (_) {
                setState(() {
                  _selectedLanguages.contains(ProgrammingLanguage.JAVASCRIPT)
                      ? _selectedLanguages
                          .remove(ProgrammingLanguage.JAVASCRIPT)
                      : _selectedLanguages.add(ProgrammingLanguage.JAVASCRIPT);
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Kotlin'),
              value: _selectedLanguages.contains(ProgrammingLanguage.KOTLIN),
              onChanged: (_) {
                setState(() {
                  _selectedLanguages.contains(ProgrammingLanguage.KOTLIN)
                      ? _selectedLanguages.remove(ProgrammingLanguage.KOTLIN)
                      : _selectedLanguages.add(ProgrammingLanguage.KOTLIN);
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Swift'),
              value: _selectedLanguages.contains(ProgrammingLanguage.SWIFT),
              onChanged: (_) {
                setState(() {
                  _selectedLanguages.contains(ProgrammingLanguage.SWIFT)
                      ? _selectedLanguages.remove(ProgrammingLanguage.SWIFT)
                      : _selectedLanguages.add(ProgrammingLanguage.SWIFT);
                });
              },
            ),
            SwitchListTile(
              title: const Text("Is Employed"),
              value: _isEmployed,
              onChanged: (newValue) {
                setState(() {
                  _isEmployed = newValue;
                });
              },
            ),
            TextButton(
                onPressed: _saveSettings, child: const Text('Save Settings'))
          ],
        ),
      ),
    );
  }

  void _saveSettings() {
    Settings newSettings = Settings(
        username: _usernameController.text,
        gender: _selectedGender,
        programmingLanguage: _selectedLanguages,
        isEmployed: _isEmployed);
    print(newSettings);

    _preferencesService.saveSettings(newSettings);
  }
}
```

---

```
Copyright 2022 M. Fadli Zein
```