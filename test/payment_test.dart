import 'package:flutter_test/flutter_test.dart';
import 'package:zoksh/payment.dart';
import 'package:zoksh/connector.dart';

void main() {
  group('Payment', () {
    late Payment payment;

    setUp(() {
      // Create a new instance of Payment before each test
      payment = Payment(MockApiResourceConnector());
    });

    test('validate should throw an error if transactionHash is missing', () {
      // Arrange
      final String invalidTransactionHash = '';

      // Act & Assert
      expect(() => payment.validate(invalidTransactionHash),
          throwsAssertionError);
    });

    test('validate should call signAndSend with the correct parameters', () {
      // Arrange
      final String validTransactionHash = '12345';

      // Act
      final result = payment.validate(validTransactionHash);

      // Assert
      // Add assertions based on the expected behavior of the signAndSend method
    });
  });
}

// Mock implementation of ApiResourceConnector for testing
class MockApiResourceConnector implements Connector {
  @override
  Future<dynamic> signAndSend(
    String path,
    Map<String, dynamic> body, [
    int stamp = -1,
  ]) {
    return {};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
