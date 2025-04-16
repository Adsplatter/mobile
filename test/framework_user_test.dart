import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('User class', () {
    setUp(() {
      // Reset shared prefs before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('User instantiation and basic getters', () {
      final user = User(
        cookie: 'Y29va2ll', // "cookie" in base64
        loggedIn: true,
        status: 1,
        uqid: '123e4567-e89b-12d3-a456-426614174000',
        email: 'test@example.com',
        mobile: '1234567890',
        password: 'secret',
        provider: 'google',
        accountCreated: 1610000000,
        lastLogin: 1620000000,
        birthDate: 946684800, // Jan 1, 2000
        firstName: 'John',
        lastName: 'Doe',
        addressLine1: '123 Test St',
        addressLine2: 'Apt 456',
        city: 'Testville',
        state: 'TS',
        postcode: '12345',
        country: 'Testland',
      );

      expect(user.cookieDecoded, 'cookie');
      expect(user.email, 'test@example.com');
      expect(user.loggedIn, isTrue);
      expect(user.status, 1);
      expect(user.uqid, '123e4567-e89b-12d3-a456-426614174000');
      expect(user.firstName, 'John');
      expect(user.accountCreatedString, isNotEmpty);
      expect(user.birthDateString, '01/Jan/2000');
    });

    test('User.save() writes data to SharedPreferences', () async {
      final user = User(
        cookie: 'Y29va2ll',
        loggedIn: true,
        status: 1,
        uqid: 'uid123',
        email: 'save@test.com',
        mobile: '9999999999',
        password: 'pw',
        provider: 'facebook',
        accountCreated: 1650000000,
        lastLogin: 1660000000,
        birthDate: 915148800, // Jan 1, 1999
        firstName: 'Savey',
        lastName: 'McSave',
        addressLine1: '1 Save Rd',
        addressLine2: '',
        city: 'Saver City',
        state: 'SV',
        postcode: '00000',
        country: 'SaveLand',
      );

      await user.save();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('userEmail'), 'save@test.com');
      expect(prefs.getString('userLogInCookie'), 'Y29va2ll');
      expect(prefs.getBool('userLoggedIn'), true);
    });
  });
}