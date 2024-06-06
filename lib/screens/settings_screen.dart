import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSettingsCard(
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'Manage your profile information',
              onTap: () {
                // Navigate to Profile Page
              },
            ),
            _buildSettingsCard(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help and find FAQs',
              onTap: () {
                // Navigate to Help & Support Page
              },
            ),
            _buildSettingsCard(
              icon: Icons.info,
              title: 'About',
              subtitle: 'Learn more about DevPedia',
              onTap: () {
                // Navigate to About Page
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add sign out functionality
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 48, 48, 48),
                  // onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Function() onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: 30),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 20),
        onTap: onTap,
      ),
    );
  }
}
