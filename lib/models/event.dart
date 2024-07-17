import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String name;
  String date;
  String time;
  String info;
  String location;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.info,
    required this.location,
  });

  factory Event.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      name: data['name'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      info: data['info'] ?? '',
      location: data['location'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'time': time,
      'info': info,
      'location': location,
    };
  }
}