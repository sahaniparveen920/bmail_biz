import 'dart:convert';
import 'package:Bmail/view/bottom_navigation/compose/reply_compose_page.dart';
import 'package:Bmail/view/bottom_navigation/gmail_page/privacy_policy_page.dart';
import 'package:Bmail/view/bottom_navigation/gmail_page/term_services_page.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model_class/email.dart';
import '../../../pop_up_screen/bmail_todo_page.dart';
import '../../../utils/custom_color.dart';
import '../../auth/sign_in_screen.dart';
import '../storage/bmail_storage_page.dart';
import 'bmail_draft.dart';
import 'bmail_main_page.dart';
import 'bmail_trash_page.dart';
import '../compose/compose_page.dart';
import '../compose/forword_compose_page.dart';

// Define the EmailResponse class
class EmailResponse {
  final bool success;
  final List<Email> emails;

  EmailResponse({
    required this.success,
    required this.emails,
  });

  factory EmailResponse.fromJson(Map<String, dynamic> json) {
    var list = json['emails'] as List;
    List<Email> emailList = list.map((i) => Email.fromJson(i)).toList();
    return EmailResponse(
      success: json['success'],
      emails: emailList,
    );
  }
}

class EmailDetailPage extends StatelessWidget {
  final Email email;

  const EmailDetailPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");

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
        backgroundColor: CustomColor.white,
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
              email.subject,
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
                  backgroundColor: CustomColor.lightGrey,
                  child: Text(
                    email.sender[0].toUpperCase(),
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
                        email.sender,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        email.date, // Correctly format the DateTime object
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
                  email.body,
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
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16), // Optional: add padding if needed
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Ensures the Row takes only necessary width
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Get.to(
                                  ReplyComposePage(
                                    email: email.sender,
                                  ),
                                );
                              },
                              icon: Icon(Icons.reply, color: Colors.blue),
                              label: Text('Reply', style: TextStyle(color: Colors.blue)),
                            ),
                            SizedBox(width: 16), // Adjust the spacing as needed
                            TextButton.icon(
                              onPressed: () {
                                Get.to(
                                  ForwordComposePage(
                                    email: email.sender,
                                    subject: email.subject,
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


class BmailSent extends StatefulWidget {
  const BmailSent({super.key});

  @override
  State<BmailSent> createState() => _BmailSentState();
}

class _BmailSentState extends State<BmailSent> {
  List<Email> _emails = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _userName = 'name'; // Example user name
  String _userEmail = 'email'; // Example email
  String _userId = 'userid';

  @override
  void initState() {
    super.initState();
    fetchData().then((_) => _fetchEmails());
  }

  String _formatDate(String dateString) {
    try {
      // Log the date string received from the API
      print('Received date string: $dateString');

      // Updated input format to match the provided date string
      final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime parsedDate = inputFormat.parse(dateString);

      // Extracting the date part only (d MMM yyyy)
      final outputFormat = DateFormat('d MMM yyyy');
      return outputFormat.format(parsedDate);
    } catch (e) {
      print('Error parsing date: $e');

      // Return 'Invalid Date' if parsing fails
      return 'Invalid Date';
    }
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'name';
      _userId = prefs.getInt('user_id')?.toString() ?? 'userid';
      _userEmail = prefs.getString('user_email') ?? 'email';
    });
  }

  Future<void> _fetchEmails() async {
    final url = 'https://apiv2.bmail.biz/sent';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': _userId,
          'email': _userEmail,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');


      if (response.statusCode == 200) {
        final emailResponse = EmailResponse.fromJson(json.decode(response.body));
        if (emailResponse.success) {
          setState(() {
            _emails = emailResponse.emails;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'No emails found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load emails: ${response.statusCode} - ${response.body}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
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
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: Text('Sign Out'),
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
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : ListView.builder(
              itemCount: _emails.length,
              itemBuilder: (context, index) {
                final email = _emails[index];

                // Parse and format the date to "30 Sep"
                DateTime? parsedDate;
                String formattedDate = '';

                if (email.date.isNotEmpty) {
                  try {
                    parsedDate = DateTime.parse(email.date);
                    formattedDate = DateFormat('dd MMM').format(parsedDate);
                  } catch (e) {
                    formattedDate = 'Invalid Date';
                  }
                } else {
                  formattedDate = 'No Date';
                }

                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailDetailPage(email: email),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 2), // Shadow position
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: CustomColor.secondaryColor,
                                  child: Text(
                                    _userName.isNotEmpty ? _userName[0] : '',
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'From: ${email.sender}',  // Display sender's email
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,  // Handle overflow
                                          ),

                                          Text(
                                            email.date != null
                                                ? _formatDate(email.date)  // Call the helper function to format the date
                                                : 'No date',  // Fallback if date is null
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,  // Handle overflow if it's too long
                                          ),

                                        ],
                                      ),
                                      Text(
                                        email.subject ?? 'No Subject', // Display subject
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis, // Handle overflow if text is too long
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),  // Add some spacing between the elements

                              ],
                            ),

                            SizedBox(height: 8), // Add some space between rows

                          ],
                        ),
                      ),
                    )
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.secondaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComposePage()),
          );
        },
        child: Icon(Icons.edit, color: Colors.white),
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


// Open Contacts
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