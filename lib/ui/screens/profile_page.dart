// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rent_a_home/ui/screens/auth/login.dart';
// import 'package:rent_a_home/ui/screens/my_ads_page.dart';
// import 'package:rent_a_home/ui/screens/update_profile.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   late String _name = '';
//   late String _email = '';
//   late String _mobileNumber = '';
//   late String _nid = '';
//   late String _location = '';
//   late File _profilePicUrl ='';
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }
//
//   void fetchUserData() async {
//     final User? user = _auth.currentUser;
//
//     if (user != null) {
//       final DocumentSnapshot<Map<String, dynamic>> snapshot =
//       await _firestore.collection('users').doc(user.uid).get();
//
//       if (snapshot.exists) {
//         setState(() {
//           _name = snapshot['name'];
//           _email = snapshot['email'];
//           _mobileNumber = snapshot['mobile'];
//           _nid = snapshot['nid'];
//           _location = snapshot['location'];
//           _profilePicUrl = snapshot['profilePicUrl'];
//           _isLoading = false; // Data fetched, set loading to false
//         });
//       }
//     }
//   }
//
//   void signUserOut() {
//     _auth.signOut();
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//             (route) => false);
//   }
//
//   // Future<void> _getImage() async {
//   //   final pickedFile =
//   //   await ImagePicker().pickImage(source: ImageSource.gallery);
//   //
//   //   setState(() {
//   //     if (pickedFile != null) {
//   //       _profilePic = File(pickedFile.path);
//   //     }
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
//           : SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               Center(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 100,
//                       child: CircleAvatar(
//                         backgroundImage: _profilePicUrl.isNotEmpty
//                             ? NetworkImage(_profilePicUrl) // Load profile picture from URL
//                             : null, // No profile picture available
//                         child: _profilePicUrl.isEmpty
//                             ? IconButton(
//                           onPressed: _getImage,
//                           icon: const Icon(Icons.person, size: 100),
//                         )
//                             : null, // If profile picture is available, don't show IconButton
//                       ),
//                       ),
//                     ),
//                     const SizedBox(height: 10,),
//                     Text(
//                       '$_name',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Text("Active Since 2019"),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EditProfilePage(),
//                     ),
//                   );
//                 },
//                 child: const Padding(
//                   padding: EdgeInsets.only(
//                       top: 8.0, left: 8, right: 10, bottom: 4),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Personal Information"),
//                       Text("Edit")
//                     ],
//                   ),
//                 ),
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   leading: const Icon(Icons.email_outlined),
//                   title: const Text("Email"),
//                   trailing: Text(
//                     '$_email',
//                     style: const TextStyle(
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   leading: const Icon(Icons.phone_android_outlined),
//                   title: const Text("Mobile"),
//                   trailing: Text(
//                     '$_mobileNumber',
//                     style: const TextStyle(
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   leading: const Icon(Icons.document_scanner_outlined),
//                   title: const Text("NID"),
//                   trailing: Text(
//                     '$_nid',
//                     style: const TextStyle(
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   leading: const Icon(Icons.location_on_outlined),
//                   title: const Text("Location"),
//                   trailing: Text(
//                     '$_location',
//                     style: const TextStyle(
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MyAds(),
//                       ),
//                     );
//                   },
//                   leading: const Icon(Icons.ads_click),
//                   title: const Text("My Ads"),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   onTap: () {
//                     signUserOut();
//                   },
//                   leading: const Icon(Icons.logout_sharp),
//                   title: const Text("Sign Out"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }








// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rent_a_home/ui/screens/auth/login.dart';
// import 'package:rent_a_home/ui/screens/auth/signup/update_profile.dart';
// import 'dart:io';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late File? _image; // Define _image as nullable File type
//
//   late String _name;
//   late String _email;
//   late String _mobileNumber;
//   late String _nid;
//   late String _location;
//   late String _imageUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//     _image = File('');
//   }
//
//   void fetchUserData() async {
//     final User? user = _auth.currentUser;
//
//     if (user != null) {
//       final DocumentSnapshot<Map<String, dynamic>> snapshot =
//       await _firestore.collection('users').doc(user.uid).get();
//
//       if (snapshot.exists) {
//         setState(() {
//           _name = snapshot['name'];
//           _email = snapshot['email'];
//           _mobileNumber = snapshot['mobile'];
//           _nid = snapshot['nid'];
//           _location = snapshot['location'];
//           _imageUrl = snapshot['profile_picture'] ?? '';
//         });
//       }
//     }
//   }
//
//   void signUserOut() {
//     _auth.signOut();
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//             (route) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               Center(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 100,
//                       child: CircleAvatar(
//                         radius: 100,
//                         child: _image != null
//                             ? Image.file(_image!)
//                             : (_imageUrl.isNotEmpty
//                             ? Image.network(_imageUrl)
//                             : Icon(
//                           Icons.person,
//                           size: 100,
//                         )),
//                       ),
//                     ),
//                     SizedBox(height: 10,),
//                     Text('$_name', style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),),
//                     Text("Active Since 2019"),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//
//               InkWell(
//                 onTap: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfilePage(),));
//                 },
//                 child: const Padding(
//                   padding: EdgeInsets.only(top: 8.0,left: 8,right: 10,bottom: 4),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Personal Information"),
//                       Text("Edit")
//                     ],
//                   ),
//                 ),
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   leading: Icon(Icons.email_outlined),
//                   title: Text("Email"),
//                   trailing: Text('$_email', style: TextStyle(
//                     fontSize: 15,
//                   ),),
//                 ),
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   leading: Icon(Icons.phone_android_outlined),
//                   title: Text("Mobile"),
//                   trailing: Text('$_mobileNumber', style: TextStyle(
//                     fontSize: 15,
//                   ),),
//                 ),
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   leading: Icon(Icons.document_scanner_outlined),
//                   title: Text("NID"),
//                   trailing: Text('$_nid', style: TextStyle(
//                     fontSize: 15,
//                   ),),
//                 ),
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   leading: Icon(Icons.location_on_outlined),
//                   title: Text("Location"),
//                   trailing: Text('$_location', style: TextStyle(
//                     fontSize: 15,
//                   ),),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Card(
//                 color: Colors.white60,
//                 elevation: .1,
//                 child: ListTile(
//                   onTap: (){
//                     signUserOut();
//                   },
//                   leading: const Icon(Icons.logout_sharp),
//                   title: const Text("Sign Out"),
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_a_home/ui/screens/auth/login.dart';
import 'package:rent_a_home/ui/screens/my_ads_page.dart';
import 'package:rent_a_home/ui/screens/update_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _name = '';
  late String _email = '';
  late String _mobileNumber = '';
  late String _nid = '';
  late String _location = '';
  late String _profilePicUrl = ''; // Added profile picture URL
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // void fetchUserData() async {
  //   final User? user = _auth.currentUser;
  //
  //   if (user != null) {
  //     final DocumentSnapshot<Map<String, dynamic>> snapshot =
  //     await _firestore.collection('users').doc(user.uid).get();
  //
  //     if (snapshot.exists) {
  //       setState(() {
  //         _name = snapshot['name'];
  //         _email = snapshot['email'];
  //         _mobileNumber = snapshot['mobile'];
  //         _nid = snapshot['nid'];
  //         _location = snapshot['location'];
  //         _profilePicUrl = snapshot['profilePicUrl']; // Retrieve profile picture URL
  //         _isLoading = false; // Data fetched, set loading to false
  //       });
  //     }
  //   }
  // }


  void fetchUserData() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      try {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          setState(() {
            _name = snapshot['name'];
            _email = snapshot['email'];
            _mobileNumber = snapshot['mobile'];
            _nid = snapshot['nid'];
            _location = snapshot['location'];
            _profilePicUrl = snapshot['profilePicUrl']; // Retrieve profile picture URL
            _isLoading = false; // Data fetched, set loading to false
          });
        } else {
          setState(() {
            _isLoading = false; // Data doesn't exist, set loading to false
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
        setState(() {
          _isLoading = false; // Error occurred, set loading to false
        });
      }
    }
  }


  void signUserOut() {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
  }

  Future<void> _getImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        // Handle image selection
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child:
                      //CircleAvatar(
                      //   radius: 50,
                      //   backgroundImage: _profilePicUrl.isNotEmpty
                      //       ? NetworkImage(_profilePicUrl)
                      //       : null, // Set backgroundImage to null if _profilePicUrl is empty
                      //   child: _profilePicUrl.isEmpty
                      //       ? IconButton(
                      //     onPressed: (){},
                      //     icon: Icon(Icons.person, size: 40),
                      //   )
                      //       : null, // Set child to null if _profilePicUrl is not empty
                      // ),

                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profilePicUrl.isNotEmpty
                            ? NetworkImage(_profilePicUrl)
                            : AssetImage('assets/img/add_button.png') as ImageProvider<Object>,
                        child:_profilePicUrl.isEmpty
                            ? IconButton(
                          onPressed: _getImage,
                          icon: Icon(Icons.person, size: 40),
                        )
                            : null,
                      ),

                    ),
                    const SizedBox(height: 10,),
                    Text(
                      '$_name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("Active Since 2019"),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                      top: 8.0, left: 8, right: 10, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Personal Information"),
                      Text("Edit")
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white60,
                elevation: .1,
                child: ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text("Email"),
                  trailing: Text(
                    '$_email',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.white60,
                elevation: .1,
                child: ListTile(
                  leading: const Icon(Icons.phone_android_outlined),
                  title: const Text("Mobile"),
                  trailing: Text(
                    '$_mobileNumber',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.white60,
                elevation: .1,
                child: ListTile(
                  leading: const Icon(Icons.document_scanner_outlined),
                  title: const Text("NID"),
                  trailing: Text(
                    '$_nid',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.white60,
                elevation: .1,
                child: ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text("Location"),
                  trailing: Text(
                    '$_location',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.white60,
                elevation: .1,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAds(),
                      ),
                    );
                  },
                  leading: const Icon(Icons.ads_click),
                  title: const Text("My Ads"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.white60,
                elevation: .1,
                child: ListTile(
                  onTap: () {
                    signUserOut();
                  },
                  leading: const Icon(Icons.logout_sharp),
                  title: const Text("Sign Out"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
