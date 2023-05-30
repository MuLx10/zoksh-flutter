import 'package:zoksh/connector.dart';
import 'package:zoksh/order.dart';
import 'package:zoksh/webhook.dart';
import 'package:zoksh/payment.dart';

class Zoksh {
  late Connector connector;
  late Order _order;
  late Payment _payment;
  Webhook? _webhook;

  Zoksh(String zokshKey, String zokshSecret, {bool testnet = true}) {
    if (zokshKey.isEmpty) {
      throw Exception('Zoksh key missing');
    }
    if (zokshSecret.isEmpty) {
      throw Exception('Zoksh secret missing');
    }
    connector = Connector(zokshKey, zokshSecret, testnet);
    _order = Order(connector);
    _payment = Payment(connector);
  }

  Order get order => _order;

  Payment get payment => _payment;

  set webhookEndPoint(String url) {
    try {
      final parsed = Uri.parse(url);
      if (_webhook == null) {
        _webhook = Webhook(connector, parsed as String);
      }
    } catch (e) {
      throw e;
    }
  }

  Webhook get webhook {
    if (_webhook == null) {
      throw Exception(
          'Webhook end point not defined, please call zoksh.webhookEndPoint() first');
    }
    return _webhook!;
  }

  createOrder(Map<String, dynamic> body) async {
    return connector.signAndSend('/v2/order', body);
  }

  validatePayment(String transactionHash) async {
    return connector.signAndSend('/v2/validate-payment',
        {'transaction': transactionHash});
  }
}
