import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_a_home/ui/screens/rent_home_page.dart';

class ShortListPage extends StatefulWidget {
  const ShortListPage({super.key});

  @override
  State<ShortListPage> createState() => _ShortListPageState();
}

class _ShortListPageState extends State<ShortListPage> {

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

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('favourites').where('userId',isEqualTo: userid).snapshots(),
                builder: (context,snapshot) {
                  if(snapshot.hasData){
                    final ads = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          mainAxisExtent: 220,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16),
                      itemCount: ads.size,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RentHomePage(adId: ads.docs[index]['adId']),
                                ));
                          },
                          child: Padding(
                            padding:
                            const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                            child: Material(
                              elevation: 10,
                              shadowColor: Colors.deepPurple,
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                      130, // Check if this height is suitable
                                      child: ClipRRect(
                                        child: Image.network(ads.docs[index]['img'], fit: BoxFit.fill),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.home,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              "${ads.docs[index]['category']}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${ads.docs[index]['rent']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Icon(
                                        //       Icons.location_on_sharp,
                                        //       color: Colors.red,
                                        //     ),
                                        //     Text("${ads.docs[index]['location']}"),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  else if(snapshot.hasError){
                    return Center(child: Text("Something went wrong"),);
                  }
                  else{
                    return Center(child: Text("Empty List"),);
                  }


                }
            ),
          ],
        ),
      ),
    );
  }
}
