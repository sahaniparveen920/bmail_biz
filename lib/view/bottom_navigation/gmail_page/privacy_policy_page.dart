import 'package:flutter/material.dart';


class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.chevron_left_outlined),
              SizedBox(width: 30,),
              const Text('Privacy Policy'),
            ],
          ),
          backgroundColor: Colors.blueAccent, // Customize AppBar color
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Add padding for better spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Introduction',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'At Bmail, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy outlines the types of data we collect, how we use it, and the measures we take to safeguard your information.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Information We Collect',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Personal Information:\nWhen you sign up for Bmail, we collect your name, email address, phone number, and other necessary details to create and maintain your account.\n\n'
                    '2. Usage Data:\nWe collect information about how you use Bmail, including your interactions with emails, time spent on the platform, and other related activities.\n\n'
                    '3. Device Information:\nWe may collect data related to the devices you use to access Bmail, such as IP address, browser type, operating system, and device identifiers.\n\n'
                    '4. Cookies and Similar Technologies:\nWe use cookies to enhance your experience on Bmail, such as remembering your login details and customizing content. You can manage your cookie preferences through your browser settings.',
              ),
              const SizedBox(height: 16),
              const Text(
                'How We Use Your Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Service Delivery:\nYour personal information is used to provide and maintain your Bmail account, send and receive emails, and ensure a seamless user experience.\n\n'
                    '2. Security:\nWe use the data collected to monitor and enhance the security of Bmail, protecting your account from unauthorized access and potential threats.\n\n'
                    '3. Improvement of Services:\nWe analyze usage data to understand user behavior, improve our services, and develop new features.\n\n'
                    '4. Communication:\nWe may use your email address to send you updates, security alerts, and other important notices related to your Bmail account.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Sharing of Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Third-Party Services:\nWe may share your information with trusted third-party service providers who assist us in operating Bmail, such as cloud storage and data analysis services. These providers are bound by confidentiality agreements and are not permitted to use your information for any other purpose.\n\n'
                    '2. Legal Requirements:\nWe may disclose your information if required by law, to comply with legal processes, or to protect the rights and safety of Bmail and its users.\n\n'
                    '3. Business Transfers:\nIn the event of a merger, acquisition, or sale of Bmail, your information may be transferred as part of the transaction. We will notify you of any changes to the ownership or use of your personal data.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Your Choices',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Account Settings:\nYou can manage your personal information, update your preferences, and control the visibility of your profile through your Bmail account settings.\n\n'
                    '2. Data Retention:\nWe retain your information for as long as necessary to provide the Bmail service. You may request the deletion of your account and associated data at any time.\n\n'
                    '3. Marketing Communications:\nYou can opt out of receiving marketing emails from Bmail by following the unsubscribe link in any promotional email or by adjusting your preferences in your account settings.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Security Measures',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'We implement robust security measures to protect your information, including encryption, regular security audits, and secure data storage. Despite our efforts, no online service is completely secure, and we cannot guarantee the absolute security of your data.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Children\'s Privacy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bmail is not intended for use by individuals under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware of such information, we will take steps to delete it promptly.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Changes to This Privacy Policy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'We may update this Privacy Policy periodically to reflect changes in our practices or legal requirements. We will notify you of any significant updates via email or through a notice on our platform. Your continued use of Bmail after any changes constitutes your acceptance of the revised policy.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'If you have any questions or concerns about these Privacy Policy, please contact us at support@bmail.biz.',
              ),
            ],
          ),
        ),
      );
    }

   

}