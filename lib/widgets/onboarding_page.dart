import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon với hoa tiet đẹp
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 3,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 60),
              
              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              
              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
