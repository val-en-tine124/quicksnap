import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

// Darken background slightly for higher contrast against foreground elements
const Color kBackgroundColor = Color(0xFF0B0710);
const Color kPrimaryTextColor = Colors.white;
const Color kSecondaryTextColor = Color(0xFFC3B9CF);
// Make the frosted card a bit less translucent so it reads clearer on darkbg
const Color kCardBackgroundColor = Color.fromRGBO(40, 32, 50, 0.18);

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(child: Text("About QuickSnap")),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: kPrimaryTextColor.withValues(alpha: 0.5),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480,
        ), //create a BoxConstraint (parent of the Stack) box contraint of 480 pixels, required by the Stack
        child: Stack(
          alignment: .center,
          children: [
            const ParticleBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const GlassBox(),
                const SizedBox(height: 20.0),
                Wrap(
                  children: [
                    const Text(
                      "A tip will keep the product improving ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Gilroy",
                        fontStyle: FontStyle.italic,
                        fontWeight: .w300,
                        color: kSecondaryTextColor,
                      ),
                    ),
                    
                    const GentleRotatingQ(rotatingObject:"👇",size: 40.0,),
                  ],
                ),
                const SizedBox(height: 10.0,),
                const SupportButton(),
                const SizedBox(height: 50.0),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final ver = snapshot.hasData
                        ? '2026© QuickSnap v${snapshot.data!.version}+${snapshot.data!.buildNumber}'
                        : 'Not able to retrieve version';
                    return Text(
                      ver,
                      style: const TextStyle(
                        color: kSecondaryTextColor,
                        fontSize: 12,
                        fontFamily: 'Gilroy',
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SupportButton extends StatelessWidget {
  const SupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        launcher.launchUrl(
          Uri.parse('https://ko-fi.com/abbavalentine'),
          mode: launcher.LaunchMode.externalApplication,
        );
      },
      label: const Text(
        "Support",
        style: TextStyle(
          fontFamily: "Unageo",
          fontWeight: .w400,
          fontSize: 17,
          color: kSecondaryTextColor,
        ),
      ),
      icon: const Icon(
        FontAwesome.heart_circle_bolt_solid,
        color: kSecondaryTextColor,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        side: BorderSide(color: Colors.yellow, width: 2.0),
        shape: RoundedRectangleBorder(borderRadius: .circular(12.0)),
      ),
    );
  }
}

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});
  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final int _numberOfParticles = 40; // Reduced for a more subtle effect
  final Random _random = Random();
  // track time between frames for smooth motion (seconds)
  late double _lastTickSeconds;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _lastTickSeconds = DateTime.now().millisecondsSinceEpoch / 1000.0;
    _particles = List.generate(
      _numberOfParticles,
      (index) => _createParticle(),
    );
  }

  Particle _createParticle() {
    return Particle(
      position: Offset(_random.nextDouble(), _random.nextDouble()),
      radius: _random.nextDouble() * 1.5 + 0.5,
      // velocities are in normalized units per second (x: left/right, y: up/down)
      // give a gentle upward bias so particles slowly drift up the screen
      velocity: Offset(
        (_random.nextDouble() - 0.5) * 0.01,
        -(_random.nextDouble() * 0.02 + 0.002),
      ),
      lifespan: _random.nextDouble() * 8 + 4, // 4..12s
      isSharp: _random.nextDouble() > 0.4,
      maxLifespan: 0.0,
    )..maxLifespan = _random.nextDouble() * 8 + 4;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // compute actual delta time (seconds) since last frame for smooth
        final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
        final dt = (now - _lastTickSeconds).clamp(0.0, 0.05);
        _lastTickSeconds = now;

        for (var p in _particles) {
          // decrease lifespan by real time
          p.lifespan -= dt;
          // move according to velocity (velocity is per-second)
          p.position = Offset(
            p.position.dx + p.velocity.dx * dt,
            p.position.dy + p.velocity.dy * dt,
          );

          // when particle dies, respawn at bottom with new random life/velocity
          if (p.lifespan <= 0) {
            p.position = Offset(
              _random.nextDouble(),
              1.02 + _random.nextDouble() * 0.06,
            );
            p.lifespan = _random.nextDouble() * 8 + 4;
            p.maxLifespan = p.lifespan;
            // slight variation so new particle isn't identical
            p.velocity = Offset(
              (_random.nextDouble() - 0.5) * 0.01,
              -(_random.nextDouble() * 0.02 + 0.002),
            );
          }

          // wrap horizontally
          if (p.position.dx < -0.1) p.position = Offset(1.1, p.position.dy);
          if (p.position.dx > 1.1) p.position = Offset(-0.1, p.position.dy);
          // if particle floats too far above, move it back to bottom to keep counts stable
          if (p.position.dy < -0.2) {
            p.position = Offset(
              p.position.dx,
              1.02 + _random.nextDouble() * 0.06,
            );
          }
        }
        return CustomPaint(
          size: Size.infinite,
          painter: ParticlePainter(_particles),
        );
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  ParticlePainter(this.particles);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.width * 0.9,
    );
    final bgPaint = Paint()
      // Use a deeper radial tint with slightly higher opacity so edges stay dark
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF2A1726).withValues(alpha: 0.6),
          kBackgroundColor.withValues(alpha: 0),
        ],
      ).createShader(rect);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final paint = Paint();
    for (var p in particles) {
      final progress = 1.0 - (p.lifespan / p.maxLifespan);
      final opacity = max(0.0, -4 * (progress - 0.5) * (progress - 0.5) + 1);

      // Lower particle brightness so they don't wash out the dark background
      paint.color = Colors.white.withValues(alpha: opacity * 0.35);
      paint.maskFilter = p.isSharp
          ? null
          : MaskFilter.blur(BlurStyle.normal, p.radius * 2);

      canvas.drawCircle(
        Offset(p.position.dx * size.width, p.position.dy * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  Offset position;
  final double radius;
  Offset velocity;
  double lifespan;
  double maxLifespan;
  final bool isSharp;

  Particle({
    required this.position,
    required this.radius,
    required this.velocity,
    required this.lifespan,
    required this.maxLifespan,
    required this.isSharp,
  });
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
                  border: .all(color: Colors.white.withValues(alpha: 0.1)),
                  borderRadius: borderRadius,
                  color: kCardBackgroundColor,
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
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            ValueListenableBuilder(
              valueListenable: color,
              builder: (context, value, child) {
                return Center(
                  child: SelectableText(
                    "QuickSnap",
                    style: TextStyle(
                      color: color.value,
                      fontWeight: .w400,
                      fontFamily: "Unageo",
                      fontSize: 28,
                    ),
                  ),
                );
              },
            ),
            const GentleRotatingQ(rotatingObject: "❤️",),
          ],
        ),
        const Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,

          children: [
            Padding(
              padding: EdgeInsets.only(bottom:8.0),
              child: Text(
                "A compact cross-platform text editor app.",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Gilroy",
                  fontStyle: FontStyle.italic,
                  color: kSecondaryTextColor,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "Coded by:",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Gilroy",
                    fontStyle: FontStyle.italic,
                    color: kSecondaryTextColor,
                  ),
                ),
                SelectableText(
                  "   Abba Valentine Chibueze.",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Gilroy",
                    fontStyle: FontStyle.normal,
                    fontWeight: .w400,
                    color: kSecondaryTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 12.0, // Spacing when items wrap to the next line
          spacing: 12.0, // Horizontal spacing
          children: [
            // Maintainer opens GitHub account
            _InfoPill(
              icon: FontAwesome.github_brand,
              text: 'Maintainer',
              tooltip: "Follow him on Github",
              onTap: () {
                launcher.launchUrl(
                  Uri.parse('https://github.com/val-en-tine124'),
                  mode: launcher.LaunchMode.externalApplication,
                );
              },
            ),
            _InfoPill(
              icon: FontAwesome.linkedin_brand,
              text: 'Linkedln',
              tooltip: "Check him out on Linkedln",
              onTap: () {
                launcher.launchUrl(
                  Uri.parse('https://linkedin.com/in/valentine-abba-885b8139b'),
                  mode: launcher.LaunchMode.externalApplication,
                );
              },
            ),
            _InfoPill(
              icon: FontAwesome.telegram_brand,
              text: 'Telegram',
              tooltip: "Check him out on telegram",
              onTap: () {
                launcher.launchUrl(
                  Uri.parse('https://t.me/val_400'),
                  mode: launcher.LaunchMode.externalApplication,
                );
              },
            ),

            // Short label 'Email' opens mail composer
          ],
        ),
        const Spacer(),
        Text(
          "Enjoying QuickSnap ?",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Gilroy",
            fontStyle: FontStyle.normal,
            fontWeight: .w300,
            color: kSecondaryTextColor,
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? tooltip;
  final VoidCallback? onTap;
  const _InfoPill({
    required this.icon,
    required this.text,
    this.onTap,
    this.tooltip,
  });
  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min, // Important for Wrap widget
      children: [
        Icon(icon, color: kSecondaryTextColor, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: kSecondaryTextColor,
            fontSize: 13,
            fontFamily: 'Gilroy',
          ),
        ),
      ],
    );

    Widget result = InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: child,
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      result = Tooltip(message: tooltip!, child: result);
    }

    if (onTap == null) return child;

    return result;
  }
}

// A calming, natural-looking rotating flower using a sinusoidal motion.
class GentleRotatingQ extends StatefulWidget {
  final double size;
  final String rotatingObject;
  const GentleRotatingQ({this.size = 28,required this.rotatingObject, super.key});

  @override
  State<GentleRotatingQ> createState() => _GentleRotatingQState();
}

class _GentleRotatingQState extends State<GentleRotatingQ>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Slow, calming cycle. Repeats forever.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value; // 0..1
        // Sinusoidal rotation: small angle in radians (~ +/-9 deg)
        final angle = sin(t * 2 * pi) * (pi / 20);
        // Slight 'breathing' scale for softness
        final scale = 1 + 0.03 * sin(t * 2 * pi);
        // Gentle horizontal sway in logical pixels
        final dx = 2.0 * sin(t * 2 * pi);

        return Transform.translate(
          offset: Offset(dx, 0),
          child: Transform.rotate(
            angle: angle,
            child: Transform.scale(scale: scale, child: Text(widget.rotatingObject,style:TextStyle(fontSize: 15.0))),
          ),
        );
      },
    );
  }
}
