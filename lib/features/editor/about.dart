import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:quicksnap/features/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("About QuickSnap"))),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/about_section_bg_2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            GlassBox(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  CustomImageButton(imagePath: "assets/icons/bmc-button.png",onTap: () {
                    launcher.launchUrl(Uri.parse(""));
                  }),
                  ImageCardButton(
                    color: Colors.white,
                    iconPath: "assets/icons/github.png",
                    imageText: "GitHub",
                    textSize: 20.0,
                    textBgColor: Colors.white,
                    textFgColor: Colors.black,
                    onTap: () {
                      launcher.launchUrl(Uri.parse("https://github.com/val-en-tine124"));
                    }
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GlassBox extends StatelessWidget {
  const GlassBox({super.key});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.0);
    return Center(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
          width: 300.0,
          height: 300.0,
          child: Stack(
            children: [
              //Blur effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(),
              ),
              Container(
                decoration: BoxDecoration(
                  border: .all(color: Colors.white.withValues(alpha: 0.2)),
                  borderRadius: borderRadius,
                  gradient: LinearGradient(
                    begin: .topLeft,
                    end: .bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.4),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
              AuthorInfo(),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthorInfo extends StatefulWidget {
  const AuthorInfo({super.key});

  @override
  State<AuthorInfo> createState() => _AuthorInfoState();
}

class _AuthorInfoState extends State<AuthorInfo> {
  late ValueNotifier<Color> color;
  late Timer timer;
  late Random randgen;
  @override
  void initState() {
    super.initState();
    color = ValueNotifier(Colors.blue);
    randgen = Random();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      List<Color> colorList = [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
      ];
      final nextInt = randgen.nextInt(7);
      color.value = colorList[nextInt];
    });
  }

  @override
  void dispose() {
    color.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .center,
      children: [
        ValueListenableBuilder(
          valueListenable: color,
          builder: (context, value, child) {
            return Center(
              child:
                  SelectableText(
                        "QuickSnap",
                        style: TextStyle(
                          color: color.value,
                          fontWeight: .w400,
                          fontFamily: "Unageo",
                          fontSize: 30,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 3.seconds)
                      .then()
                      .shake(delay: 3.seconds, hz: 2, offset: Offset(5, 0)),
            );
          },
        ),
        Text(
          "A compact cross-platform text editor app.",
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: Colors.black.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 30.0),
        Row(
          children: [
            Text(
              "Coded by:",
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: .w600,
                color: Colors.black.withValues(alpha: 0.7),
              ),
            ),
            SelectableText(
              "   Abba Valentine Chibueze.",
              style: TextStyle(
                fontFamily: "ReThink-Sans",
                fontSize: 16,
                fontWeight: .w600,
                color: Colors.black.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
