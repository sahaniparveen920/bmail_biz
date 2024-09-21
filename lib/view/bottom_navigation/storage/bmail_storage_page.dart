import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:ui'; // Required for BackdropFilter

class BmailStoragePage extends StatefulWidget {
  BmailStoragePage({super.key});

  @override
  _BmailStoragePageState createState() => _BmailStoragePageState();
}

class _BmailStoragePageState extends State<BmailStoragePage> {
  bool _isHovered = false;

  final List<String> imagePaths = [
    'assets/storage/img_1.png',
    'assets/storage/img_2.png',
    'assets/storage/img_3.png',
    'assets/storage/img_4.png',
    'assets/storage/img_5.png',
    'assets/storage/img_6.png',
    'assets/storage/img_7.png',
    'assets/storage/img_8.png',
    'assets/storage/img_9.png',
    'assets/storage/img_10.png',
    'assets/storage/img_11.png',
    'assets/storage/img_12.png',
    'assets/storage/img_13.png',
    'assets/storage/img_14.png',
    'assets/storage/img_15.png',
    'assets/storage/img_16.png',
    'assets/storage/img_17.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF98ABF0), // Background color
      body: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: imagePaths.length,
            itemBuilder: (context, index, realIndex) {
              return Image.asset(
                imagePaths[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
            options: CarouselOptions(
              height: double.infinity,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              enlargeCenterPage: false,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0), // Minimal blur intensity
            child: Container(
              color: Colors.black.withOpacity(0.1), // Very low opacity for a lighter overlay
            ),
          ),
          Center(
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovered = false;
                });
              },
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.black, Colors.deepPurpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
