// import 'package:devpedia/auth%20and%20cloud/auth_provider.dart';
// import 'package:devpedia/random_code/login_register.dart';

// import 'package:devpedia/resources%20screens/all_resources.dart';
// import 'package:devpedia/resources%20screens/aws.dart';
// import 'package:devpedia/resources%20screens/jenkins.dart';
// import 'package:devpedia/screens/contact_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DashboardScreen extends ConsumerStatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _DashboardScreenState();
// }

// class _DashboardScreenState extends ConsumerState<DashboardScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _widgetOptions = <Widget>[
//     AllResources(),
//     JenkinsResources(),
//     awsresources(),
//     ContactScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authStateChangesNotifier = ref.watch(authStateChangesProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('DevPedia'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: authStateChangesNotifier.value != null
//                 ? () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: const Text('Logout'),
//                           content:
//                               const Text('Are you sure you want to logout?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text('Cancel'),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 ref.watch(authRepositoryProvider).signOut();
//                                 Navigator.of(context).pushAndRemoveUntil(
//                                   MaterialPageRoute(
//                                     builder: (context) => const LoginRegister(),
//                                   ),
//                                   (route) => false,
//                                 );
//                               },
//                               child: const Text('Logout'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }
//                 : null,
//           ),
//         ],
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             UserAccountsDrawerHeader(
//               decoration: const BoxDecoration(
//                 color: Color.fromARGB(255, 0, 0, 0),
//               ),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Text(
//                   authStateChangesNotifier.value?.email![0].toUpperCase() ?? '',
//                   style: const TextStyle(fontSize: 40.0),
//                 ),
//               ),
//               accountName: Text(
//                 authStateChangesNotifier.value?.displayName ?? '',
//                 style: TextStyle(fontSize: 16),
//               ),
//               accountEmail: Text(
//                 authStateChangesNotifier.value?.email ?? '',
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//             _buildDrawerItem(
//               icon: Icons.library_books,
//               text: 'Latest Resources',
//               index: 0,
//             ),
//             _buildDrawerItem(
//               icon: Icons.build,
//               text: 'Jenkins Resources',
//               index: 1,
//             ),
//             _buildDrawerItem(
//               icon: Icons.cloud,
//               text: 'AWS Resources',
//               index: 2,
//             ),
//             _buildDrawerItem(
//               icon: Icons.contact_mail,
//               text: 'Contact Us',
//               index: 3,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//       {required IconData icon, required String text, required int index}) {
//     return ListTile(
//       leading: Icon(icon, color: _selectedIndex == index ? Colors.blue : null),
//       title: Text(
//         text,
//         style: TextStyle(
//           color: _selectedIndex == index ? Colors.blue : null,
//           fontWeight:
//               _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//       selected: _selectedIndex == index,
//       onTap: () {
//         _onItemTapped(index);
//         Navigator.pop(context);
//       },
//     );
//   }
// }

import 'package:devpedia/auth%20and%20cloud/auth_provider.dart';
import 'package:devpedia/screens/login_register.dart';

import 'package:devpedia/resources%20screens/all_resources.dart';
import 'package:devpedia/resources%20screens/aws.dart';
import 'package:devpedia/resources%20screens/jenkins.dart';
import 'package:devpedia/screens/contact_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ResourceFilter { latest, jenkins, aws, contact }

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  late ResourceFilter _filter;

  final List<Widget> _widgetOptions = <Widget>[
    AllResources(),
    JenkinsResources(),
    awsresources(),
    ContactScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _filter = ResourceFilter.latest;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStateChangesNotifier = ref.watch(authStateChangesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('DevPedia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authStateChangesNotifier.value != null
                ? () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.watch(authRepositoryProvider).signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginRegister(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                : null,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            _buildFilterDropdown(),
            Expanded(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  authStateChangesNotifier.value?.email![0].toUpperCase() ?? '',
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
              accountName: Text(
                authStateChangesNotifier.value?.displayName ?? '',
                style: TextStyle(fontSize: 16),
              ),
              accountEmail: Text(
                authStateChangesNotifier.value?.email ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.library_books,
              text: 'Latest Resources',
              index: 0,
            ),
            _buildDrawerItem(
              icon: Icons.build,
              text: 'Jenkins Resources',
              index: 1,
            ),
            _buildDrawerItem(
              icon: Icons.cloud,
              text: 'AWS Resources',
              index: 2,
            ),
            _buildDrawerItem(
              icon: Icons.contact_mail,
              text: 'Contact Us',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon, required String text, required int index}) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? Colors.blue : null),
      title: Text(
        text,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.blue : null,
          fontWeight:
              _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButton<ResourceFilter>(
      value: _filter,
      onChanged: (newValue) {
        setState(() {
          _filter = newValue!;
        });
      },
      items: [
        DropdownMenuItem(
          value: ResourceFilter.latest,
          child: Text('Latest Resources'),
          onTap: () => _onItemTapped(0),
        ),
        DropdownMenuItem(
          value: ResourceFilter.jenkins,
          child: Text('Jenkins Resources'),
          onTap: () => _onItemTapped(1),
        ),
        DropdownMenuItem(
          value: ResourceFilter.aws,
          child: Text('AWS Resources'),
          onTap: () => _onItemTapped(2),
        ),
        DropdownMenuItem(
          value: ResourceFilter.contact,
          child: Text('Contact Us'),
          onTap: () => _onItemTapped(3),
        ),
      ],
    );
  }
}
