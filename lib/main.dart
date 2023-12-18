import 'package:flutter/material.dart';
import 'native_payment_page.dart'; // Import NativePaymentPage
import 'braintree_payment_page.dart'; // Import BraintreePaymentPage
import 'razorpay_payment_page.dart';
import 'stripe_payment_page.dart'; // Import StripePaymentPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PaymentHomePage(),
    );
  }
}

class PaymentHomePage extends StatefulWidget {
  const PaymentHomePage({super.key});

  @override
  _PaymentHomePageState createState() => _PaymentHomePageState();
}

class _PaymentHomePageState extends State<PaymentHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const NativePaymentPage(), // Use Native Payment Page widget
    const BraintreePaymentPage(), // Use Braintree Payment Page widget
    const StripePaymentPage(), // Use Stripe Payment Page widget
    const RazorpayPaymentPage(), // Use Razorpay Payment Page widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment App'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Native',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Braintree',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Stripe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Razorpay',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
