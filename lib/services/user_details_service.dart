import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/user_details_modal.dart';

class UserDetailsService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<UserDetailsModal?> fetchUserDetails() async {
    try {
      // Get sid and userId from secure storage
      final String? sid = await _secureStorage.read(key: 'sid');
      final String? userId = await _secureStorage.read(key: 'email');

      if (sid == null) {
        throw Exception("SID not found in secure storage");
      }

      if (userId == null) {
        throw Exception("User ID not found in secure storage");
      }

      final Uri url = Uri.parse(
        '${ApiConstants.baseUrl}auth.get_user_details?user_id=$userId',
      );

      final response = await http.get(url, headers: {"Cookie": "sid=$sid"});

      if (response.statusCode == 200) {
        final userDetails = userDetailsModalFromJson(response.body);

        // ✅ Extract user object
        final user = userDetails.message.user;

        // ✅ Store specific values in secure storage
        await _secureStorage.write(
          key: 'employee_full_name',
          value: user.employeeFullName,
        );
        await _secureStorage.write(key: 'designation', value: user.designation);
        await _secureStorage.write(key: 'image', value: user.image);
        await _secureStorage.write(key: 'mobile', value: user.mobileNo);
        await _secureStorage.write(
          key: 'employee_original_id',
          value: user.employeeId,
        );

        return userDetails;
      } else {
        throw Exception(
          "Failed to load user details: ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
