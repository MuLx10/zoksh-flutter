import 'package:zoksh/connector.dart';
import 'package:zoksh/api_resource.dart';

class ErrorCode {
  static const INVALID_REQUEST = "invalid-request";
  static const MISSING_REQUEST_HEADERS = "missing-request-headers";
  static const INVALID_REQUEST_HEADERS = "invalid-request-headers";
  static const MISSING_REQUEST_BODY = "missing-request-body";
  static const INVALID_SIGNATURE = "invalid-signature";
}

class Webhook extends ApiResource {
  late Connector connector;
  late String endpoint;

  Webhook(Connector connector, String webhookEndPoint) : super(connector) {
    this.connector = connector;
    this.endpoint = webhookEndPoint;
  }

  Map<String, dynamic> _parse(Map<String, dynamic> req) {
    if (req == null) {
      throw Exception(ErrorCode.INVALID_REQUEST);
    }
    if (req["headers"] == null) {
      throw Exception(ErrorCode.MISSING_REQUEST_HEADERS);
    }
    if (req["body"] == null) {
      throw Exception(ErrorCode.MISSING_REQUEST_BODY);
    }

    Map<String, dynamic> headers = req["headers"];
    String zokshKey = headers["zoksh-key"];
    String zokshTs = headers["zoksh-ts"];
    String zokshSign = headers["zoksh-sign"];

    if (zokshKey == null || zokshTs == null || zokshSign == null) {
      throw Exception(ErrorCode.INVALID_REQUEST_HEADERS);
    }

    dynamic body = req["body"];
    return {
      "zokshKey": zokshKey,
      "zokshTs": zokshTs,
      "zokshSign": zokshSign,
      "body": body,
    };
  }

  bool test(Map<String, dynamic> req) {
    Map<String, dynamic> parsedData = _parse(req);
    String zokshSign = parsedData["zokshSign"];
    String zokshTs = parsedData["zokshTs"];
    dynamic body = parsedData["body"];

    Map<String, String> calculated =
        connector.calculateSignature(endpoint, body, int.parse(zokshTs));
    String signature = calculated["signature"]!;
    if (signature != zokshSign) {
      throw Exception(ErrorCode.INVALID_SIGNATURE);
    }
    return true;
  }

  dynamic handle(Map<String, dynamic> headers, dynamic body) {
    return test({"headers": headers, "body": body});
  }

  void express(Map<String, dynamic> req, dynamic res, Function next) {
    try {
      test(req);
      next(true);
    } catch (e) {
      if (next != null) {
        next(e);
      }
    }
  }
}
