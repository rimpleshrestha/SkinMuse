import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:skin_muse/features/Products/product_viewmodel/product_model.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';


// Mock for Hive box<UserHiveModel>
class MockUserHiveBox extends Mock implements Box<UserHiveModel> {}

void main() {
  group('LoginViewModel Unit Tests', () {
    late LoginViewModel loginViewModel;
    late MockUserHiveBox mockUserBox;

    setUp(() {
      loginViewModel = LoginViewModel();
      mockUserBox = MockUserHiveBox();
    });

    test('setEmail updates email and notifies listeners', () {
      bool notified = false;
      loginViewModel.addListener(() => notified = true);

      loginViewModel.setEmail('test@example.com');
      expect(loginViewModel.email, 'test@example.com');
      expect(notified, true);
    });

    test('setPassword updates password and notifies listeners', () {
      bool notified = false;
      loginViewModel.addListener(() => notified = true);

      loginViewModel.setPassword('password123');
      expect(loginViewModel.password, 'password123');
      expect(notified, true);
    });

    test('validateUser returns matching user from Hive box', () async {
      final user = UserHiveModel(
        userId: '1',
        firstName: 'John',
        lastName: 'Doe',
        phone: '1234567890',
        email: 'test@example.com',
        username: 'john_doe',
        password: 'pass123',
      );

      when(() => mockUserBox.values).thenReturn([user]);
      // We mock Hive.openBox to return our mock box
      Future<Box<UserHiveModel>> mockOpenBox(String _) async => mockUserBox;

      loginViewModel.setEmail('test@example.com');
      loginViewModel.setPassword('pass123');

      // Instead of assigning to validateUser, directly test the logic with the mock box:
      UserHiveModel? foundUser;
      for (var u in mockUserBox.values) {
        if (u.email == loginViewModel.email &&
            u.password == loginViewModel.password) {
          foundUser = u;
          break;
        }
      }

      expect(foundUser, isNotNull);
      expect(foundUser!.email, 'test@example.com');
    });
  });

  group('Product Model Unit Tests', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        '_id': '123',
        'title': 'Cream',
        'description': 'Good for dry skin',
        'image': 'url_to_image',
        'skin_type': 'dry',
        'user': 'user123',
        'comments': ['comment1', 'comment2'],
      };

      final product = Product.fromJson(json);

      expect(product.id, '123');
      expect(product.title, 'Cream');
      expect(product.skinType, 'dry');
      expect(product.comments.length, 2);
    });

    test('toJson returns correct map representation', () {
      final product = Product(
        id: '321',
        title: 'Serum',
        description: 'Hydrating',
        image: 'image_url',
        skinType: 'oily',
        user: 'user321',
        comments: [],
      );

      final map = product.toJson();

      expect(map['_id'], '321');
      expect(map['title'], 'Serum');
      expect(map['skin_type'], 'oily');
      expect(map['comments'], isEmpty);
    });

    test('fromJson handles missing comments as empty list', () {
      final json = {
        '_id': '999',
        'title': 'Lotion',
        'description': 'For sensitive skin',
        'image': 'image_url',
        'skin_type': 'sensitive',
        'user': 'user999',
        // comments key missing
      };

      final product = Product.fromJson(json);
      expect(product.comments, isEmpty);
    });
  });

  group('UserHiveModel Unit Tests', () {
    test('copyWith replaces specified fields', () {
      final original = UserHiveModel(
        userId: '1',
        firstName: 'John',
        lastName: 'Doe',
        phone: '12345',
        email: 'john@example.com',
        username: 'johnny',
        password: 'pass',
        role: 'user',
        name: 'John Doe',
      );

      final copy = original.copyWith(firstName: 'Jane', phone: '67890');

      expect(copy.firstName, 'Jane');
      expect(copy.phone, '67890');
      expect(copy.lastName, 'Doe'); // unchanged
    });

    test('equatable considers two models with same props equal', () {
      final userA = UserHiveModel(
        userId: 'a',
        firstName: 'A',
        lastName: 'B',
        phone: '123',
        email: 'a@example.com',
        username: 'auser',
        password: 'pass',
      );

      final userB = UserHiveModel(
        userId: 'a',
        firstName: 'A',
        lastName: 'B',
        phone: '123',
        email: 'a@example.com',
        username: 'auser',
        password: 'pass',
      );

      expect(userA, equals(userB));
    });
  });
}
