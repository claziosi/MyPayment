import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:http/http.dart' as http;

class BraintreePaymentPage extends StatefulWidget {
  const BraintreePaymentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BraintreePaymentPageState createState() => _BraintreePaymentPageState();
}

class _BraintreePaymentPageState extends State<BraintreePaymentPage> {
  void showDropIn(String clientToken) async {
    var request = BraintreeDropInRequest(
      tokenizationKey: clientToken,
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: "4.20",
        currencyCode: "USD",
        billingAddressRequired: false,
      ),
      paypalRequest:
          BraintreePayPalRequest(amount: "4.20", displayName: "Your Company"),
    );

    final result = await BraintreeDropIn.start(request);

    if (result != null) {
      if (kDebugMode) {
        print(result.paymentMethodNonce.description);
      }
      // Send nonce to server for processing using result.paymentMethodNonce.nonce.
      processPayment(result.paymentMethodNonce.nonce);
    } else {
      // User cancelled payment
    }
  }

  Future<void> processPayment(String nonce) async {
    final http.Response response = await http.post(
        Uri.parse('http://localhost:3000/checkout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'paymentMethodNonce': nonce, 'amount': '4.20'}));

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Transaction successful");
      }
    } else {
      if (kDebugMode) {
        print("Transaction failed");
      }
    }
  }

  Future<String> getClientToken() async {
    final url = Uri.parse('http://localhost:3000/client_token');
    final response = await http.get(url);
    return json.decode(response.body)['clientToken'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Braintee Payment Integration")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final clientToken = await getClientToken();
            showDropIn(clientToken);
          },
          child: const Text("Pay with BrainTree"),
        ),
      ),
    );
  }
}
