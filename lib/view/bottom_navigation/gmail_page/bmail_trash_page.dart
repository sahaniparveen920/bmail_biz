import 'dart:convert';
import 'package:Bmail/model_class/trash_email.dart';
import 'package:Bmail/view/bottom_navigation/compose/forword_compose_page.dart';
import 'package:Bmail/view/bottom_navigation/compose/reply_compose_page.dart';
import 'package:Bmail/view/bottom_navigation/gmail_page/privacy_policy_page.dart';
import 'package:Bmail/view/bottom_navigation/gmail_page/term_services_page.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../pop_up_screen/bmail_todo_page.dart';
import '../../../utils/custom_color.dart';
import '../../auth/sign_in_screen.dart';
import '../storage/bmail_storage_page.dart';
import 'bmail_draft.dart';
import 'bmail_main_page.dart';
import 'bmail_sent.dart';
import '../compose/compose_page.dart';

class EmailDetailPage extends StatelessWidget {
  final Emails email; // Use Emails here

  const EmailDetailPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Email Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () {
              // Handle delete action
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              email.subject ?? 'No Subject',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    email.from != null && email.from!.isNotEmpty
                        ? email.from![0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email.from ?? 'No Sender',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        email.date ?? 'No Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(
              height: 20,
              color: Colors.grey[300],
            ),
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: HtmlWidget(
                  email.body ?? '',
                  textStyle: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReplyComposePage(
                                      email: email.from,  // Pass email sender
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.reply, color: Colors.blue),
                              label: Text('Reply', style: TextStyle(color: Colors.blue)),
                            ),
                            SizedBox(width: 16),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForwordComposePage(
                                      email: email.from,
                                      subject: email.subject,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.forward, color: Colors.green),
                              label: Text('Forward', style: TextStyle(color: Colors.green)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


class BmailTrashPage extends StatefulWidget {
  const BmailTrashPage({super.key});

  @override
  State<BmailTrashPage> createState() => _BmailTrashPageState();
}

class _BmailTrashPageState extends State<BmailTrashPage> {
  List<dynamic> trashedEmails = [];
  List<bool> selectedEmails = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _userName = 'name'; // Example user name
  String _userEmail = 'email'; // Example email
  String _userId = 'userid';
  List<String> collectedMessageIds = []; // New list to hold collected message IDs



  String _formatDate(String dateString) {
    try {
      print('Received date string: $dateString');
      final inputFormat = DateFormat("EEE, d MMM yyyy HH:mm:ss Z");
      DateTime parsedDate = inputFormat.parse(dateString);
      final outputFormat = DateFormat('hh:mm a');
      return outputFormat.format(parsedDate);
    } catch (e) {
      print('Error parsing date: $e');
      final timeMatch = RegExp(r'\d{2}:\d{2}').firstMatch(dateString);
      return timeMatch != null ? timeMatch.group(0)! : 'Invalid Time';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData().then((_) => fetchTrashedEmails());
  }

  List<String> _collectMessageIds() {
    List<String> collectedMessageIds = [];

    // Collect all message IDs from trashedEmails
    for (var email in trashedEmails) {
      var messageId = (email as Emails).messageId ?? '';
      if (messageId.isNotEmpty) {
        collectedMessageIds.add(messageId);
      }
    }

    // Log the collected IDs for debugging
    print('Collected Message IDs: $collectedMessageIds');

    // Provide feedback if no message IDs were collected
    if (collectedMessageIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No message IDs collected.')),
      );
    }

    return collectedMessageIds; // Return the collected IDs
  }



  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'name';
      _userId = prefs.getInt('user_id')?.toString() ?? 'userid';
      _userEmail = prefs.getString('user_email') ?? 'email';
    });
    print('User ID: $_userId');
    print('User Email: $_userEmail');
  }

  Future<void> fetchTrashedEmails() async {
    const String apiUrl = 'https://petdoctorindia.in/gettrash';
    final Map<String, dynamic> body = {
      "userId": _userId,
      "email": _userEmail,
      "messageId": " "
    };

    print('Request URL: $apiUrl');
    print('Request Body: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          TrashEmail trashEmail = TrashEmail.fromJson(jsonResponse);

          bool? success = trashEmail.success;
          List<Emails>? emails = trashEmail.emails;

          if (success == true && emails != null) {
            trashedEmails = emails;  // Update trashedEmails
          } else {
            _hasError = true;  // Update error state
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;  // Update error state
        });
        print('Error: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;  // Update error state
      });
      print('Exception: $e');
    }
  }

  Future<void> _deleteMessages(BuildContext context) async {
    final List<String> messageIds = _collectMessageIds(); // Collect message IDs

    // Check if there are any message IDs collected before proceeding with the API call
    if (messageIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No messages to delete.')),
      );
      return; // Exit the function if there are no message IDs
    }

    final String url = 'https://petdoctorindia.in/deletetrash';

    final Map<String, dynamic> body = {
      "userId": _userId, // Replace with actual user ID if needed
      "email": _userEmail, // Replace with actual email if needed
      "message_ids": messageIds, // Pass the list of IDs directly
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Successfully deleted messages
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Messages deleted successfully!')),
        );
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete messages.')),
        );
      }
    } catch (e) {
      // Handle any exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _showProfilePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: CustomColor.secondaryColor,
                child: Text(
                  _userName.isNotEmpty ? _userName[0] : '',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Hi, $_userName',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                _userEmail,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.secondaryColor,
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: Text('Sign Out', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

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
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(), // Remove internal decoration
                accountName: Text(_userName),
                accountEmail: Text(_userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.blue.shade200,
                  backgroundImage: AssetImage('assets/gmail.webp'),
                ),
              ),
            ),
            SizedBox(height: 10), // Add spacing for better layout
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _createDrawerItem(
                    icon: Icons.inbox,
                    text: 'Inbox',
                    onTap: () => _navigateTo(context, const BmailMainPage()),
                  ),
                  _createDrawerItem(
                    icon: Icons.send,
                    text: 'Sent',
                    onTap: () => _navigateTo(context, const BmailSent()),
                  ),
                  _createDrawerItem(
                    icon: Icons.drafts,
                    text: 'Drafts',
                    onTap: () => _navigateTo(context, BmailDraftPage()),
                  ),
                  _createDrawerItem(
                    icon: Icons.delete,
                    text: 'Trash',
                    onTap: () => _navigateTo(context, const BmailTrashPage()),
                  ),
                  SizedBox(height: 20), // Add spacing before "Tools" section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Tools',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700], // Text style for "Tools" label
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Calendar Button
                  _createDrawerItem(
                    icon: Icons.calendar_today,
                    text: 'Calendar',
                    onTap: _openCalendar, // Opens the mobile calendar
                  ),
                  // To-Do List Button
                  _createDrawerItem(
                    icon: Icons.check_circle,
                    text: 'To-Do List',
                    onTap: () {
                      showToDoPopup(context); // Display the To-Do List Popup
                    },
                  ),
                  // Contacts Button
                  _createDrawerItem(
                    icon: Icons.contacts,
                    text: 'Contacts',
                    onTap: _openContacts, // Opens the mobile contacts
                  ),
                  _createDrawerItem(
                    icon: Icons.storage_outlined,
                    text: 'Storage',
                    onTap: () => _navigateTo(context, BmailStoragePage()),
                  ),
                  _createDrawerItem(
                    icon: Icons.settings,
                    text: 'Privacy and Policy',
                    onTap: () => _navigateTo(context, PrivacyPolicyPage()),
                  ),
                  _createDrawerItem(
                    icon: Icons.settings,
                    text: 'Terms and Services',
                    onTap: () => _navigateTo(context, TermServicePage()),
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
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search in bmail',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showProfilePopup(context);
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: CustomColor.secondaryColor,
                    child: Text(
                      _userName.isNotEmpty ? _userName[0] : '',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _hasError
                ? Center(child: Text('Failed to load emails'))
                : trashedEmails.isEmpty
                ? Center(child: Text('No emails found'))
                : ListView.builder(
              itemCount: trashedEmails.length,
              itemBuilder: (context, index) {
                final email = trashedEmails[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade200,
                        child: Text(
                          email.subject != null && email.subject!.isNotEmpty
                              ? email.subject![0].toUpperCase()
                              : '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              email.subject ?? 'No Subject',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            email.date != null
                                ? _formatDate(email.date!)
                                : 'No date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      subtitle: Text(email.from ?? 'No Sender'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailDetailPage(email: email),  // Pass the correct type
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Existing Delete button
          FloatingActionButton(
            backgroundColor: Colors.red, // Set color for delete button
            onPressed: () {
              _deleteMessages(context); // Call delete function
            },
            child: Icon(Icons.delete, color: Colors.white),
          ),
          SizedBox(height: 16),
          // Existing Compose button
          FloatingActionButton(
            backgroundColor: CustomColor.secondaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ComposePage()),
              );
            },
            child: Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openCalendar() async {
    final intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'content://com.android.calendar/time/',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  void _openContacts() {
    // Android-specific URI for opening the contacts
    _launchURL('content://contacts/people/');
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
          child: Icon(icon, color: Colors.blueAccent),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: trailing.isNotEmpty
            ? Text(
          trailing,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        )
            : null,
        onTap: onTap,
      ),
    );
  }
}