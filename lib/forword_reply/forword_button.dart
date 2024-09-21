import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding

class ForwardButton extends StatelessWidget {
  final String userId;
  final String userEmail;

  const ForwardButton({required this.userId, required this.userEmail});

  Future<void> _handleForwardAction() async {
    final url = 'https://petdoctorindia.in/forward';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'userid': userId,
      'email': userEmail,
      'forwardTo': '',
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        // Handle success response
        print('Forward action successful');
      } else {
        // Handle failure response
        print('Failed to forward: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: _handleForwardAction,
      icon: Icon(Icons.forward, color: Colors.green),
      label: Text('Forward', style: TextStyle(color: Colors.green)),
    );
  }
}
