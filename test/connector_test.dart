import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zoksh/zoksh.dart';
import 'package:zoksh/connector.dart';


void main() {
  group('Zoksh Tests', () {
    MockConnector mockConnector;
    Zoksh zoksh;

    setUp(() {
      // Initialize the mock Connector
      mockConnector = MockConnector();

      // Initialize Zoksh with the mock Connector
      zoksh = Zoksh(mockConnector);
    });

    test('Create Order Test', () async {
      // Set up the necessary variables for the test
      final orderInfo = OrderType(
        amount: '100.00',
        merchant: Merchant(orderId: 'ORDER123'),
      );

      // Set up the expected response
      final expectedResponse = OrderResponse(
        orderId: '123456789',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      // Mock the signAndSend method of the Connector
      when(mockConnector.signAndSend(any, any))
          .thenAnswer((_) => Future.value(expectedResponse));

      // Perform the test
      final response = await zoksh.order.create(orderInfo);

      // Verify the results
      expect(response, equals(expectedResponse));
      verify(mockConnector.signAndSend(PATH_CREATE, orderInfo)).called(1);
    });

    test('Validate Payment Test', () async {
      // Set up the necessary variables for the test
      final transactionHash = 'TRANSACTION123';

      // Set up the expected response
      final expectedResponse = {'status': 'success'};

      // Mock the signAndSend method of the Connector
      when(mockConnector.signAndSend(any, any))
          .thenAnswer((_) => Future.value(expectedResponse));

      // Perform the test
      final response = await zoksh.payment.validate(transactionHash);

      // Verify the results
      expect(response, equals(expectedResponse));
      verify(mockConnector.signAndSend(PATH_VALIDATE, {'transaction': transactionHash})).called(1);
    });
  });
}
