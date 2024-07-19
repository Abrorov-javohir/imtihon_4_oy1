import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtihon_4_oy1/screens/home_page.dart';
import 'dart:io';

import 'package:imtihon_4_oy1/screens/login_screen.dart';
import 'package:imtihon_4_oy1/screens/my_events_screen.dart';
import 'package:imtihon_4_oy1/screens/profile_Screen.dart';
import 'package:imtihon_4_oy1/services/auth_firebase.dart';
import 'package:imtihon_4_oy1/widgets/change_language.dart';
import 'package:imtihon_4_oy1/widgets/change_theme.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  User? user;
  File? _image;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${user!.uid}.jpg');
      await storageRef.putFile(image);
      final downloadUrl = await storageRef.getDownloadURL();

      await user!.updatePhotoURL(downloadUrl);
      setState(() {});
    } catch (e) {
      print('Failed to upload image: $e');
    }
  }

  void _showPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text("Camera"),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            accountName: Text(user?.displayName ?? ""),
            accountEmail: Text(user?.email ?? "No Email"),
            currentAccountPicture: InkWell(
              onTap: () => _showPickerDialog(context),
              child: CircleAvatar(
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : AssetImage("assets/logo_imtihon.png") as ImageProvider,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('Menu'.tr()),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.ticket),
            title: Text('My events'.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MyEventsScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.person),
            title: Text('Profile Information'.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProfileScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text('Change Language'.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChangeLanguageScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.nights_stay_outlined),
            title: Text('Light mode and Dark Mode'.tr()).tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChangeTheme();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('Logout'.tr()),
            onTap: () async {
              await FirebaseAuthService().logout();
              // Use Future.microtask to ensure the drawer is closed before navigating
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
