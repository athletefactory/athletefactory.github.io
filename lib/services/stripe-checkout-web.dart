@JS()
library stripe;
import 'package:flutter/material.dart';
import 'package:js/js.dart';

import '../main.dart';

String localHttp = 'http';
String testingEnvHttp = 'https';
String localHost = 'localhost:49430';
String testingEnv = 'aegdy.github.io';

void redirectToCheckout(BuildContext _, String stripeKey, String priceKey) async {
  final stripe = Stripe(stripeKey);
  stripe.redirectToCheckout(CheckoutOptions(
    lineItems: [
      LineItem(price: priceKey, quantity: 1),
    ],
    mode: 'payment',
    successUrl: '${isTesting?localHttp:'https'}://${isTesting?localHost:'athfactory.io'}/#/payment-complete',
    cancelUrl: '${isTesting?localHttp:'https'}://${isTesting?localHost:'athfactory.io'}/#/cancel',
  ));
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}