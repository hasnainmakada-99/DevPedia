import 'package:devpedia/auth/auth_provider.dart';
import 'package:devpedia/utils/alertDialog.dart';
import 'package:devpedia/utils/resource_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // ignore: non_constant_identifier_names

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgets = List.generate(2, (index) => ResourceCard());

  List<Widget> _generateListCards(List<String> items) {
    return List.generate(3, (index) => ResourceCard());
  }

  List<Widget> _generateListTiles(List<String> items) {
    return items.map((item) {
      final index = items.indexOf(item);
      return ListTile(
        title: Text(item),
        selected: _selectedIndex == index,
        onTap: () {
          _onItemTapped(index);
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStateChangesNotifier = ref.watch(authStateChangesProvider);

    // Replace this with your API response
    final apiResponse = ['Travis CI', 'Circle CI', 'Jenkins'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ref.watch(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: _widgets.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black87),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore various DevOps Tools',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, watch, child) {
                      final user = ref.watch(authStateChangesProvider).value;
                      final email = user!.email ?? 'Username not found';
                      return Text(
                        email,
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
            ),
            ..._generateListTiles(apiResponse),
          ],
        ),
      ),
    );
  }
}
