Sequence Game - Flutter Implementation
Overview
This is a Flutter implementation of the classic board game "Sequence". The game combines elements of card games and board games where players try to create sequences of 5 chips in a row (horizontally, vertically, or diagonally) on a 10x10 game board.

Features
Complete Game Logic: Implements all the rules of the Sequence game

AI Opponent: Features a smart AI opponent using a minimax algorithm with alpha-beta pruning

Visual Game Board: Beautifully rendered game board with card images and player/AI markers

Turn-Based Gameplay: Alternating turns between player and AI

Card Management: Handles card dealing, discarding, and hand management

Sequence Detection: Automatically detects completed sequences

Game State Tracking: Tracks sequences, remaining cards, and game progress

Move History: Keeps track of all moves made during the game

Responsive UI: Adapts to different screen sizes

Game Rules Implementation
Standard 10x10 Sequence board with corner wild spots

Two-eyed Jacks (wild cards that can place a chip anywhere)

One-eyed Jacks (wild cards that can remove an opponent's chip)

Sequence detection (5 in a row with wild spots counting for both players)

Two sequences needed to win

Automatic card discarding when no valid moves exist

Technical Details
AI Implementation
The AI uses a minimax algorithm with alpha-beta pruning to evaluate possible moves. It considers:

Immediate sequence completion

Potential future sequences

Board control (especially center positions)

Jack card usage

Opponent's potential moves

Code Structure
GameBoard: Main game widget that manages the UI and game state

PlayingCard: Custom widget for displaying cards

Move System: Handles player and AI moves with validation

Sequence Detection: Complex logic for detecting sequences in all directions

State Management: Uses Flutter's StatefulWidget for game state

How to Run
Ensure you have Flutter installed

Clone this repository

Run flutter pub get to install dependencies

Run flutter run to start the game

Dependencies
Flutter SDK

Material Design components (included with Flutter)

Screenshots
(Add screenshots of the game in action here)

Future Improvements
Multiplayer support (online/local)

Different difficulty levels for AI

Customizable board themes

Sound effects and animations

Tutorial mode for new players

License
This project is open-source and available under the MIT License.
