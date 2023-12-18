import 'package:flutter/material.dart';

class RazorpayPaymentPage extends StatelessWidget {
  const RazorpayPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay Payment Integration'),
      ),
      body: const Center(
        child: Text('This page will handle Razorpay payment integrations.'),
      ),
    );
  }
}
