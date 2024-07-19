import 'package:flutter/material.dart';
import 'package:imtihon_4_oy1/screens/edit_event_screen.dart';
import 'package:imtihon_4_oy1/services/event_service.dart';
import 'package:imtihon_4_oy1/widgets/my_drawer.dart';
import 'package:provider/provider.dart';
import 'add_event_screen.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> registeredEvents = [
    "Event 1",
    "Event 2",
    "Event 3"
  ]; // example events

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _cancelRegistration(int index) {
    setState(() {
      registeredEvents.removeAt(index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Events',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.orange),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.orange,
            ),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: 'Tashkil qilganlarim'),
            Tab(text: 'Yaqinda'),
            Tab(text: 'Ishtirok etganlarim'),
            Tab(text: 'Bekor qilganlarim'),
          ],
        ),
      ),
      drawer: const MyDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList(eventViewModel),
          _buildEventList(eventViewModel),
          _buildCancelledEventsList(),
          const Center(child: Text('Bekor qilganlarim')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventList(EventService eventViewModel) {
    if (eventViewModel.events == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: eventViewModel.events.length,
      itemBuilder: (context, index) {
        final event = eventViewModel.events[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Image.asset("assets/imtihon_logo_javohir.png"),
            title: Text(event.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.date),
                Text(event.location),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (String result) {
                setState(() {
                  if (result == 'Delete') {
                    eventViewModel.deleteEvent(event.id);
                  } else if (result == 'Edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEventScreen(
                          event: event,
                        ),
                      ),
                    );
                  }
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Edit',
                  child: Text('Tahrirlash'),
                ),
                const PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text('O\'chirish'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCancelledEventsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: registeredEvents.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Image.asset("assets/result.png"),
            title: Text(registeredEvents[index]),
            subtitle: const Text("Tadbir joyi: Yoshlar ijod saroyi"),
          ),
        );
      },
    );
  }
}
