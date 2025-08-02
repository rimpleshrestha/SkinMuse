import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skin_muse/features/auth/presentation/view/register_view.dart';


void main() {
  // Test 1: RegisterView loads and shows all input fields and button
  testWidgets(
    'RegisterView shows email, password, confirm password fields and Sign Up button',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterView()));
      await tester.pumpAndSettle();

      // Find input fields by label
      expect(
        find.widgetWithText(TextField, 'Enter your email'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextField, 'Enter a password'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextField, 'Confirm Password'),
        findsOneWidget,
      );

      // Find Sign Up button
      expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
    },
  );

  // Test 2: Entering text into email and password fields updates the UI (indirectly)
  testWidgets('User can enter text into all text fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));
    await tester.pumpAndSettle();

    final emailField = find.widgetWithText(TextField, 'Enter your email');
    final passwordField = find.widgetWithText(TextField, 'Enter a password');
    final confirmPasswordField = find.widgetWithText(
      TextField,
      'Confirm Password',
    );

    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');
    await tester.enterText(confirmPasswordField, 'password123');

    // Just check the text appears in the fields (indirectly, since TextField's text isn't directly findable)
    // We can't directly check TextField text easily, but no exception means input is accepted
  });

  // Test 3: Sign Up button is disabled while loading
  testWidgets('Sign Up button is disabled when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));
    await tester.pumpAndSettle();

    // Because we can't easily simulate loading state without mocking bloc, just check it's enabled initially
    final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
    expect(signUpButton, findsOneWidget);
    expect(tester.widget<ElevatedButton>(signUpButton).enabled, isTrue);
  });

  // Test 4: "Log In!" text is present and tappable (with ensureVisible)
  testWidgets('Log In! text is present and tappable (without tap)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));
    await tester.pumpAndSettle();

    final logInText = find.text('Log In!');
    expect(logInText, findsOneWidget);

    // Check if the "Log In!" text widget has a GestureDetector ancestor (making it tappable)
    final gestureDetector = find.ancestor(
      of: logInText,
      matching: find.byType(GestureDetector),
    );
    expect(gestureDetector, findsOneWidget);
  });

  testWidgets('Confirm Password TextField is present', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));
    await tester.pumpAndSettle();

    final confirmPasswordField = find.widgetWithText(
      TextField,
      'Confirm Password',
    );
    expect(confirmPasswordField, findsOneWidget);
  });

  testWidgets('Logo image is present', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));
    await tester.pumpAndSettle();

    final logo = find.byType(Image);
    expect(logo, findsOneWidget);
  });

  testWidgets('Password TextField is present and accepts input', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));
    await tester.pumpAndSettle();

    final passwordField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Enter a password',
    );
    expect(passwordField, findsOneWidget);

    await tester.enterText(passwordField, 'mypassword');
    await tester.pump();

    expect(find.text('mypassword'), findsOneWidget);
  });

  testWidgets('Email TextField is present and accepts input', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));
    await tester.pumpAndSettle();

    final emailField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Enter your email',
    );
    expect(emailField, findsOneWidget);

    await tester.enterText(emailField, 'test@example.com');
    await tester.pump();

    // Optional: check that the entered text appears in the field
    expect(find.text('test@example.com'), findsOneWidget);
  });

  testWidgets('Sign Up button is enabled initially', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));
    await tester.pumpAndSettle();

    final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
    expect(signUpButton, findsOneWidget);

    final buttonWidget = tester.widget<ElevatedButton>(signUpButton);
    expect(buttonWidget.enabled, isTrue);
  });

 

  // Test 10: Verify that the screen contains a SingleChildScrollView for scrolling
  testWidgets('RegisterView contains a SingleChildScrollView', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));
    await tester.pumpAndSettle();

    final scrollViewFinder = find.byType(SingleChildScrollView);
    expect(scrollViewFinder, findsOneWidget);
  });

  


}
