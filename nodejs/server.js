const express = require('express');
const bodyParser = require('body-parser');
const braintree = require('braintree');
require('dotenv').config();

// Load environment variables from .env file
const PORT = process.env.PORT || 3000;
const BRAINTREE_MERCHANT_ID = process.env.BRAINTREE_MERCHANT_ID;
const BRAINTREE_PUBLIC_KEY = process.env.BRAINTREE_PUBLIC_KEY;
const BRAINTREE_PRIVATE_KEY = process.env.BRAINTREE_PRIVATE_KEY;

const cors = require('cors');

// Initialize Braintree gateway
const gateway = new braintree.BraintreeGateway({
  environment: braintree.Environment.Sandbox, // Or Production when you're ready to go live
  merchantId: BRAINTREE_MERCHANT_ID,
  publicKey: BRAINTREE_PUBLIC_KEY,
  privateKey: BRAINTREE_PRIVATE_KEY,
});

// Initialize Express app
const app = express();

// Configure CORS for localhost origin
app.use(cors({
    origin: 'http://localhost:60923', // Allow only this origin to make requests.
    methods: ['GET', 'POST'], // Allowable methods.
  }));

// Use body-parser middleware to parse JSON bodies
app.use(bodyParser.json());

// Endpoint to generate a client token for the frontend
app.get('/client_token', (req, res) => {
  console.log("Client Token Call...");
  gateway.clientToken.generate({}, (err, response) => {
    if (err) {
      console.error(`Error generating client token: ${err}`);
      res.status(500).send(err);
    } else {
      res.send({ clientToken: response.clientToken });
    }
  });
});

// Endpoint to process payments from the frontend
app.post('/checkout', (req, res) => {
  const nonceFromClient = req.body.paymentMethodNonce;
  const amountFromClient = req.body.amount;

  // Use transaction.sale() method to submit for settlement immediately.
  gateway.transaction.sale({
    amount: amountFromClient,
    paymentMethodNonce: nonceFromClient,
    options: { submitForSettlement: true },
  }, (err, result) => {
    if (result.success || result.transaction) {
      res.json({ success: true, transactionId: result.transaction.id });
    } else {
      console.error(`Error processing transaction: ${err}`);
      res.status(500).json({ error: err });
    }
  });
});

// Start the server on the specified port
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});