import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  bool inProgress = false;

  Future<void> resetPassword({required String email}) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        inProgress = true;
      });
      try {
        await auth.sendPasswordResetEmail(email: email);
        setState(() {
          inProgress = false;
        });
        checkYourEmail();
      } catch (e) {
        setState(() {
          inProgress = false;
        });
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  void checkYourEmail() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'We have emailed you a link to reset your password!',
              style: TextStyle(color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),

            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(25, 10, 150, 47),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Flexible(
                child: Row(
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * .5,
                width: double.infinity,
                child: const Image(
                  image: AssetImage("assets/img/art.png"),
                ),
              ),
             // const SizedBox(height: 10,),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: "Email",
                  ),
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Please enter your email';
                    }
                  },
                ),
              ),
             const SizedBox(height: 25,),
             ElevatedButton(onPressed: (){
               resetPassword(email: _emailController.text);
             },
                 child: const Text('Reset Password')),
            ],
          ),
        ),
      ),
    );
  }
}
