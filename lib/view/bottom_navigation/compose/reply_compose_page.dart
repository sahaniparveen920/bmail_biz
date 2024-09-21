import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Bmail/utils/custom_color.dart'; // Make sure this import is correct

class ReplyComposePage extends StatefulWidget {
  final String? email; // Optional email parameter
  const ReplyComposePage({super.key, this.email});

  @override
  _ReplyComposePageState createState() => _ReplyComposePageState();
}

class _ReplyComposePageState extends State<ReplyComposePage> {
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
    if (widget.email != null) {
      _toController.text = _extractEmail(widget.email!);
    }
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

    final String to = _toController.text.trim();
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

    final Uri apiUri = Uri.parse('https://petdoctorindia.in/reply');

    try {
      final response = await http.post(
        apiUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userid': userId.toString(),
          'email': from,
          'replyTo': to,
          'replyBody': message,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Reply sent successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to send reply! Status Code: ${response.statusCode}, ${response.body}',
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
      // Handle the file as needed
    } else {
      // User canceled the picker
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Picked image: ${image.path}');
      // Handle the image as needed
    }
  }

  String _extractEmail(String text) {
    final RegExp emailRegExp = RegExp(r'<(.*?)>');
    final match = emailRegExp.firstMatch(text);
    return match != null ? match.group(1) ?? '' : '';
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.07; // Adjust size as per screen width

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.secondaryColor,
        title: Text('Compose'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            iconSize: iconSize, // Make icon responsive
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
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                labelStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
            Divider(),
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
