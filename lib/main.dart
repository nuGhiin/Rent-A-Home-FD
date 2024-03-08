import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rent_a_home/ui/screens/auth/check_if_logged_in.dart';
import 'package:rent_a_home/ui/screens/auth/login.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart' show Stripe;

Future<void> main() async {

WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
Stripe.publishableKey =
'pk_test_51Onn6mHuwzwthZmWmdY0fbHizlDPvXcOZ5TEEqOLNWiRs1OaQGe084CKPUFUZCWPv4aOghfwLUYtTxWDtmsbsip30098bpa9z5';



  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckIfLoggedIn(),
    );
  }
}
