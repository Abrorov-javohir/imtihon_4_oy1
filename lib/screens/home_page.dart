import 'package:flutter/material.dart';
import 'package:imtihon_4_oy1/widgets/my_drawer.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  TextEditingController search = TextEditingController();

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications),
            )
          ],
        ),
        drawer: MyDrawer(),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Search",
                ),
              ),
            ],
          ),
        ));
  }
}
