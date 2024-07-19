import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:imtihon_4_oy1/widgets/reminder_dialog.dart';
import 'package:imtihon_4_oy1/widgets/booking_bottom_sheet.dart';

class InformationOfEventScreen extends StatefulWidget {
  const InformationOfEventScreen({Key? key}) : super(key: key);

  @override
  State<InformationOfEventScreen> createState() =>
      _InformationOfEventScreenState();
}

class _InformationOfEventScreenState extends State<InformationOfEventScreen> {
  bool isLiked = false;
  File? _image;
  User? user;

  List<String> registeredEvents = [];

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  late YandexMapController mapController;

  final Point _center = const Point(latitude: 41.2995, longitude: 69.2401);

  void _onMapCreated(YandexMapController controller) {
    mapController = controller;
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

  void _showBookingBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => BookingBottomSheet(
        onEventRegistered: (event) {
          setState(() {
            registeredEvents.add(event);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(250), // Adjust the preferred height
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/image2.png",
              fit: BoxFit.cover,
              height: 250, // Adjust the height of the image
            ),
            AppBar(
              title: const Text("Event Information"),
              backgroundColor: Colors.transparent, // Make appbar transparent
              actions: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                  ),
                  onPressed: toggleLike,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Satellite mega festival for designers",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.calendar_today),
                SizedBox(width: 8),
                Text("14 iyul, 2024"),
                SizedBox(width: 16),
                Icon(Icons.access_time),
                SizedBox(width: 8),
                Text("4:00PM - 9:00PM"),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.location_on),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Yoshlar ijod saroyi\nMustaqillik ko'chasi, Toshkent",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.people),
                SizedBox(width: 8),
                Text("243 kishi bormoqda"),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : AssetImage("assets/imtihon_logo_javohir.png")
                        as ImageProvider,
              ),
              title: Text(user?.email ?? "Abrorov Javohir"),
              subtitle: Text("Tadbir tashkilotchisi"),
            ),
            const SizedBox(height: 16),
            const Text(
              "Tadbir haqida",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Sevimli taomingizdan va do'stlaringiz va oila a'zolaringiz zavqlangan va vaqtni ajoyib o'tkazing. Mahalliy oziq-ovqat yuk mashinalaridan oziq-ovqat sotib olish mumkin bo'ladi.",
            ),
            const SizedBox(height: 16),
            const Text(
              "Manzil",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Yoshlar ijod saroyi\nMustaqillik ko'chasi, Toshkent"),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                height: 200,
                child: YandexMap(
                  onMapCreated: _onMapCreated,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 2),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showBookingBottomSheet,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                          color: Color.fromARGB(255, 255, 115, 0),
                          width: 2.0,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          Color.fromARGB(255, 255, 221, 202), // Ichki rangi
                      foregroundColor: Colors.black, // Matnning rangi
                    ),
                    child: const Text(
                      "Ro'yxatdan O'tish",
                      style: TextStyle(
                        color: Colors.black, // Matnning rangi (qo'shimcha)
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
