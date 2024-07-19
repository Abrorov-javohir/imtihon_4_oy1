import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy1/models/event.dart';
import 'package:imtihon_4_oy1/screens/event_details_screen.dart';
import 'package:imtihon_4_oy1/screens/information_of_event_screen.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.asset("assets/imtihon_logo_javohir.png"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.event.name),
            IconButton(
              icon: Icon(
                isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: isLiked ? Colors.green : Colors.red,
              ),
              onPressed: toggleLike,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.event.date),
                SizedBox(width: 10),
                Text(widget.event.time),
              ],
            ),
            Text(widget.event.location),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EventDetailsScreen(event: widget.event);
              },
            ),
          );
        },
      ),
    );
  }
}
