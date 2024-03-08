import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_a_home/ui/screens/rent_home_page.dart';

class MyAds extends StatefulWidget {
  const MyAds({super.key});

  @override
  State<MyAds> createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userid = '';
  void fetchUserData() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        userid = user.uid;
      });
    }
  }

  Future<void> deleteAd(String adId) async {
    print(adId);
    setState(() {});
    FirebaseFirestore.instance
        .collection("ads")
        .doc(adId)
        .delete()
        .then((value) {
      setState(() {});
      print("Document successfully deleted!");
    }).catchError((error) {
      setState(() {});
      print("Error removing document: $error");
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ads"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('ads')
              .where('userId', isEqualTo: userid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final ads = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: ads.size,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RentHomePage(
                                            adId: ads.docs[index]['adId']),
                                      ));
                                },
                                leading: SizedBox(
                                  height: 130, // Check if this height is suitable
                                  child: ClipRRect(
                                    child: Image.network(
                                        ads.docs[index]['images'][0],
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                title: Text(
                                  "${ads.docs[index]['category']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                ),
                                subtitle: Text(
                                  "${ads.docs[index]['rent']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    deleteAd(ads.docs[index].id);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong"),
              );
            } else {
              return Center(
                child: Text("Empty List"),
              );
            }
          }),
    );
  }
}
