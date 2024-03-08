import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  late String _email;
  late String _mobileNumber;
  late String _nid;
  late String _location;

  late File _image;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _image = File(''); // Initialize with an empty file
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
        // Update user profile in Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'name': _name,
          'email': _email,
          'mobile': _mobileNumber,
          'nid': _nid,
          'location': _location,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
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
              // Add other form fields for email, mobile, nid, and location here

              ElevatedButton(
                onPressed: () {
                  _getImage();
                },
                child: const Text('Select Profile Picture'),
              ),
              if (_image.path.isNotEmpty)
                Image.file(_image)
              else
                Icon(Icons.person, size: 100), // Default icon if no image

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
