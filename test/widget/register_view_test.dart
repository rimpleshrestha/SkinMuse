import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skin_muse/features/auth/presentation/view/register_view.dart';

void main() {
  testWidgets('Register form UI test', (WidgetTester tester) async {
    // Load the RegisterView inside a MaterialApp for proper widget testing
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));

    // Wait for animations to settle
    await tester.pumpAndSettle();

    // Find widgets
    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final confirmPasswordField = find.byType(TextField).at(2);
    final signUpButton = find.text('Sign Up');

    // Enter data
    await tester.enterText(emailField, 'ri@example.com');
    await tester.enterText(passwordField, 'secret123');
    await tester.enterText(confirmPasswordField, 'secret123');

    // Ensure it's visible before tapping
    await tester.ensureVisible(signUpButton);

    // Tap Sign Up
    await tester.tap(signUpButton);

    // Allow any UI animations like SnackBar
    await tester.pump(const Duration(seconds: 1));

    // Check for SnackBar (can fail if logic is API dependent)
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
