import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:rent_a_home/ui/widgets/picker.dart';
import 'package:http/http.dart' as http; // Import http package
import 'package:flutter_stripe/flutter_stripe.dart';


class PostAdPage extends StatefulWidget {
  const PostAdPage({super.key});

  @override
  State<PostAdPage> createState() => _PostAdPageState();
}

class _PostAdPageState extends State<PostAdPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  String adTitle = '';
  String _address='';
  String adCategory = '';
  String adDescription = '';
  String adRent = '';
  String advanceDeposite='';
  String bedrooms='';
  String washrooms='';
  String kitchen='';
  String balcony='';

  List<ImageFile> imgList=[];
  List<String> imageUrls = [];


  String bgValue = "Null";
  final List<String> _items1 = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  final List<String> _items2 = [
    'Bachelor',
    'Family',
    'Bachelor/Family',
  ];

  final controller = MultiImagePickerController(
      maxImages: 5,
      picker: (allowMultiple) async {
        return await pickImagesUsingImagePicker(allowMultiple);
      });
  Future<void> upload() async {
    isLoading = true;
    setState(() {});

    try{
      User? user = _auth.currentUser;
      if (user != null){

        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(user.uid).get();

        if (controller.images.isNotEmpty) {
          imgList = controller.images.toList();
          for(int i = 0;i < imgList.length;i++){
            String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages =
            referenceRoot.child('ad_images');

            // Create a reference for the image to be stored
            Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName);

            // Store the file
            await referenceImageToUpload.putFile(File(imgList[i].path!));

            // Success: get the download URL
            String imageUrl =
            await referenceImageToUpload.getDownloadURL();
            imageUrls.add(imageUrl);

          }//for loop
          await _firestore.collection('pendingAds').add({
            'address': _address,
            'title': adTitle,
            'category': adCategory,
            'bedroom': bedrooms,
            'washroom': washrooms,
            'kiitchen': kitchen,
            'baalcony': balcony,
            'rent': adRent,
            'advanceDeposite': advanceDeposite,
            'description': adDescription,
            'images': imageUrls,
            'userId': user.uid,
            'ownerName': snapshot['name'],
            'ownerPhone': snapshot['mobile'],
            'status' : 'pending',
            'timestamp': FieldValue.serverTimestamp(),
          });
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: "Ad Uploaded for Review");
          Navigator.pop(context);
        }
      }
    }
    catch(error){
      isLoading = false;
      setState(() {});
      log('Error uploading ad: $error');
      Fluttertoast.showToast(msg: 'Error uploading ad. Please try again later.');
    }
  }
  TextEditingController adTitleTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController categoryTEC = TextEditingController();
  TextEditingController bedroomTEC = TextEditingController();
  TextEditingController kdTEC = TextEditingController();
  TextEditingController balconyTEC = TextEditingController();
  TextEditingController washroomTEC = TextEditingController();
  TextEditingController rentTEC = TextEditingController();
  TextEditingController advanceDepoTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  ///--------Payment Controller--------///
  Map<String, dynamic>? paymentIntent;

  void makePayment() async{
    try{
      paymentIntent = await createPaymentIntent();

      var gpay=const PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "US",
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.dark,
        merchantDisplayName: "Tanjid Tonmoy",
        googlePay: gpay,
      ));
      displayPaymentSheet();
    }catch(e){}
  }

  Future<void> displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet().then((value) => {
      upload(),
    });
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
        "amount": "10000",
        "currency": "BDT",
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
  ///--------end of payment controlling--------///



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Post an ad",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Visibility(
        visible: isLoading == false,
        replacement: const Center(child: CircularProgressIndicator(),),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Upload Pictures of your home (max 5)"),
                  const SizedBox(
                    height: 10,
                  ),
                  MultiImagePickerView(
                    controller: controller,
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      labelText: "Ad Title",
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Select Group';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        adTitle = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      labelText: "Address",
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Select Group';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        _address = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Select Group';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (String? val) {
                      setState(() {
                        bgValue = val!;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    onTap: () {
                      setState(() {});
                    },
                    hint: const Text("Select Category"),
                    items: _items2.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                        onTap: (){
                          setState(() {
                            adCategory=item;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Bedrooms';
                              } else {
                                return null;
                              }
                            },

                            onChanged: (String? val) {
                              setState(() {
                                bgValue = val!;
                              });
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            onTap: () {
                              setState(() {});
                            },
                            hint: const Text("Bedroom"),
                            items: _items1.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                                onTap: (){
                                  setState(() {
                                    bedrooms=item;
                                  });
                                },
                              );

                            }).toList(),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'kitchen';
                              } else {
                                return null;
                              }
                            },

                            onChanged: (String? val) {
                              setState(() {
                                bgValue = val!;
                              });
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            onTap: () {
                              setState(() {});
                            },
                            hint: const Text("Kitchen & Dining"),
                            items: _items1.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                                onTap: (){
                                  setState(() {
                                    kitchen=item;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Balcony';
                              } else {
                                return null;
                              }
                            },

                            onChanged: (String? val) {
                              setState(() {
                                bgValue = val!;
                              });
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            onTap: () {
                              setState(() {});
                            },
                            hint: const Text("Balcony"),
                            items: _items1.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                                onTap: (){
                                  setState(() {
                                    balcony=item;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: DropdownButtonFormField(
                            validator: (value) =>
                            value == null ? 'Washroom' : null,
                            onChanged: (String? val) {
                              setState(() {
                                bgValue = val!;
                              });
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            onTap: () {
                              setState(() {});
                            },
                            hint: const Text("Washroom"),
                            items: _items1.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                                onTap: (){
                                  setState(() {
                                    washrooms=item;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        labelText: "Rent per month"
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Select Group';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value){
                      setState(() {
                        adRent=value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        labelText: "Advance Deposits"
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Select Group';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value){
                      setState(() {
                        advanceDeposite=value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        labelText: "Ad Description"
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Select Group';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        adDescription=value;
                      });
                    },
                    maxLines: 8,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          makePayment();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Next", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

