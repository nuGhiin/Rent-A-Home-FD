import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class RentHomePage extends StatefulWidget {
  final String adId;
  const RentHomePage({super.key, required this.adId});

  @override
  State<RentHomePage> createState() => _RentHomePageState();
}

class _RentHomePageState extends State<RentHomePage> {


  bool isFavourite = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addOrRemoveFavourite() async {
    User? user = _auth.currentUser;
    CollectionReference collection = FirebaseFirestore.instance.collection('favourites');
    QuerySnapshot querySnapshot = await collection.where('adId', isEqualTo: widget.adId.toString().trim()).where('userId',isEqualTo: user!.uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      isFavourite = false;
      setState(() {});
      QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      print(documentSnapshot.id);
      FirebaseFirestore.instance
          .collection("favourites")
          .doc(documentSnapshot.id)
          .delete()
          .then((value) {
        print("Document successfully deleted!");
      }).catchError((error) {
        print("Error removing document: $error");
      });
    } else {
      print('Document does not exist');
      isFavourite = true;
      setState(() {});
      CollectionReference col = FirebaseFirestore.instance.collection('ads');
      DocumentSnapshot documentSnapshot = await col.doc(widget.adId.toString().trim()).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      if(data.isNotEmpty){
        await _firestore.collection('favourites').add({
          'adId': widget.adId.toString().trim(),
          'userId': user.uid,
          'img' : data['images'][0],
          'category' : '${data['category']}',
          'rent' : "${data['rent']}"
        });
      }

    }
  }

  Future<void> isfavouriteAd() async {

    User? user = _auth.currentUser;
    CollectionReference collection = FirebaseFirestore.instance.collection('favourites');
    QuerySnapshot querySnapshot = await collection.where('adId', isEqualTo: widget.adId.toString().trim()).where('userId',isEqualTo: user!.uid).get();

    if (querySnapshot.docs.isNotEmpty) {
      isFavourite = true;
      setState(() {});
    } else {
      isFavourite = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    isfavouriteAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: IconButton(
              icon: isFavourite ? const Icon(
                Icons.favorite,
                color: Colors.redAccent,
              ) : const Icon(
                Icons.favorite_border,
                color: Colors.redAccent,
              ),
              onPressed: () {
                addOrRemoveFavourite();
              },
            ),
          ),
        ],
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('ads')
              .doc(widget.adId.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final adsInfo = snapshot.data!;
              // print(adsInfo['images']);
              // var imageCount = adsInfo['images'];
              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  '${adsInfo['title']}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    SizedBox(width: 3), // Adjust spacing if needed
                                    Text('${adsInfo['address']}', style: const TextStyle(fontSize: 18, ),),
                                  ],
                                ),
                              ),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 3 / 2,
                                ),
                                itemCount: 4,
                                itemBuilder: (context, index) {
                                  // return Image.network(
                                  //     adsInfo['images'][index]);
                                  return InstaImageViewer(
                                    child: Image(
                                      image: Image.network(
                                          "${adsInfo['images'][index]}")
                                          .image,
                                    ),
                                  );
                                  //Image(
                                  //       image: AssetImage("assets/img/1.jpg"));
                                },
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Apartment owned by",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),

                                    ),
                                    SizedBox(width: 5),
                                    Text("${adsInfo['ownerName']}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Wrap(
                                spacing: 20,
                                runSpacing: 6,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runAlignment: WrapAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(
                                        8), // Optional padding for some space around the text
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      '${adsInfo['bedroom']} Bedrooms',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(
                                        8), // Optional padding for some space around the text
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      '${adsInfo['kiitchen']} Kitchen & Dining',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(
                                        8), // Optional padding for some space around the text
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      '${adsInfo['washroom']} Washrooms',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(
                                        8), // Optional padding for some space around the text
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      '${adsInfo['baalcony']} Balcony',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Description",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  '${adsInfo['description']}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Rent/Month : ${adsInfo['rent']} BDT",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      'Advanced Deposite : ${adsInfo['advanceDeposite']} BDT',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                              // const Padding(
                              //   padding: EdgeInsets.all(8.0),
                              //   child: Text(
                              //     "★Pay the service charge & Secure an appointment with owner",
                              //     maxLines: 3,
                              //     textAlign: TextAlign.left,
                              //     style: TextStyle(
                              //       color: Colors.red,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                elevation: 0,
                                side: const BorderSide(
                                    width: 1, color: Colors.red),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14))),
                            onPressed: () {
                              _makePhoneCall('${adsInfo['ownerPhone']}');
                            },
                            child: const Text(
                              "Call The Owner",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
