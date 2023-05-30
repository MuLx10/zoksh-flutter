import 'package:zoksh/connector.dart';

class ApiResource {
  late Connector connector;

  ApiResource(Connector conn) {
    this.connector = conn;
  }
}
