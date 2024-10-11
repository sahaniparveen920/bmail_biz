import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Bmail/utils/custom_color.dart'; // Ensure this path is correct

class ForwordComposePage extends StatefulWidget {
  final String? email;
  final String? subject;
  const ForwordComposePage({super.key, this.email, this.subject});

  @override
  _ForwardComposePageState createState() => _ForwardComposePageState();
}

class _ForwardComposePageState extends State<ForwordComposePage> {
  final TextEditingController _forwardToController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _ccController = TextEditingController();
  final TextEditingController _bccController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool showCc = false;
  bool showBcc = false;

  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;

  @override
  void initState() {
    super.initState();

    // Debug print statements
    print('Initializing ForwordComposePage');
    print('Provided email: ${widget.email}');
    print('Provided subject: ${widget.subject}');

    if (widget.email != null) {
      // Extract the email and set the text controller
      _toController.text = _extractEmail(widget.email!);
    }

    if (widget.subject != null) {
      // Extract the subject and set the text controller
      _subjectController.text = _extractSubject(widget.subject!);
    }
  }




// Helper method to determine if we are forwarding an email
  bool _isForwardingEmail() {
    // Add your condition to check if the email should be pre-filled or not
    // For example, you might want to check if there's a specific flag or condition
    return widget.email != null;
  }
  bool _isForwardingSubject() {
    // Add your condition to check if the email should be pre-filled or not
    // For example, you might want to check if there's a specific flag or condition
    return widget.subject != null;
  }


  @override
  void dispose() {
    _forwardToController.dispose();
    _toController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
  }

  void _toggleBold() {
    setState(() {
      isBold = !isBold;
    });
  }

  void _toggleItalic() {
    setState(() {
      isItalic = !isItalic;
    });
  }

  void _toggleUnderline() {
    setState(() {
      isUnderline = !isUnderline;
    });
  }

  Future<void> _sendMail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');
    final String from = prefs.getString('user_email') ?? 'unknown@domain.com';

    final String forwardTo = _toController.text.trim(); // Use the user-entered email
    final String cc = _ccController.text.trim();
    final String bcc = _bccController.text.trim();
    final String subject = _subjectController.text.trim();
    final String message = _messageController.text.trim();

    if (userId == null) {
      Get.snackbar(
        'Error',
        'User ID is missing!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Ensure 'forwardTo' is not empty
    if (forwardTo.isEmpty) {
      Get.snackbar(
        'Error',
        'Please provide an email to forward to!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final Uri apiUri = Uri.parse('https://apiv2.bmail.biz/forward');

    try {
      final response = await http.post(
        apiUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userid': userId.toString(),
          'email': from,
          'forwardTo': forwardTo, // Corrected to use the _toController value
          'cc': cc,
          'bcc': bcc,
          'subject': subject,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Email forwarded successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to forward email! Status Code: ${response.statusCode}, ${response.body}',
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


  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      print('Picked file: ${file.name}');
      // Handle file actions
    } else {
      // User canceled the picker
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Picked image: ${image.path}');
      // Handle image actions
    }
  }

  String _extractSubject(String emailContent) {
    final RegExp subjectRegExp = RegExp(r'Subject:\s*(.*)', multiLine: true);
    final match = subjectRegExp.firstMatch(emailContent);
    if (match != null) {
      return match.group(1) ?? '';
    }
    return emailContent; // Return the content if no subject found
  }


  String _extractEmail(String text) {
    final RegExp emailRegExp = RegExp(r'<(.*?)>');
    final match = emailRegExp.firstMatch(text);
    return match != null ? match.group(1) ?? '' : text; // Return input if no email found
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.07;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.secondaryColor,
        title: Text('Compose'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            iconSize: iconSize,
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _toController,
                    decoration: InputDecoration(
                      labelText: 'To',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showCc = !showCc;
                    });
                  },
                  child: Text(
                    showCc ? 'Hide Cc' : 'Cc',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showBcc = !showBcc;
                    });
                  },
                  child: Text(
                    showBcc ? 'Hide Bcc' : 'Bcc',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            if (showCc)
              TextField(
                controller: _ccController,
                decoration: InputDecoration(
                  labelText: 'Cc',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            if (showBcc)
              TextField(
                controller: _bccController,
                decoration: InputDecoration(
                  labelText: 'Bcc',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            Divider(),
            SizedBox(
              height: 50.0, // Specify the height you want for the TextField
              child: TextField(
                controller: _forwardToController,
                decoration: InputDecoration(
                  labelText: 'Forward To',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none, // Changed to OutlineInputBorder for better height control
                ),
              ),
            ),
            SizedBox(height: 10.0), // Space between fields
            Divider(),
            SizedBox(
              height: 50.0,
              child: TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          items: [
                            DropdownMenuItem(
                              child: Text("Normal"),
                              value: "Normal",
                            ),
                            DropdownMenuItem(
                              child: Text("Heading"),
                              value: "Heading",
                            ),
                          ],
                          onChanged: (value) {},
                          hint: Text("Normal"),
                        ),
                        IconButton(
                          icon: Icon(Icons.format_bold),
                          iconSize: iconSize,
                          onPressed: _toggleBold,
                        ),
                        IconButton(
                          icon: Icon(Icons.format_italic),
                          iconSize: iconSize,
                          onPressed: _toggleItalic,
                        ),
                        IconButton(
                          icon: Icon(Icons.format_underline),
                          iconSize: iconSize,
                          onPressed: _toggleUnderline,
                        ),
                        IconButton(
                          icon: Icon(Icons.attach_file),
                          iconSize: iconSize,
                          onPressed: _pickFile,
                        ),
                        IconButton(
                          icon: Icon(Icons.image),
                          iconSize: iconSize,
                          onPressed: _pickImage,
                        ),
                      ],
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        style: _getTextStyle(),
                        decoration: InputDecoration(
                          hintText: 'Compose your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendMail,
        label: Text("Send", style: TextStyle(color: Colors.white)),
        icon: Icon(Icons.send, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}