import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

const String SANDBOX_NETWORK_PATH = "payments.sandbox.zoksh.com";
const String PROD_NETWORK_PATH = "payments.zoksh.com";

class Connector {
  late String zokshKey;
  late String zokshSecret;
  late String basePath;

  Connector(String zokshKey, String zokshSecret, bool testnet, {bool sandbox = true}) {
    this.zokshKey = zokshKey;
    this.zokshSecret = zokshSecret;
    basePath = sandbox ? SANDBOX_NETWORK_PATH : PROD_NETWORK_PATH;
  }

  Map<String, String> calculateSignature(
    String path,
    Map<String, dynamic> body, [
    int useTime = -1,
  ]) {
    final postBody = json.encode(body);
    final ts = useTime != -1 ? useTime : DateTime.now().millisecondsSinceEpoch;
    final hmac = Hmac(sha256, utf8.encode(zokshSecret));
    
    final toSign = '$ts$path$postBody';
    final signature = hmac.convert(utf8.encode(toSign)).toString();

    return {
      "ts": ts.toString(),
      "signature": signature,
    };
  }

  Future<dynamic> doRequest(
    Map<String, dynamic> options,
    List<int> data,
  ) async {
    final conn = HttpClient();

    final request = await conn.postUrl(Uri.https(
      options["hostname"],
      options["path"],
    ));

    request.headers.add("Content-Type", options["headers"]["Content-Type"]);
    request.headers.add("Content-Length", options["headers"]["Content-Length"]);
    request.headers.add("ZOKSH-KEY", options["headers"]["ZOKSH-KEY"]);
    request.headers.add("ZOKSH-TS", options["headers"]["ZOKSH-TS"]);
    request.headers.add("ZOKSH-SIGN", options["headers"]["ZOKSH-SIGN"]);
    
    request.contentLength = data.length;
    request.add(data);

    final response = await request.close();
    final statusCode = response.statusCode;

    if (statusCode == HttpStatus.movedPermanently ||
        statusCode == HttpStatus.found) {
      if (options["redirectCount"] < 3) {
        options["redirectCount"] += 1;
        final loc = response.headers.value("location");
        final url = Uri.parse(loc!);

        final opts = {
          "method": "POST",
          "hostname": url.host,
          "path": url.path,
          "headers": options["headers"],
          "redirectCount": options["redirectCount"],
        };

        return await doRequest(opts, data);
      } else {
        throw Exception("Server redirected too many times");
      }
    }

    final responseBody = await response.transform(utf8.decoder).join();

    try {
      return json.decode(responseBody);
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> signAndSend(
    String path,
    Map<String, dynamic> body, [
    int stamp = -1,
  ]) async {
    final calculated = calculateSignature(path, body, stamp);
    final ts = calculated["ts"];
    final signature = calculated["signature"];
    final data = utf8.encode(json.encode(body));
    final options = {
      "method": "POST",
      "hostname": basePath,
      "path": path,
      "headers": {
        "Content-Type": "application/json",
        "Content-Length": data.length.toString(),
        "ZOKSH-KEY": zokshKey,
        "ZOKSH-TS": ts,
        "ZOKSH-SIGN": signature,
      },
      "redirectCount": 0,
    };

    return await doRequest(options, data);
  }
}
