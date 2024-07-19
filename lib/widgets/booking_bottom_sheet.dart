import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:imtihon_4_oy1/screens/home_page.dart';
import 'package:imtihon_4_oy1/widgets/reminder_dialog.dart';

class BookingBottomSheet extends StatefulWidget {
  final Function(String) onEventRegistered;

  const BookingBottomSheet({required this.onEventRegistered, Key? key})
      : super(key: key);

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  int _seatCount = 0;
  String? _paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  "Ro'yxatdan O'tish",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.clear),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () {
                    setState(() {
                      if (_seatCount > 0) _seatCount--;
                    });
                  },
                ),
                Text("$_seatCount", style: const TextStyle(fontSize: 20)),
                IconButton(
                  icon: const Icon(CupertinoIcons.add_circled_solid),
                  onPressed: () {
                    setState(() {
                      _seatCount++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "To'lov turini tanlang",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            ListTile(
              leading: const Image(
                image: AssetImage(
                  "assets/click.png",
                ),
              ),
              title: const Text("Click"),
              trailing: Radio<String>(
                value: "Click",
                groupValue: _paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Image(
                image: AssetImage(
                  "assets/payme.png",
                ),
              ),
              title: const Text("Payme"),
              trailing: Radio<String>(
                value: "Payme",
                groupValue: _paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Image(image: AssetImage("assets/naqd.png")),
              title: const Text("Naqd"),
              trailing: Radio<String>(
                value: "Naqd",
                groupValue: _paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 2),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onEventRegistered("Flutter Global Hakaton 2024");
                    Navigator.pop(context);
                    showBookingDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromARGB(255, 255, 139, 45),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Keyingi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

void showBookingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage(
                "assets/imtihon_logo_javohir.png",
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Tabriklaymiz!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Siz Flutter Global Hakaton 2024 tadbiriga muvaffaqiyatli ro'yxatdan o'tdingiz.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                showReminderDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Eslatma Belgilash",
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePage();
                    },
                  ),
                );
                // Bosh sahifaga o'tayotganda qanday amal bajarilishi kerak bo'lsa shu yerda yozing
              },
              style: TextButton.styleFrom(
                side: BorderSide(color: Colors.orange),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Bosh Sahifa",
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
            ),
          ],
        ),
      );
    },
  );
}
