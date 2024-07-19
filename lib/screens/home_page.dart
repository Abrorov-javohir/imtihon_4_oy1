import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imtihon_4_oy1/models/event.dart';
import 'package:imtihon_4_oy1/screens/notification_screen.dart';
import 'package:imtihon_4_oy1/services/event_service.dart';
import 'package:imtihon_4_oy1/widgets/event_card.dart';
import 'package:imtihon_4_oy1/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

import 'information_of_event_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();
  String sortBy = "name";

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventService>(context);
    final events = eventViewModel.events.where((event) {
      return event.name.toLowerCase().contains(search.text.toLowerCase());
    }).toList();

    if (sortBy == "name") {
      events.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortBy == "location") {
      events.sort((a, b) => a.location.compareTo(b.location));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home".tr(),
          style: TextStyle(
            color: Colors.orange,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NotificationsScreen();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: GoogleFonts.aBeeZee(),
                cursorColor: Colors.orange,
                controller: search,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Search for events".tr(),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.orange,
                  ),
                  suffixIcon: PopupMenuButton<String>(
                    onSelected: (String result) {
                      setState(() {
                        sortBy = result;
                      });
                    },
                    icon: Icon(
                      Icons.sort,
                      color: Colors.orange,
                    ),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "name",
                        child: Text('Tadbir nomi bo\'yicha'),
                      ),
                      const PopupMenuItem<String>(
                        value: "location",
                        child: Text('Manzil bo\'yicha'),
                      ),
                    ],
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Events in the next 7 days".tr(),
                    style: GoogleFonts.italiana(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const InformationOfEventScreen();
                      },
                    ),
                  );
                },
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    height: 220,
                    autoPlayInterval: const Duration(
                      seconds: 5,
                    ),
                  ),
                  items: [1, 2].map(
                    (i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/image2.png"),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        CupertinoIcons.heart_fill,
                                        color:
                                            i == 1 ? Colors.green : Colors.red,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 110,
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 6, 0, 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Satellite mega festival for \ndesigners ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "All Events".tr(),
                    style: GoogleFonts.italiana(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 300, // Adjust height based on your content
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(event: event);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
