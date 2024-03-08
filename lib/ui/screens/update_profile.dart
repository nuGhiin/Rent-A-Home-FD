import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  late String _name;
  late String _email = '';
  late String _mobileNumber = '';
  late String _nid = '';
  late String _location = '';

  late File _profilePic;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _profilePic = File('');
  }

  void fetchUserData() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        setState(() {
          _name = snapshot['name'];
          _email = snapshot['email'];
          _mobileNumber = snapshot['mobile'];
          _nid = snapshot['nid'];
          _location = snapshot['location'];
        });
      }
    }
  }

  Future<void> updateUserProfile() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      if (_formKey.currentState!.validate()) {
        // Upload profile picture and get the URL
        String profilePicUrl = await uploadProfilePicture(_profilePic);

        // Update user profile in Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'name': _name,
          'email': _email,
          'mobile': _mobileNumber,
          'nid': _nid,
          'location': _location,
          'profilePicUrl': profilePicUrl, // Save profile picture URL
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.of(context).pop(); // Close the current page
      }
    }
  }

  Future<String> uploadProfilePicture(File profilePic) async {
    try {
      // Reference to the Firebase Storage bucket
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(_auth.currentUser!.uid);

      // Upload the profile picture to Firebase Storage
      UploadTask uploadTask = ref.putFile(profilePic);

      // Await the completion of the upload task
      await uploadTask.whenComplete(() => null);

      // Get the download URL of the uploaded file
      String downloadUrl = await ref.getDownloadURL();

      return downloadUrl; // Return the download URL
    } catch (e) {
      print('Error uploading profile picture: $e');
      return ''; // Return an empty string in case of error
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profilePic = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  _getImage();
                },
                child: const Text('Select Profile Picture'),
              ),
              if (_profilePic.path.isNotEmpty)
                Image.file(_profilePic)
              else
                Icon(Icons.person, size: 100), // Default icon if no image
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  // You can add email validation logic here
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _mobileNumber,
                decoration:
                const InputDecoration(labelText: 'Mobile Number'),
                validator: (value) {
                  // You can add mobile number validation logic here
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _mobileNumber = value;
                  });
                },
              ),
              // Add other form fields for nid and location here
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updateUserProfile();
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
