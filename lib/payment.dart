import 'api_resource.dart';

class ErrorCode {
  static const TRANSACTION_MISSING = "transaction-missing";
}

const String PATH_VALIDATE = "/v2/validate-payment";

class Payment extends ApiResource {
  Payment(super.conn);

  dynamic validate(String transactionHash) {
    if (transactionHash == null || transactionHash.trim() == "") {
      throw Exception(ErrorCode.TRANSACTION_MISSING);
    }

    return connector.signAndSend(PATH_VALIDATE, {
      'transaction': transactionHash,
    });
  }
}
