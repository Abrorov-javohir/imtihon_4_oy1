import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imtihon_4_oy1/models/event.dart';

class EventService extends ChangeNotifier {
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  List<Event> events = [];

  EventService() {
    fetchEvents();
  }

  get canceledEvents => null;

  Future<void> fetchEvents() async {
    try {
      final querySnapshot = await eventsCollection.get();
      events = querySnapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  Future<void> getEvent(String id) async {
    try {
      final doc = await eventsCollection.doc(id).get();
      if (doc.exists) {
        final event = Event.fromDocument(doc);
        // You can add this event to your list or do something else with it
        print('Event: ${event.name}');
      } else {
        print('No such document!');
      }
    } catch (e) {
      print('Error getting event: $e');
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      await eventsCollection.add(event.toMap());
      await fetchEvents();
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await eventsCollection.doc(event.id).update(event.toMap());
      await fetchEvents();
    } catch (e) {
      print('Error updating event: $e');
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await eventsCollection.doc(id).delete();
      await fetchEvents();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  Stream<List<Event>> get eventsStream {
    return eventsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();
    });
  }

  void cancelEvent(id) {}
}
