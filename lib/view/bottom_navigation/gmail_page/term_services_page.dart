import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class TermServicePage extends StatelessWidget {
  const TermServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Text('Terms of Service'),
          ],
        ),
        backgroundColor: Colors.blueAccent, // Customize your app bar color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Introduction",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Welcome to Bmail! These Terms of Service ('Terms') govern your use of Bmail, a mail service provided by B Cloud Web Services. By creating an account or using Bmail, you agree to be bound by these Terms. If you do not agree, please do not use our services.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSectionTitle("Account Registration and Responsibilities"),
            _buildSubSectionTitle("1. Eligibility"),
            _buildBodyText(
                "You must be at least 13 years old to create a Bmail account. By registering, you represent that you meet this age requirement."),
            _buildSubSectionTitle("2. Account Security"),
            _buildBodyText(
                "You are responsible for maintaining the confidentiality of your account information, including your password. Any activity that occurs under your account is your responsibility. If you suspect unauthorized use, please notify us immediately."),
            _buildSubSectionTitle("3. Account Information"),
            _buildBodyText(
                "You agree to provide accurate and complete information during registration and to keep your account details up to date."),
            SizedBox(height: 16),
            _buildSectionTitle("Use of Bmail"),
            _buildSubSectionTitle("1. Permitted Use"),
            _buildBodyText(
                "Bmail is intended for personal and professional email communication. You agree to use Bmail in compliance with applicable laws and not for any unlawful, harmful, or disruptive activities."),
            _buildSubSectionTitle("2. Prohibited Activities"),
            _buildBodyText(
                "You may not use Bmail to:\n\n• Send spam or unsolicited messages.\n• Distribute harmful software, including viruses and malware.\n• Engage in phishing, identity theft, or other fraudulent activities.\n• Infringe on the intellectual property rights of others.\n• Harass, abuse, or threaten others.\n• Violate the privacy of others."),
            _buildSubSectionTitle("3. Service Modifications"),
            _buildBodyText(
                "We reserve the right to modify, suspend, or discontinue Bmail or any part of our services at any time without notice. We are not liable for any loss or inconvenience caused by such changes."),
            SizedBox(height: 16),
            _buildSectionTitle("Content Ownership and License"),
            _buildSubSectionTitle("1. Your Content"),
            _buildBodyText(
                "You retain ownership of the content you create and send through Bmail. By using Bmail, you grant us a non-exclusive, worldwide, royalty-free license to store, transmit, and display your content as necessary to provide the service."),
            _buildSubSectionTitle("2. Our Content"),
            _buildBodyText(
                "All trademarks, logos, and service marks displayed on Bmail are the property of B Cloud Web Services or our licensors. You may not use these marks without our prior written permission."),
            _buildSubSectionTitle("3. Third-Party Content"),
            _buildBodyText(
                "Bmail may contain links to third-party websites or services. We are not responsible for the content or practices of these third parties, and your use of third-party services is at your own risk."),
            SizedBox(height: 16),
            _buildSectionTitle("Privacy"),
            _buildBodyText(
                "Your use of Bmail is also governed by our Privacy Policy, which explains how we collect, use, and protect your personal information. By using Bmail, you agree to the terms of our Privacy Policy."),
            SizedBox(height: 16),
            _buildSectionTitle("Termination"),
            _buildSubSectionTitle("1. Termination by You"),
            _buildBodyText(
                "You may delete your Bmail account at any time through your account settings. Upon termination, your right to use Bmail will cease immediately."),
            _buildSubSectionTitle("2. Termination by Us"),
            _buildBodyText(
                "We reserve the right to suspend or terminate your account if you violate these Terms, engage in prohibited activities, or if we believe it is necessary to protect the security and integrity of Bmail."),
            _buildSubSectionTitle("3. Effect of Termination"),
            _buildBodyText(
                "Upon termination, your access to Bmail will be revoked, and we may delete your account data. We are not responsible for retaining or recovering your content after termination."),
            SizedBox(height: 16),
            _buildSectionTitle("Disclaimers and Limitation of Liability"),
            _buildSubSectionTitle("1. Service Availability"),
            _buildBodyText(
                "Bmail is provided 'as is' and 'as available' without warranties of any kind. We do not guarantee that Bmail will be uninterrupted, secure, or error-free."),
            _buildSubSectionTitle("2. Limitation of Liability"),
            _buildBodyText(
                "To the maximum extent permitted by law, B Cloud Web Services shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of data, revenue, or profits arising from your use of Bmail."),
            _buildSubSectionTitle("3. Indemnification"),
            _buildBodyText(
                "You agree to indemnify and hold B Cloud Web Services harmless from any claims, liabilities, damages, or expenses arising from your use of Bmail or violation of these Terms."),
            SizedBox(height: 16),
            _buildSectionTitle("Changes to These Terms"),
            _buildBodyText(
                "We may update these Terms from time to time. If we make significant changes, we will notify you by email or by posting a notice on Bmail. Your continued use of Bmail after any changes constitutes your acceptance of the revised Terms."),
            SizedBox(height: 16),
            _buildSectionTitle("Governing Law and Dispute Resolution"),
            _buildBodyText(
                "These Terms are governed by and construed in accordance with the laws of India. Any disputes arising from or relating to these Terms or your use of Bmail will be resolved through binding arbitration in [Your Jurisdiction], except that you may assert claims in small claims court if your claims qualify."),
            SizedBox(height: 16),
            _buildSectionTitle("Contact Information"),
            _buildBodyText(
                "If you have any questions or concerns about these Terms, please contact us at support@bmail.biz."),
          ],
        ),
      ),
    );
  }

  // Helper widgets to structure content
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
