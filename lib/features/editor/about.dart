import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const authorInfo = "Coded by";
  static const name = "Abba Valentine Chibueze.";
  static const appInfo =
      "This is quicksnap a compact cross-platform text editor.";

  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: .center,
        children: [
          Center(child: SelectableText(authorInfo)),
          SizedBox(height:10),
          Center(
            child: SelectableText(name, style: TextStyle(fontWeight: .bold)),
          ),
          SizedBox(height:10),
          Center(child: SelectableText(appInfo)),
        
        ],
      ),
    );
  }
}
