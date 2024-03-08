import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_a_home/ui/screens/auth/login.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Image(
                      image: AssetImage("assets/img/logo.png"),

                    ),
                  ),
                  Text("Smartify Your Living!",
                    style: TextStyle(
                        fontSize: 29,
                        fontStyle: FontStyle.italic
                    ),),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .5,
                width: double.infinity,
                child: const Image(
                  image: AssetImage("assets/img/art.png"),
                ),
              ),
              const SizedBox(height: 10,),
              Text("We've sent you a verification email.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),),
              Text("Please verify your email to sign in.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false);
                  },

                  child: const Text("Done",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
