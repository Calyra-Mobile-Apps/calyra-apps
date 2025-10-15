import 'dart:math';

import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    super.key,
    required this.brandName,
    required this.imageUrl,
    required this.logoPath,
    required this.onTap,
  });

  final String brandName;
  final String imageUrl;
  final String logoPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _BackgroundImage(
              imageUrl: imageUrl,
              fallbackLabel: brandName,
            ),
            const _GrainOverlay(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  logoPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({required this.imageUrl, required this.fallbackLabel});

  final String imageUrl;
  final String fallbackLabel;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withValues(alpha: 0.25),
        BlendMode.darken,
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: Text(
              fallbackLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GrainOverlay extends StatelessWidget {
  const _GrainOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GrainPainter(),
        ),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  _GrainPainter();

  static const int _particleCount = 1200;
  static final List<_GrainParticle> _particles = _generateParticles();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final minDimension = max(1.0, min(size.width, size.height));

    for (final particle in _particles) {
      paint.color = Colors.white.withValues(alpha: particle.opacity);
      final offset = Offset(
        particle.position.dx * size.width,
        particle.position.dy * size.height,
      );
      canvas.drawCircle(offset, particle.radiusFactor * minDimension, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  static List<_GrainParticle> _generateParticles() {
    final random = Random(1337);
    return List<_GrainParticle>.generate(_particleCount, (_) {
      final opacity = 0.015 + random.nextDouble() * 0.03;
      final radiusFactor = 0.002 + random.nextDouble() * 0.0015;
      return _GrainParticle(
        position: Offset(random.nextDouble(), random.nextDouble()),
        opacity: opacity,
        radiusFactor: radiusFactor,
      );
    });
  }
}

class _GrainParticle {
  const _GrainParticle({
    required this.position,
    required this.opacity,
    required this.radiusFactor,
  });

  final Offset position;
  final double opacity;
  final double radiusFactor;
}
