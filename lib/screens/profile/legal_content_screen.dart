// Location: lib/screens/profile/legal_content_screen.dart

import 'package:flutter/material.dart';

class LegalContentScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalContentScreen({
    super.key,
    required this.title,
    required this.content,
  });

  List<Widget> _buildContent(String rawContent) {
    final List<Widget> children = [];

    final paragraphs = rawContent.split('\n\n');

    for (final paragraph in paragraphs) {
      if (paragraph.trim().isEmpty) continue;

      if (paragraph.trim().length < 60 && 
          (paragraph.startsWith('A.') || paragraph.startsWith('B.') || paragraph.startsWith('C.') || paragraph.startsWith('D.') || paragraph.startsWith('1.') || paragraph.startsWith('2.'))) {
        
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
            child: Text(
              paragraph.trim(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1B2A),
              ),
            ),
          ),
        );
      } 

      else {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              paragraph.trim(),
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        );
      }
    }
    
    children.add(const SizedBox(height: 50));
    
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildContent(content),
        ),
      ),
    );
  }
}

const String kTermsAndConditionsContent = """
By accessing or using the Calyra application, you agree to be bound by these Terms and Conditions ("Terms"). If you do not agree, you are not permitted to use the Application.

A. Use of the Application
1. Accuracy of Results: The Calyra Application provides Personal Color Analysis (PCA) and product recommendations as a tool and guide. Analysis results are estimates and may vary depending on lighting conditions, photo quality, and quiz answers. You are solely responsible for the decisions you make based on this analysis.
2. User Age: You represent that you are at least 15 years old or have the permission and supervision of a parent/guardian to use this Application.
3. Account Responsibility: You are responsible for maintaining the confidentiality of your account information, including your password. You agree to immediately notify Us of any unauthorized use of your account.

B. Content and Intellectual Property Rights
1. Ownership: All content, features, and functionality of the Application (including logo, design, code, and informational content) are the property of Calyra and are protected by copyright laws.
2. License to Use: You are granted a limited, non-exclusive, and non-transferable license to use the Application only for personal and non-commercial use.

C. Limitation of Liability
1. Third-Party Links: The Application may contain links to third-party websites or services (e.g., Shopee product links). We have no control over, and assume no responsibility for, the content, privacy policies, or practices of any third party.
2. Product Transparency: We do not guarantee the availability, price accuracy, or quality of products recommended through external links. All purchase transactions are the sole responsibility of you and the relevant third party (e.g., the seller on Shopee).
3. Indemnification: You agree to indemnify and hold Calyra harmless from any claims, demands, or losses arising from your use of the Application or your violation of these Terms.

D. Termination and Changes
1. Termination: We reserve the right to suspend or terminate your account and your access to the Application at Our sole discretion, without prior notice, if you violate these Terms.
2. Changes to Terms: We reserve the right to modify these Terms at any time. We will notify you of any changes by posting the new Terms on this page. By continuing to use the Application after the changes become effective, you agree to be bound by the revised Terms.
""";

const String kPrivacyPolicyContent = """
This Privacy Policy explains how Calyra ("We", "Application") collects, uses, and protects your personal information in relation to Personal Color Analysis and product recommendations.

A. Information We Collect
We collect the following data:
1. Identity & Profile Data: Name, email address, encrypted password, date of birth, and avatar photo path (stored in Firestore upon registration and profile update).
2. Personal Color Analysis Data (SENSITITIVE):
    * Selfie Photo: The photo you take using the "Face Scan" feature or your device's camera is used solely for Personal Color Analysis (PCA) purposes and will not be shared or used for advertising purposes.
    * Data Analysis Result: Results from the quiz and analysis (such as undertone, skintone, complete seasonal color results) are stored in your account's analysis history (in Firestore).
3. Automated Usage Data: Information automatically collected by third-party services (such as Firebase) including device type, operating system, and activity within the Application (for analytics and performance improvement purposes).

B. Use of Information
We use the collected data for the following purposes:
1. Providing Core Service: To perform Personal Color Analysis (PCA) and save the results to your History.
2. Personalization: To display product and makeup brand recommendations that best match your seasonal color results.
3. Account Security: To verify your identity, manage login, and secure the account from unauthorized access.
4. Service Improvement: To analyze usage trends in order to improve the accuracy of analysis and the quality of the application.

C. Data Storage & Security
1. Storage: All your personal data and analysis results are stored on the Firebase Firestore cloud service managed by Us, tied to your user ID.
2. Security: We are committed to protecting your data and have implemented security measures (such as password encryption) in accordance with industry standard best practices. However, no method of internet transmission is 100% secure.
3. Camera Access: The Application requires permission to access your device's camera to take a selfie as part of the Personal Color Analysis process. We do not record or access your camera without your active consent.

D. Sharing Information with Third Parties
1. External Links: This application provides links to third-party websites or services (such as Shopee) to facilitate purchasing recommended products. We are not responsible for the privacy practices or content on these third-party sites.
2. Legal Obligation: If required by law, court order, or authorized government authorities.
""";