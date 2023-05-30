# Zoksh Flutter Package

The Zoksh Flutter package provides a set of modules and utilities for integrating with the Zoksh API in your Flutter applications. It offers functionality for handling payments, webhooks, and error codes.

## Features

- **Connector**: Establishes a connection with the Zoksh API using the provided key and secret.
- **ApiResource**: Base class for API resources, encapsulating common functionality for making authenticated requests.
- **Webhook**: Handles incoming webhook requests and verifies their authenticity using the Zoksh signature.
- **Payment**: Provides methods for validating payments and interacting with the Zoksh payment API.
- **ErrorCode**: Defines a set of error codes for handling Zoksh API responses.

## Installation

To use the Zoksh Flutter package in your Flutter project, follow these steps:

1. Open your project's `pubspec.yaml` file.
2. Add `zoksh` as a dependency:

   ```yaml
   dependencies:
     zoksh: ^1.0.0
   ```
3. Run flutter pub get to fetch the package dependencies.

## Usage
Here's an example of how to use the Zoksh Flutter package in your Flutter application:
```dart
import 'package:flutter/material.dart';
import 'package:zoksh/zoksh.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create a Connector instance
    Connector connector = Connector(zokshKey, zokshSecret, sandbox: true);

    // Create an ApiResource instance
    ApiResource apiResource = ApiResource(connector);

    // Create a Payment instance
    Payment payment = Payment(apiResource);

    // Use the Payment instance to validate a transaction
    String transactionHash = 'your_transaction_hash';
    payment.validate(transactionHash).then((result) {
      // Handle the validation result
      print(result);
    }).catchError((error) {
      // Handle the error
      print(error);
    });

    return MaterialApp(
      title: 'Zoksh Flutter Package Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Zoksh Flutter Package Demo'),
        ),
        body: Center(
          child: Text('Hello, Zoksh!'),
        ),
      ),
    );
  }
}

```

For more detailed usage instructions and information on available methods and properties, refer to the package's API documentation.

## Contributing
Contributions to the Zoksh Flutter package are welcome! If you find any issues or have suggestions for improvements, please open an issue on the GitHub repository https://github.com/MuLx10/zoksh-flutter/issues.

## License
This package is licensed under the MIT License. See the LICENSE file for more information.