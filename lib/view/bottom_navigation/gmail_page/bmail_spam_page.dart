import 'package:flutter/material.dart';

import '../../../utils/custom_color.dart';
import '../../auth/sign_in_screen.dart';
import 'bmail_draft.dart';
import 'bmail_main_page.dart';
import 'bmail_sent.dart';
import 'bmail_trash_page.dart';
import '../compose/compose_page.dart';

class BmailSpamPage extends StatefulWidget {
  const BmailSpamPage({super.key});

  @override
  State<BmailSpamPage> createState() => _BmailSpamPageState();
}

class _BmailSpamPageState extends State<BmailSpamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.blue.shade100, // Soft blue background for header
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Image.asset(
                  "assets/Bmail_Logo_Gif-full.gif",
                  width: MediaQuery.of(context).size.width * .40,
                  height: MediaQuery.of(context).size.width * .40,
                ),
              ),
            ),
            SizedBox(height: 10), // Add spacing for better layout
            Divider(
              thickness: 1,
              color: Colors.grey.shade300,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _createDrawerItem(
                    icon: Icons.inbox,
                    text: 'Inbox',
                    trailing: '20 new',
                    onTap: () => _navigateTo(context, const BmailMainPage()),
                  ),
                  _createDrawerItem(
                    icon: Icons.send,
                    text: 'Sent',
                    trailing: '15',
                    onTap: () => _navigateTo(context, const BmailSent()),
                  ),
                  _createDrawerItem(
                    icon: Icons.drafts,
                    text: 'Drafts',
                    trailing: '8',
                    onTap: () => _navigateTo(context, BmailDraftPage()),
                  ),
                  _createDrawerItem(
                    icon: Icons.report,
                    text: 'Spam',
                    trailing: '12',
                    onTap: () => _navigateTo(context, BmailSpamPage()),
                  ),
                  _createDrawerItem(
                    icon: Icons.delete,
                    text: 'Trash',
                    trailing: '2',
                    onTap: () => _navigateTo(context, const BmailTrashPage()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, left: 10, right: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: Colors.black38),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Open the drawer
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search in spam',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/profile_imge.jpg'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Number of spam emails
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: const Icon(Icons.report, color: Colors.white), // Spam icon
                  ),
                  title: Text(
                    'Spam Subject $index',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('This is a preview of the spam email content.'),
                  trailing: const Text('2 days ago', style: TextStyle(color: Colors.grey)),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF00A7FE),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComposePage()),
          );
        },
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    String trailing = '',
    required GestureTapCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50, // Light blue background for icons
            borderRadius: BorderRadius.circular(10), // Rounded icon background
          ),
          child: Icon(icon, color: CustomColor.secondaryColor),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Text(
          trailing,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
