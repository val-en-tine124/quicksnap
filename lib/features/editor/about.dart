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
      appBar: AppBar(title: Center(child: Text("About QuickSnap")),),
      body: Column(
        crossAxisAlignment: .center,
        children: [
          Row(
            mainAxisAlignment: .center,
            children: [
              SelectableText(authorInfo),
              SelectableText(name, style: TextStyle(fontWeight: .bold),
              ),
            ],
          ),
          SizedBox(height:10),
          SelectableText(appInfo),
        
        ],
      ),
    );
  }
}
