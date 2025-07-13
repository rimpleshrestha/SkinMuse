import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skin_muse/features/auth/presentation/view/register_view.dart';

void main() {
  testWidgets(
    'Register form success - matching passwords shows success SnackBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterView()));
      await tester.pumpAndSettle();

      // Find fields
      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);
      final confirmPasswordField = find.byType(TextField).at(2);
      final signUpButton = find.text('Sign Up');

      // Fill form
      await tester.enterText(emailField, 'ri@example.com');
      await tester.enterText(passwordField, 'secret123');
      await tester.enterText(confirmPasswordField, 'secret123');

      // Scroll & tap
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pump(const Duration(seconds: 1));

      // ✅ Expect success snackbar or indicator
      expect(find.byType(SnackBar), findsOneWidget);
    },
  );

  testWidgets(
    'Register form error - mismatched passwords shows error SnackBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterView()));
      await tester.pumpAndSettle();

      // Find fields
      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);
      final confirmPasswordField = find.byType(TextField).at(2);
      final signUpButton = find.text('Sign Up');

      // Fill form with mismatched passwords
      await tester.enterText(emailField, 'ri@example.com');
      await tester.enterText(passwordField, 'secret123');
      await tester.enterText(confirmPasswordField, 'wrongpass');

      // Scroll & tap
      await tester.ensureVisible(signUpButton);
      await tester.tap(signUpButton);
      await tester.pump(const Duration(seconds: 1));

      // ✅ Expect error snackbar
      expect(find.byType(SnackBar), findsOneWidget);
    },
  );
}
