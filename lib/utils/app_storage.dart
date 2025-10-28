import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppStorage {
  // ✅ Separate secure storage for planning-related data
  static const planningStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      sharedPreferencesName: 'planning_data',
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
}
