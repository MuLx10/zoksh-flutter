// ignore_for_file: unnecessary_null_comparison

import 'package:zoksh/api_resource.dart';

class Prefill {
  String? name;
  String? email;
  String? phone;
}

class Merchant {
  late String orderId;
  String? desc;
  String? extra;
}

class Route {
  bool? autoSettle;
}

class OrderType {
  Prefill? prefill;
  String? fiat;
  late String amount;
  String? token;
  String? preferredCurrency;
  String? mandatoryCurrency;
  String? preferredChain;
  String? mandatoryChain;
  String? label;
  late Merchant merchant;
  String? product;
  Route? route;
}

class OrderResponse {
  late String orderId;
  late int createdAt;

  OrderResponse(String orderId, int createdAt) {
    this.orderId = orderId;
    this.createdAt = createdAt;
  }
}

class ErrorCode {
  static const String INVALID_AMOUNT = 'invalid-amount';
  static const String MERCHANT_MISSING = 'merchant-order-missing';
}

const String PATH_CREATE = '/v2/order';

class Order extends ApiResource {
  Order(super.conn);

  Future<OrderResponse> create(OrderType info) async {
    if (info.amount == null || info.amount.isEmpty) {
      throw Exception(ErrorCode.INVALID_AMOUNT);
    }
    final im = info.amount.trim();
    if (im.isEmpty) {
      throw Exception(ErrorCode.INVALID_AMOUNT);
    }
    try {
      final am = double.parse(info.amount);
      if (am.isNaN || am < 0) {
        throw Exception(ErrorCode.INVALID_AMOUNT);
      }
    } catch (e) {
      throw e;
    }
    if (info.merchant == null) {
      throw Exception(ErrorCode.MERCHANT_MISSING);
    }
    if (info.merchant.orderId == null || info.merchant.orderId.isEmpty) {
      throw Exception(ErrorCode.MERCHANT_MISSING);
    }

    final response = await connector.signAndSend(PATH_CREATE, info as Map<String, dynamic>);
    // Parse the response and return the OrderResponse object
    return OrderResponse(
      response['orderId'],
      response['createdAt'],
    );
  }
}
