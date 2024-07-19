import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  late YandexMapController mapController;
  Point? selectedLocation;
  List<MapObject> mapObjects = [];
  final Location location = Location();
  File? _image;
  User? user;

  Future pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event (Edit)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nomi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos, nomini kiriting';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Kuni',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    });
                  }
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Vahti',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _timeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
              TextFormField(
                controller: _infoController,
                decoration:
                    InputDecoration(labelText: 'Tadbir haqida ma\'lumot:'),
                maxLines: 3,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: Icon(
                      Icons.camera,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: Icon(
                      Icons.photo,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              if (_image != null)
                Container(
                  height: 100,
                  width: 100,
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                child: YandexMap(
                  onMapCreated: (YandexMapController controller) {
                    mapController = controller;
                    mapController.toggleUserLayer(
                      visible: true,
                      headingEnabled: true,
                    );
                  },
                  onCameraPositionChanged: (CameraPosition position,
                      CameraUpdateReason reason, bool finished) {
                    if (reason == CameraUpdateReason.gestures) {
                      setState(() {
                        selectedLocation = position.target;
                      });
                      _locationController.text =
                          "${position.target.latitude},${position.target.longitude}";
                    }
                  },
                  mapObjects: mapObjects,
                ),
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Joylashuvi'),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseFirestore.instance.collection('events').add({
                      'name': _nameController.text,
                      'date': _dateController.text,
                      'time': _timeController.text,
                      'info': _infoController.text,
                      'location': _locationController.text,
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Tadbir muvaffaqiyatli qo\'shildi')),
                      );
                      Navigator.pop(context);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Tadbirni qo\'shishda xatolik: $error')),
                      );
                    });
                  }
                },
                child: Text('Qo\'shish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
