import 'dart:convert';
import 'package:Bmail/view/bottom_navigation/compose/forword_compose_page.dart';
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
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model_class/email.dart';
import '../../../pop_up_screen/bmail_todo_page.dart';
import '../../../utils/custom_color.dart';
import '../../auth/sign_in_screen.dart';
import '../storage/bmail_storage_page.dart';
import 'bmail_draft.dart';
import 'bmail_sent.dart';
import 'bmail_trash_page.dart';
import '../compose/compose_page.dart';

class EmailDetailPage extends StatefulWidget {
  final Email email;

  const EmailDetailPage({super.key, required this.email});

  @override
  _EmailDetailPageState createState() => _EmailDetailPageState();
}

class _EmailDetailPageState extends State<EmailDetailPage> {
  late String _userMessageId;
  late String _userEmail;
  late String _userId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userMessageId = widget.email.message_id!; // Ensure messageId is the correct field
      _userId = prefs.getInt('user_id')?.toString() ?? 'userid';
      _userEmail = prefs.getString('user_email') ?? 'email';
    });
    print('User ID: $_userId');
    print('User Email: $_userEmail');
  }

  Future<void> _deleteEmail(BuildContext context) async {
    final String apiUrl = 'https://petdoctorindia.in/trash'; // API endpoint

    // Prepare the request body according to the new API format
    final requestBody = jsonEncode({
      'userId': _userId, // Updated userId
      'email': _userEmail, // Updated email
      'messageId': _userMessageId, // Correct messageId from the email object
    });

    // Log request details for debugging
    print('Request URL: $apiUrl');
    print('Request Body: $requestBody');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // Uncomment and replace with actual token if needed
          // 'Authorization': 'Bearer YOUR_AUTH_TOKEN',
        },
        body: requestBody,
      );

      // Log response details for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          Get.snackbar(
            'Success',
            'Email deleted successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Navigate to BmailMainPage
          Get.off(() => BmailMainPage());
        } else {
          Get.snackbar(
            'Error',
            'Failed to delete email: ${responseData['message']}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete email: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

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
              _deleteEmail(context);
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.email.subject,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: CustomColor.lightGrey,
                  child: Text(
                    widget.email.sender[0].toUpperCase(),
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
                        widget.email.sender,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.email.date, // Correctly format the DateTime object
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
                  widget.email.body,
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
                                    email: widget.email.sender,
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
                                    email: widget.email.sender,
                                    subject: widget.email.subject,
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

class BmailMainPage extends StatefulWidget {
  const BmailMainPage({super.key});

  @override
  State<BmailMainPage> createState() => _BmailMainPageState();
}

class _BmailMainPageState extends State<BmailMainPage> {
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

      // Corrected input format with day of the week (EEE) and comma
      final inputFormat = DateFormat("EEE, d MMM yyyy HH:mm:ss Z");
      DateTime parsedDate = inputFormat.parse(dateString);

      // Extracting the time part with AM/PM format (hh:mm a)
      final outputFormat = DateFormat('hh:mm a');
      return outputFormat.format(parsedDate);
    } catch (e) {
      print('Error parsing date: $e');

      // Try to extract only the hours and minutes from the string if parsing fails
      final timeMatch = RegExp(r'\d{2}:\d{2}').firstMatch(dateString);
      return timeMatch != null ? timeMatch.group(0)! : 'Invalid Time';
    }
  }


  fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'name';
      _userId = prefs.getInt('user_id')?.toString() ?? 'userid';
      _userEmail = prefs.getString('user_email') ?? 'email';
    });
    print('User ID: $_userId'); // Debugging line
    print('User Email: $_userEmail'); // Debugging line
  }


  Future<void> _fetchEmails() async {
    final url = 'https://petdoctorindia.in/inbox';
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
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: Text('Sign Out',style: TextStyle(color: Colors.white),),
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
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _emails.isEmpty
                ? Center(child: Text('No emails found'))
                : ListView.builder(
              itemCount: _emails.length,
              itemBuilder: (context, index) {
                final email = _emails[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      border: Border.all(
                        color: Colors.white, // Border color
                        width: 2.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(12), // Make container circular
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // Shadow color with opacity
                          spreadRadius: 1, // How much the shadow spreads
                          blurRadius: 4, // How blurred the shadow is
                          offset: Offset(0, 2), // Offset of the shadow (horizontal, vertical)
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: CircleAvatar(
                        radius: 20, // Adjust size as needed
                        backgroundColor: Colors.grey.shade200, // Background color of CircleAvatar
                        child: Text(
                          email.subject.isNotEmpty ? email.subject[0].toUpperCase() : '', // First letter of email subject
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontSize: 16, // Text size
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(  // Wrap Text widget in Expanded to allow wrapping
                            child: Text(
                              email.subject.isNotEmpty ? email.subject : 'No Subject', // Full subject or fallback
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,  // Enables text wrapping
                              overflow: TextOverflow.ellipsis,  // Shows ellipsis if text is too long
                            ),
                          ),
                          SizedBox(width: 10),  // Add some space between the subject and the date
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
                      subtitle: Text(email.sender),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailDetailPage(email: email),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.secondaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComposePage()),
          );
        },
        child: Icon(Icons.edit,color: Colors.white,),
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


