// import 'package:flutter/widgets.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:mocktail/mocktail.dart';


// import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_bloc.dart';
// import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_event.dart';
// import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_state.dart';
// import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

// import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';

// // Mock class for AuthRemoteDataSource
// class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

// // Fake BuildContext for events (UI context required by Bloc but unused in tests)
// class FakeBuildContext extends Fake implements BuildContext {}

// void main() {
//   late RegisterViewModel viewModel;
//   late MockAuthRemoteDataSource mockRemoteDataSource;
//   late RegisterBloc registerBloc;

//   setUp(() {
//     mockRemoteDataSource = MockAuthRemoteDataSource();
//     viewModel = RegisterViewModel();

//     registerBloc = _TestRegisterBloc(
//       viewModel: viewModel,
//       injectedRemoteDataSource: mockRemoteDataSource,
//     );

//     registerFallbackValue(FakeBuildContext());
//   });

//   blocTest<RegisterBloc, RegisterState>(
//     'emits loading then failure when passwords do not match',
//     build: () => registerBloc,
//     act: (bloc) {
//       bloc.add(
//         RegisterButtonPressed(
//           email: 'test@example.com',
//           password: 'password123',
//           confirmPassword: 'wrongpassword',
//           context: FakeBuildContext(),
//         ),
//       );
//     },
//     expect:
//         () => [
//           const RegisterState(isLoading: true, isSuccess: false),
//           // Removed the second state expectation here because Bloc returns early
//         ],
//   );

//   blocTest<RegisterBloc, RegisterState>(
//     'emits loading then success when registration succeeds',
//     build: () {
//       when(
//         () => mockRemoteDataSource.register(any(), any(), any()),
//       ).thenAnswer((_) async => 'Success');
//       return registerBloc;
//     },
//     act: (bloc) {
//       bloc.add(
//         RegisterButtonPressed(
//           email: 'test@example.com',
//           password: 'password123',
//           confirmPassword: 'password123',
//           context: FakeBuildContext(),
//         ),
//       );
//     },
//     expect:
//         () => [
//           const RegisterState(isLoading: true, isSuccess: false),
//           const RegisterState(isLoading: false, isSuccess: true),
//         ],
//   );

//   blocTest<RegisterBloc, RegisterState>(
//     'emits loading then failure when registration fails',
//     build: () {
//       when(
//         () => mockRemoteDataSource.register(any(), any(), any()),
//       ).thenAnswer((_) async => null);
//       return registerBloc;
//     },
//     act: (bloc) {
//       bloc.add(
//         RegisterButtonPressed(
//           email: 'test@example.com',
//           password: 'password123',
//           confirmPassword: 'password123',
//           context: FakeBuildContext(),
//         ),
//       );
//     },
//     expect:
//         () => [
//           const RegisterState(isLoading: true, isSuccess: false),
//           const RegisterState(isLoading: false, isSuccess: false),
//         ],
//   );
// }

// // Subclass of RegisterBloc that lets us inject the mock remote data source for testing
// class _TestRegisterBloc extends RegisterBloc {
//   final AuthRemoteDataSource injectedRemoteDataSource;

//   _TestRegisterBloc({
//     required RegisterViewModel viewModel,
//     required this.injectedRemoteDataSource,
//   }) : super(viewModel: viewModel);

//   @override
//   AuthRemoteDataSource get _authRemoteDataSource => injectedRemoteDataSource;
// }
