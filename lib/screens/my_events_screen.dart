import 'package:flutter/material.dart';
import 'package:imtihon_4_oy1/services/event_service.dart';
import 'package:provider/provider.dart';
import 'add_event_screen.dart';

class MyEventsScreen extends StatefulWidget {
  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: Text(
          'My Events',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: 'Tashkil qilganlarim'),
            Tab(text: 'Yaqinda'),
            Tab(text: 'Ishtirok etganlarim'),
            Tab(text: 'Bekor qilganlarim'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList(eventViewModel),
          const Center(child: Text('Yaqinda')),
          Center(child: Text('Ishtirok etganlarim')),
          Center(child: Text('Bekor qilganlarim')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildEventList(EventService eventViewModel) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: eventViewModel.events.length,
      itemBuilder: (context, index) {
        final event = eventViewModel.events[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Image.asset("assets/logo_imtihon.png"),
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
                        builder: (context) => AddEventScreen(),
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
}
