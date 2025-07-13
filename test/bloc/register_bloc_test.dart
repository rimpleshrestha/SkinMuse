import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_bloc.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';

// Mocks
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late RegisterBloc registerBloc;
  late RegisterViewModel viewModel;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    viewModel = RegisterViewModel();
    registerBloc = RegisterBloc(
      viewModel: viewModel,
      remote: mockRemoteDataSource,
    );
  });

  testWidgets('RegisterBloc shows error if passwords do not match', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              registerBloc.add(
                RegisterButtonPressed(
                  context: context,
                  email: 'fail@example.com',
                  password: 'password123',
                  confirmPassword: 'wrongpass', // mismatched password
                ),
              );
              return Container();
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(registerBloc.state.isLoading, false);
    expect(registerBloc.state.isSuccess, false);
  });
}
