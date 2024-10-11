// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../view/bottom_navigation/gmail_page/bmail_main_page.dart';
// import '../view/bottom_navigation/gmail_page/bmail_sent.dart';
//
// class _BmailMainPageState extends State<BmailMainPage> {
//   List<Email> _sentEmails = [];
//   List<Email> _draftEmails = [];
//   List<Email> _trashEmails = [];
//   bool _isLoading = true;
//   String _errorMessage = '';
//   String _userName = 'name';
//   String _userEmail = 'email';
//   String _userId = 'userid';
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchEmails(); // Call to fetch email data on page load
//   }
//
//   Future<void> _fetchEmails() async {
//     // Fetching email data for Sent, Drafts, and Trash
//     try {
//       // Example API calls to fetch the emails for each category
//       final sentResponse = await _fetchEmailData('sent');
//       final draftResponse = await _fetchEmailData('draft');
//       final trashResponse = await _fetchEmailData('trash');
//
//       setState(() {
//         _sentEmails = sentResponse;
//         _draftEmails = draftResponse;
//         _trashEmails = trashResponse;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to fetch emails: $e';
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<List<Email>> _fetchEmailData(String category) async {
//     final url = 'https://apiv2.bmail.biz/inbox/$category';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'userId': _userId,
//         'email': _userEmail,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final emailResponse = EmailResponse.fromJson(json.decode(response.body));
//       return emailResponse.emails;
//     } else {
//       throw Exception('Failed to load $category emails');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         backgroundColor: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Drawer header with the logo
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade100,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Center(
//                 child: Image.asset(
//                   "assets/Bmail_Logo_Gif-full.gif",
//                   width: MediaQuery.of(context).size.width * .40,
//                   height: MediaQuery.of(context).size.width * .40,
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Divider(
//               thickness: 1,
//               color: Colors.grey.shade300,
//             ),
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   _createDrawerItem(
//                     icon: Icons.send,
//                     text: 'Sent',
//                     trailing: _sentEmails.length.toString(),  // Show sent email count
//                     onTap: () => _navigateTo(context, const BmailSent()),
//                   ),
//                   _createDrawerItem(
//                     icon: Icons.drafts,
//                     text: 'Drafts',
//                     trailing: _draftEmails.length.toString(),  // Show drafts email count
//                     onTap: () => _navigateTo(context, BmailDraftPage()),
//                   ),
//                   _createDrawerItem(
//                     icon: Icons.delete,
//                     text: 'Trash',
//                     trailing: _trashEmails.length.toString(),  // Show trash email count
//                     onTap: () => _navigateTo(context, const BmailTrashPage()),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: const Text("Inbox"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add, color: Colors.white),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ComposePage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _emails.isEmpty
//           ? Center(
//         child: Text(_errorMessage),
//       )
//           : ListView.builder(
//         itemCount: _emails.length,
//         itemBuilder: (context, index) {
//           final email = _emails[index];
//           return ListTile(
//             leading: CircleAvatar(
//               child: Text(email.sender[0].toUpperCase()),
//             ),
//             title: Text(email.subject),
//             subtitle: Text(_formatDate(email.date)),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EmailDetailPage(email: email),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _createDrawerItem({
//     required IconData icon,
//     required String text,
//     required String trailing,
//     required GestureTapCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(text),
//       trailing: Text(trailing),  // Display the number of emails dynamically
//       onTap: onTap,
//     );
//   }
// }
