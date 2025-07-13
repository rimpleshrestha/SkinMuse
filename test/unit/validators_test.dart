import 'package:flutter_test/flutter_test.dart';
import 'package:skin_muse/core/utils/validators.dart';


void main() {
  group('Email Validation', () {
    test('Valid email returns true', () {
      expect(Validators.isValidEmail('ri@example.com'), true);
    });

    test('Invalid email returns false', () {
      expect(Validators.isValidEmail('ri@com'), false);
    });
  });

  group('Password Validation', () {
    test('Password with 6+ characters returns true', () {
      expect(Validators.isValidPassword('secret123'), true);
    });

    test('Short password returns false', () {
      expect(Validators.isValidPassword('abc'), false);
    });
  });

  group('Name Validation', () {
    test('Non-empty name returns true', () {
      expect(Validators.isValidName('Ri'), true);
    });

    test('Empty name returns false', () {
      expect(Validators.isValidName('   '), false);
    });
  });

  group('Password Match Validation', () {
    test('Passwords that match returns true', () {
      expect(Validators.doPasswordsMatch('secret123', 'secret123'), true);
    });

    test('Passwords that do not match returns false', () {
      expect(Validators.doPasswordsMatch('secret123', 'secret'), false);
    });
  });
}
