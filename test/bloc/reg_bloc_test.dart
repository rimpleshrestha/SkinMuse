import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_bloc.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_view_model.dart';


class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class FakeNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RegisterViewModel viewModel;
  late MockAuthRemoteDataSource mockRemote;

  setUp(() {
    viewModel = RegisterViewModel();
    mockRemote = MockAuthRemoteDataSource();

    // Patch Navigator.of(context) and ScaffoldMessenger.of(context)
    WidgetsBinding.instance.renderView.configuration = TestViewConfiguration();
  });

  blocTest<RegisterBloc, RegisterState>(
    'emits [loading, success] when registration succeeds',
    build: () {
      when(
        () => mockRemote.register(any(), any(), any()),
      ).thenAnswer((_) async => "success");
      return RegisterBloc(viewModel: viewModel, remote: mockRemote);
    },
    act:
        (bloc) => bloc.add(
          RegisterButtonPressed(
            email: 'test@test.com',
            password: '123456',
            confirmPassword: '123456',
            context: _FakeContext(), // we’ll define below
          ),
        ),
    expect:
        () => const [
          RegisterState(isLoading: true, isSuccess: false),
          RegisterState(isLoading: false, isSuccess: true),
        ],
  );

  blocTest<RegisterBloc, RegisterState>(
    'emits [loading, failure] when registration fails',
    build: () {
      when(
        () => mockRemote.register(any(), any(), any()),
      ).thenAnswer((_) async => null);
      return RegisterBloc(viewModel: viewModel, remote: mockRemote);
    },
    act:
        (bloc) => bloc.add(
          RegisterButtonPressed(
            email: 'test@test.com',
            password: '123456',
            confirmPassword: '123456',
            context: _FakeContext(),
          ),
        ),
    expect:
        () => const [
          RegisterState(isLoading: true, isSuccess: false),
          RegisterState(isLoading: false, isSuccess: false),
        ],
  );

  blocTest<RegisterBloc, RegisterState>(
    'emits [loading, failure] when passwords do not match',
    build: () => RegisterBloc(viewModel: viewModel, remote: mockRemote),
    act:
        (bloc) => bloc.add(
          RegisterButtonPressed(
            email: 'test@test.com',
            password: '123456',
            confirmPassword: 'wrongpass',
            context: _FakeContext(),
          ),
        ),
    expect:
        () => const [
          RegisterState(isLoading: true, isSuccess: false),
          RegisterState(isLoading: false, isSuccess: false),
        ],
  );

  blocTest<RegisterBloc, RegisterState>(
    'initial state is RegisterState.initial',
    build: () => RegisterBloc(viewModel: viewModel, remote: mockRemote),
    verify: (bloc) => expect(bloc.state, const RegisterState.initial()),
  );

  blocTest<RegisterBloc, RegisterState>(
    'emits [loading, success] on registration success with different email',
    build: () {
      when(
        () => mockRemote.register(any(), any(), any()),
      ).thenAnswer((_) async => 'success');
      return RegisterBloc(viewModel: viewModel, remote: mockRemote);
    },
    act:
        (bloc) => bloc.add(
          RegisterButtonPressed(
            email: 'new@test.com',
            password: 'abcdef',
            confirmPassword: 'abcdef',
            context: _FakeContext(),
          ),
        ),
    expect:
        () => const [
          RegisterState(isLoading: true, isSuccess: false),
          RegisterState(isLoading: false, isSuccess: true),
        ],
  );

  blocTest<RegisterBloc, RegisterState>(
    'emits [loading, failure] on registration failure with different email',
    build: () {
      when(
        () => mockRemote.register(any(), any(), any()),
      ).thenAnswer((_) async => null);
      return RegisterBloc(viewModel: viewModel, remote: mockRemote);
    },
    act:
        (bloc) => bloc.add(
          RegisterButtonPressed(
            email: 'fail@test.com',
            password: 'abcdef',
            confirmPassword: 'abcdef',
            context: _FakeContext(),
          ),
        ),
    expect:
        () => const [
          RegisterState(isLoading: true, isSuccess: false),
          RegisterState(isLoading: false, isSuccess: false),
        ],
  );

  blocTest<RegisterBloc, RegisterState>(
    'emits [loading, failure] when passwords do not match (different passwords)',
    build: () => RegisterBloc(viewModel: viewModel, remote: mockRemote),
    act:
        (bloc) => bloc.add(
          RegisterButtonPressed(
            email: 'nomatch@test.com',
            password: 'pass1',
            confirmPassword: 'pass2',
            context: _FakeContext(),
          ),
        ),
    expect:
        () => const [
          RegisterState(isLoading: true, isSuccess: false),
          RegisterState(isLoading: false, isSuccess: false),
        ],
  );

  

  blocTest<RegisterBloc, RegisterState>(
    'emits [loading, failure] multiple times for multiple failed registrations',
    build: () {
      when(
        () => mockRemote.register(any(), any(), any()),
      ).thenAnswer((_) async => null);
      return RegisterBloc(viewModel: viewModel, remote: mockRemote);
    },
    act: (bloc) async {
      bloc.add(
        RegisterButtonPressed(
          email: 'fail1@test.com',
          password: 'pass123',
          confirmPassword: 'pass123',
          context: _FakeContext(),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 10));
      bloc.add(
        RegisterButtonPressed(
          email: 'fail2@test.com',
          password: 'pass456',
          confirmPassword: 'pass456',
          context: _FakeContext(),
        ),
      );
    },
    expect:
        () => const [
          RegisterState(isLoading: true, isSuccess: false),
          RegisterState(isLoading: false, isSuccess: false),
          RegisterState(isLoading: true, isSuccess: false),
          RegisterState(isLoading: false, isSuccess: false),
        ],
  );

  blocTest<RegisterBloc, RegisterState>(
    'emits nothing when no events are added',
    build: () => RegisterBloc(viewModel: viewModel, remote: mockRemote),
    expect: () => const [],
  );

  blocTest<RegisterBloc, RegisterState>(
    'emits [loading, failure] when RegisterButtonPressed with empty email',
    build: () {
      when(
        () => mockRemote.register(any(), any(), any()),
      ).thenAnswer((_) async => null); // Stub to avoid exceptions
      return RegisterBloc(viewModel: viewModel, remote: mockRemote);
    },
    act:
        (bloc) => bloc.add(
          RegisterButtonPressed(
            email: '',
            password: '123456',
            confirmPassword: '123456',
            context: _FakeContext(),
          ),
        ),
    expect:
        () => const [
          RegisterState(isLoading: true, isSuccess: false),
          RegisterState(isLoading: false, isSuccess: false),
        ],
  );






}

class _FakeContext extends Fake implements BuildContext {}
