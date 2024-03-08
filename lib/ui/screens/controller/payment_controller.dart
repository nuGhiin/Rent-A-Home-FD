// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as https;
// import 'dart:convert';
//
// class PaymentController {
//   Map<String, dynamic>? paymentIntentData;
//
//
//   Future<void> makePayment(
//       {required String amount, required String currency}) async {
//     try {
//       paymentIntentData = await createPaymentIntent(amount, currency);
//       if (paymentIntentData != null) {
//         await Stripe.instance.initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//               applePay: true,
//               googlePay: true,
//               testEnv: true,
//               merchantCountryCode: 'US',
//               merchantDisplayName: 'Prospects',
//               customerId: paymentIntentData!['client_secret'],
//               customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
//             ));
//         displayPaymentSheet();
//       }
//     } catch (e, s) {
//       print('exception:$e$s');
//     }
//   }
//
//   displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//       print('payment Successful');
//     } on Exception catch (e) {
//       if (e is StripeException) {
//         print("Error from Strip: ${e.error.localizedMessage}");
//       }
//       else {
//         print("Unforeseen error: ${e}");
//       }
//     } catch (e) {
//       print("exception:$e");
//     }
//   }
//
//   createPaymentIntent(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//         'payment_method_types[]': 'card',
//       };
//       var response = await https.post(
//           Uri.parse('https://api.stripe.com/v1/payment_intents'),
//           body: body,
//           headers: {
//             'Authorization':
//             'sk_test_51Onn6mHuwzwthZmWxJp5laTinVQsYGtrn6FJq2Cf1Vp3YTdcsZxTHnZIUxOruEdCkHFToFOBkWnNGKS8FGLQkwg500hC7vnrWt'
//           });
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//   }
//
//   calculateAmount(String amount) {
//     final a = (int.parse(amount)) = 100;
//     return a.toString();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rent_a_home/ui/screens/post_ad.dart';



class PaymentController {
  Map<String, dynamic>? paymentIntent;


  //get postAdPage => null;

 void makePayment() async{
    try{
      paymentIntent = await createPaymentIntent();

      var gpay=PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "US",
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.dark,
        merchantDisplayName: "TanjidTonmoy",
        googlePay: gpay,
      ));
      displayPaymentSheet();
    }catch(e){}
  }

  Future<void> displayPaymentSheet() async {
    PostAdPage postAdPage = PostAdPage();
    try{
      await Stripe.instance.presentPaymentSheet();
      print("Done");
    } catch(e){
      print("Failed");
    }
  }

 createPaymentIntent() async{
    try{
      Map<String,dynamic> body={
        "amount": "1000",
        "currency": "USD",
      };
      http.Response response= await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization": "Bearer sk_test_51Onn6mHuwzwthZmWxJp5laTinVQsYGtrn6FJq2Cf1Vp3YTdcsZxTHnZIUxOruEdCkHFToFOBkWnNGKS8FGLQkwg500hC7vnrWt",
            "Content-Type": "application/x-www-form-urlencoded",
          });

      return json.decode(response.body);


    }catch(e){
      throw Exception(e.toString());
    }
  }



}




















//  makePayment() async {
//   try {
//     paymentIntent = await createPaymentIntent();
//
//     var gpay = PaymentSheetGooglePay(
//       merchantCountryCode: "US",
//       currencyCode: "US",
//       testEnv: true,
//     );
//     await Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: paymentIntent!["client_secret"],
//         style: ThemeMode.dark,
//         merchantDisplayName: "TanjidTonmoy",
//         googlePay: gpay,
//       ),
//     );
//     await displayPaymentSheet();
//
//     // Payment process completed successfully
//     return true;
//   } catch (e) {
//     // Handle any errors during payment process
//     print("Error during payment process: $e");
//     return false;
//   }
// }




