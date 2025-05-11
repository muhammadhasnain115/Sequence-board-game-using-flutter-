import 'package:flutter/material.dart';

class PlayingCard {
  final String suit;
  final String value;
  final String eyes;
  final int? valueSize;
  final bool isSmall;

  PlayingCard({
    required this.suit,
    required this.value,
    this.eyes = "nil",
    this.valueSize ,
    this.isSmall = false,
  });

  String _getSuitIcon() {
    switch (suit) {
      case 'hearts':
        return "♥";
      case 'diamonds':
        return "♦";
      case 'clubs':
        return "♣";
      case 'spades':
        return "♠";
      default:
        return "♠";
    }
  }

  Widget buildCard(double size) {
    return Container(
      width: size,
      height: size * 1.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      child: Stack(
        children: [
          // Top left value
          Positioned(
            top: 2,
            left: 0,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: valueSize?.toDouble() ?? 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),

          // Center suit
          Center(

            child: Padding(
              padding: const EdgeInsets.only(bottom: 10,left: 10,top: 15,right: 0),
              child: Text(
                _getSuitIcon(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Eyes indicator at bottom
          if (eyes == "single eye")
            Positioned(
              bottom: 0,
              left: 0,
              child: Text(
                "👁️",
                style: TextStyle(fontSize: 15),
              ),
            ),
          if (eyes == "double eye")
            Positioned(
              bottom: 0,
              right: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("👁️", style: TextStyle(fontSize: 12)),
                  SizedBox(width: 4),
                  Text("👁️", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class CardCell extends StatelessWidget {
  final PlayingCard? card;
  final double size;

  const CardCell({Key? key, required this.card, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 1.4,
      decoration: BoxDecoration(
        color: card == null ? Colors.blueAccent[200] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: card != null ? card!.buildCard(size) : null,
    );
  }
}