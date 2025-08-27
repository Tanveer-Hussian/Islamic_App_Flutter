import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; 

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  /// Function to open email app
Future<void> _launchEmail() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'tanveerchandio9298@gmail.com',
    query: 'subject=Islamic App Support&body=Assalamu Alaikum,',
  );

  try {
    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  } catch (e) {
    print("Error launching email: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(

      appBar: AppBar(
        title: const Text("About App"),
        centerTitle: true,
      ),
     
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// App Logo
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              child: Image.asset(
                "assets/quran.png",
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),

            /// App Name
            Text(
              "Islamic App",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),

            /// Version
            Text(
              "Version 1.0.0",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 20),

            /// Short Description
            Text(
              "This Islamic App is designed to make it easy for Muslims to access "
              "the Holy Quran, translations, prayer times, and Hijri calendar all "
              "in one place. Our mission is to help strengthen faith by providing "
              "authentic Islamic resources at your fingertips.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 25),

            /// Developer Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isDark ? Colors.grey[850] : theme.cardColor,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.green),
                title: const Text("Developed by"),
                subtitle: const Text("Tanveer Hussain"),
                trailing: Icon(Icons.email, color: theme.primaryColor),
                onTap: _launchEmail, // ✅ Tap opens email
              ),
            ),
            const SizedBox(height: 10),

            /// Contact Us
            ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: const Text("Contact Us"),
              subtitle: const Text("tanveerchandio9298@gmail.com"),
              onTap: _launchEmail, // ✅ Tap opens email
            ),
            const SizedBox(height: 30),

            /// Islamic Quote / Du'a
            Text(
              "“The best among you (Muslims) are those who learn the Qur’an and teach it.”\n"
              "— Prophet Muhammad ﷺ",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "© 2025 Islamic App. All rights reserved.",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
