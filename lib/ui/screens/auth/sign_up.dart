import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_a_home/ui/screens/auth/login.dart';
import 'package:rent_a_home/ui/screens/auth/verify_email_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //final myController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nidController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool passwordVisible=false;

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
                      height: MediaQuery
                          .of(context)
                          .size
                          .width * .5,
                      width: double.infinity,
                      child: const Image(
                        image: AssetImage("assets/img/logoo.png"),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintText: "Name",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        } else if (!RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$')
                            .hasMatch(value)) {
                          return 'Name should contain only letters and a single space between names';
                        }
                        return null; // Return null if the input is valid
                      },
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
                        } else if (!RegExp(
                            r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(
                            value)) {
                          return 'Please enter a valid email address';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: nidController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintText: "NID No.",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your NID No.';
                        }
                        else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return 'NID No. must be 10 digits';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10,),
                    // TextFormField(
                    //   controller: locationController,
                    //   decoration: const InputDecoration(
                    //     contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    //     border: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.grey)),
                    //     enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.grey)),
                    //     disabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.grey)),
                    //     hintText: "Location",
                    //   ),
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please enter your location.';
                    //     }
                    //     return null;
                    //   },
                    // ),

                    TextFormField(
                      controller: mobileController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        hintText: "Mobile No.",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number.';
                        } else if (!RegExp(r'^(?:\+8801|01)?\d{9}$').hasMatch(value)) {
                          return 'Phone number must start with +880 and be 13 digits long.';
                        }
                        return null;
                      },
                    ),




                    const SizedBox(height: 10,),
                    TextFormField(
                        controller: passwordController,
                        decoration:const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: "Password",
                          // suffixIcon: IconButton(
                          //   icon: Icon(
                          //     // Conditional icon based on password visibility
                          //     passwordVisible
                          //         ? Icons.visibility
                          //         : Icons.visibility_off,
                          //     color: Colors.grey,
                          //   ),
                          //   onPressed: () {
                          //     // Toggle password visibility
                          //     setState(() {
                          //       passwordVisible = !passwordVisible;
                          //     });
                          //   },
                          // ),
                        ),
                        //obscureText: !passwordVisible,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return 'Password must contain at least one capital letter';
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return 'Password must contain at least one number';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: "Confirm Password",
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
                        validator: (value) {
                          final password = passwordController.text;
                          if (value!.isEmpty) {
                            return 'Please enter your password again';
                          }
                          if (value != password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        }
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              signUp(emailController.text.trim(),
                                  passwordController.text.trim());
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
                          child: const Text("Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Sign in",
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                fontSize: 18,
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



  void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password
        );

        // After successful sign-up, proceed to Firestore data insertion and email verification
        await postDetailsToFirestore(userCredential.user!);
        await sendEmailVerification(userCredential.user!);

        // Show success message or navigate to a different screen
        // Consider giving users more feedback on successful sign-up
        //Fluttertoast.showToast(msg: "Account created successfully.");
        Fluttertoast.showToast(msg: "Account created successfully.");
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => VerifyEmail(),), (
            route) => false);



      } on FirebaseAuthException catch (e) {
        // Handle FirebaseAuth exceptions and show them to the user
        Fluttertoast.showToast(msg: "${e.message}");
      }
    }
  }

  Future<void> postDetailsToFirestore(User user) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Map<String, dynamic> data = {
      "name": nameController.text.trim(),
      "nid": nidController.text.trim(),
      "email": emailController.text.trim(),
      "mobile": mobileController.text.trim(),
      "location": locationController.text.trim(),
    };

    try {
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(data);
    } catch (e) {
      print("Error while saving user details to Firestore: $e");
    }
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      print("Error while sending email verification: $e");
    }
  }















// postDetailsToFireStore() async {
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //
  //   Map<String, dynamic> data = {
  //     "name": emailController.text.trim(),
  //     "nid": nidController.text.trim(),
  //     "email": emailController.text.trim()
  //   };
  //
  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(_auth.currentUser!.uid)
  //       .set(data).then((value) =>
  //   {
  //     Fluttertoast.showToast(msg: "Account created successfully."),
  //     Navigator.pushAndRemoveUntil(
  //         context, MaterialPageRoute(builder: (context) => VerifyEmail(),), (
  //         route) => false)
  //   });
  //
  //   FirebaseAuth.instance.currentUser!.sendEmailVerification();


    // Future<void> sendEmailVerification()async{
    //   try{
    //     await _auth.currentUser?.sendEmailVerification();
    //   }
    //
    // }


// Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(builder: (context) => EmailVerify1()),
//         (route) => false);
  }
//}

