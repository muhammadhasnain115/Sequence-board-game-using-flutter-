import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'seq.dart'; // Import your game board page

void main() {
  runApp(SequenceGameApp());
}

class SequenceGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sequence Game',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade400,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game Title
              Text(
                'SEQUENCE',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 5,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The Board Game',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 50),

              // Play Button
              _buildMenuButton(
                context,
                'Play Game',
                Icons.play_arrow,
                Colors.green,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameBoard()),
                  );
                },
              ),

              SizedBox(height: 20),

              // How to Play Button
              _buildMenuButton(
                context,
                'How to Play',
                Icons.help_outline,
                Colors.blue,
                    () {
                  _showHowToPlayDialog(context);
                },
              ),

              SizedBox(height: 20),

              // About Button
              _buildMenuButton(
                context,
                'About',
                Icons.info_outline,
                Colors.orange,
                    () {
                  _showAboutDialog(context);
                },
              ),

              SizedBox(height: 50),

              // Footer
              Text(
                '© 2025 Sequence Game',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How to Play Sequence', style: TextStyle(color: Colors.deepPurple)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Game Objective:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Be the first to complete 2 sequences (5 in a row) on the board.'),
                SizedBox(height: 15),

                Text(
                  'Gameplay:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('1. Each player is dealt 5 cards.'),
                Text('2. On your turn, play a card from your hand and place a chip on the corresponding board space.'),
                Text('3. Jacks are wild:'),
                Text('   - Single-eyed Jacks (♣, ♦) remove an opponent\'s chip'),
                Text('   - Double-eyed Jacks (♠, ♥) can be placed anywhere'),
                Text('4. Draw a new card at the end of your turn.'),
                Text('5. First to complete 2 sequences wins!'),
                SizedBox(height: 15),

                Text(
                  'Corners:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('The four corners are wild spaces that count for all players.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Got it!', style: TextStyle(color: Colors.deepPurple)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Sequence Game', style: TextStyle(color: Colors.deepPurple)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('A digital adaptation of the classic Sequence board game.'),
              SizedBox(height: 15),
              Text('Version: 1.0.0'),
              Text('Developed with Flutter'),
              SizedBox(height: 15),
              Text('Made by ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              Text('Muhammad Hasnain',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              Text('Syed Shees Ali',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              Text('Ali Masood',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              SizedBox(height: 8), // Optional spacing
              InkWell(
                onTap: () {
                  // Replace with your actual LinkedIn URL
                  const url = 'https://www.linkedin.com/in/hasnain-altaf-8769a42a8?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app';
                  launchUrl(Uri.parse(url));
                },
                child: Text(
                  'Follow me on LinkedIn',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text('© 2025 All rights reserved'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close', style: TextStyle(color: Colors.deepPurple)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}