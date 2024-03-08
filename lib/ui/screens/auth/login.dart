import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_a_home/ui/screens/auth/forgot_password_screen.dart';
import 'package:rent_a_home/ui/screens/auth/sign_up.dart';
import 'package:rent_a_home/ui/screens/base_nav_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController =TextEditingController();
  TextEditingController passwordController=TextEditingController();

  bool signInProgress = false;
  bool passwordVisible=false;

  void signUserIn() async {
    if (_formkey.currentState!.validate()) {
      signInProgress = true;
      setState(() {});
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ).then((value) => {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BaseNavPage(),), (route) => false)
        });
        signInProgress = false;
        setState(() {});
      } on FirebaseAuthException {
        signInProgress = false;
        wrongInfoMessage();
        setState(() {});
      }
    }
  }

  void wrongInfoMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Wrong Credentials!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              fontSize: 32,
                              fontStyle: FontStyle.italic
                          ),),
                      ],
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.width * .5,
                      width: double.infinity,
                      child: const Image(
                        image: AssetImage("assets/img/logoo.png"),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintText: "Email",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an email address';
                        } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null; // Return null if the input is valid
                      },

                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                        controller: passwordController,
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: "Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Conditional icon based on password visibility
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              // Toggle password visibility
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: passwordVisible,
                        validator: (value){
                          if(value==null){
                            return 'Please enter your password';
                          }
                          if(value.length <8){
                            return 'Password must be at least 8 characters';
                          }
                          if(!value.contains(RegExp(r'[A-Z]'))){
                            return 'Password must contain at least one capital letter';
                          }
                          if(!value.contains(RegExp(r'[0-9]'))){
                            return 'Password must contain at least one number';
                          }
                          return null;
                        }
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Navigator.pushAndRemoveUntil(
                            //     context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen(),), (
                            //     route) => false);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen(),));
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                          ),
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if(_formkey.currentState!.validate()){
                              signUserIn();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ) ,)
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("New Here?", style: TextStyle(fontSize: 15,),),
                        TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),));
                            },
                            child: const Text("Sign Up",
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
