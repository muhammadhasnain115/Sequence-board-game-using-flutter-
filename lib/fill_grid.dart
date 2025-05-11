
import 'card.dart';

List<PlayingCard?> fillGridManually() {
  List<PlayingCard?> cards = List.generate(100, (index) {
    if (index == 1) return PlayingCard(suit: 'diamonds', value: '6', eyes: 'nil');
    else if (index == 2) {
      return PlayingCard(suit: 'diamonds', value: '7'); // 3 of Clubs
    } else if (index == 3) {
      return PlayingCard(suit: 'diamonds', value: '8'); // 4 of Spades
    } else if (index == 4) {
      return PlayingCard(suit: 'diamonds', value: '9'); // 5 of Hearts
    } else if (index == 5) {
      return PlayingCard(suit: 'diamonds', value: '10'); // 6 of Diamonds
    } else if (index == 6) {
      return PlayingCard(suit: 'diamonds', value: 'Q'); // 7 of Clubs
    } else if (index == 7) {
      return PlayingCard(suit: 'diamonds', value: 'K'); // 8 of Spades
    } else if (index == 8) {
      return PlayingCard(suit: 'diamonds', value: 'A'); // 9 of Hearts
    }

    // Row 2 (indices 10-19)
    else if (index == 10) {
      return PlayingCard(suit: 'diamonds', value: '5'); // Jack of Clubs
    } else if (index == 11) {
      return PlayingCard(suit: 'hearts', value: '3'); // Queen of Spades
    } else if (index == 12) {
      return PlayingCard(suit: 'hearts', value: '2'); // King of Hearts
    } else if (index == 13) {
      return PlayingCard(suit: 'spades', value: '2'); // Ace of Diamonds
    } else if (index == 14) {
      return PlayingCard(suit: 'spades', value: '3'); // 2 of Clubs
    } else if (index == 15) {
      return PlayingCard(suit: 'spades', value: '4'); // 3 of Spades
    } else if (index == 16) {
      return PlayingCard(suit: 'spades', value: '5'); // 4 of Hearts
    } else if (index == 17) {
      return PlayingCard(suit: 'spades', value: '6'); // 5 of Diamonds
    } else if (index == 18) {
      return PlayingCard(suit: 'spades', value: '7'); // 6 of Clubs
    } else if (index == 19) {
      return PlayingCard(suit: 'clubs', value: 'A'); // 7 of Spades
    }

    // Row 3 (indices 20-29)
    else if (index == 20) {
      return PlayingCard(suit: 'diamonds', value: '4'); // 8 of Hearts
    } else if (index == 21) {
      return PlayingCard(suit: 'hearts', value: '4'); // 9 of Diamonds
    } else if (index == 22) {
      return PlayingCard(suit: 'diamonds', value: 'K'); // 10 of Clubs
    } else if (index == 23) {
      return PlayingCard(suit: 'diamonds', value: 'A'); // Jack of Spades
    } else if (index == 24) {
      return PlayingCard(suit: 'clubs', value: 'A'); // Queen of Hearts
    } else if (index == 25) {
      return PlayingCard(suit: 'clubs', value: 'K'); // King of Diamonds
    } else if (index == 26) {
      return PlayingCard(suit: 'clubs', value: 'Q'); // Ace of Clubs
    } else if (index == 27) {
      return PlayingCard(suit: 'clubs', value: '10'); // 2 of Spades
    } else if (index == 28) {
      return PlayingCard(suit: 'spades', value: '8'); // 3 of Hearts
    } else if (index == 29) {
      return PlayingCard(suit: 'clubs', value: 'K'); // 4 of Diamonds
    }

    // Row 4 (indices 30-39)
    else if (index == 30) {
      return PlayingCard(suit: 'diamonds', value: '3'); // 5 of Clubs
    } else if (index == 31) {
      return PlayingCard(suit: 'hearts', value: '5'); // 6 of Spades
    } else if (index == 32) {
      return PlayingCard(suit: 'diamonds', value: 'Q'); // 7 of Hearts
    } else if (index == 33) {
      return PlayingCard(suit: 'hearts', value: 'Q'); // 8 of Diamonds
    } else if (index == 34) {
      return PlayingCard(suit: 'hearts', value: '10'); // 9 of Clubs
    } else if (index == 35) {
      return PlayingCard(suit: 'hearts', value: '9'); // 10 of Spades
    } else if (index == 36) {
      return PlayingCard(suit: 'hearts', value: '8'); // Jack of Hearts
    } else if (index == 37) {
      return PlayingCard(suit: 'clubs', value: '9'); // Queen of Diamonds
    } else if (index == 38) {
      return PlayingCard(suit: 'spades', value: '9'); // King of Clubs
    } else if (index == 39) {
      return PlayingCard(suit: 'clubs', value: 'Q'); // Ace of Spades
    }

    // Row 5 (indices 40-49)
    else if (index == 40) {
      return PlayingCard(suit: 'diamonds', value: '2'); // 2 of Hearts
    } else if (index == 41) {
      return PlayingCard(suit: 'hearts', value: '6'); // 3 of Diamonds
    } else if (index == 42) {
      return PlayingCard(suit: 'diamonds', value: '10'); // 4 of Clubs
    } else if (index == 43) {
      return PlayingCard(suit: 'hearts', value: 'K'); // 5 of Spades
    } else if (index == 44) {
      return PlayingCard(suit: 'hearts', value: '3'); // 6 of Hearts
    } else if (index == 45) {
      return PlayingCard(suit: 'hearts', value: '2'); // 7 of Diamonds
    } else if (index == 46) {
      return PlayingCard(suit: 'hearts', value: '7'); // 8 of Clubs
    } else if (index == 47) {
      return PlayingCard(suit: 'clubs', value: '8'); // 9 of Spades
    } else if (index == 48) {
      return PlayingCard(suit: 'spades', value: '10'); // 10 of Hearts
    } else if (index == 49) {
      return PlayingCard(suit: 'clubs', value: '10'); // Jack of Diamonds
    }

    // Row 6 (indices 50-59)
    else if (index == 50) {
      return PlayingCard(suit: 'spades', value: 'A'); // Queen of Clubs
    } else if (index == 51) {
      return PlayingCard(suit: 'hearts', value: '7'); // King of Spades
    } else if (index == 52) {
      return PlayingCard(suit: 'diamonds', value: '9'); // Ace of Hearts
    } else if (index == 53) {
      return PlayingCard(suit: 'hearts', value: 'A'); // 2 of Diamonds
    } else if (index == 54) {
      return PlayingCard(suit: 'hearts', value: '4'); // 3 of Clubs
    } else if (index == 55) {
      return PlayingCard(suit: 'hearts', value: '5'); // 4 of Spades
    } else if (index == 56) {
      return PlayingCard(suit: 'hearts', value: '6'); // 5 of Hearts
    } else if (index == 57) {
      return PlayingCard(suit: 'clubs', value: '7'); // 6 of Diamonds
    } else if (index == 58) {
      return PlayingCard(suit: 'spades', value: 'Q'); // 7 of Clubs
    } else if (index == 59) {
      return PlayingCard(suit: 'clubs', value: '9'); // 8 of Spades
    }

    // Row 7 (indices 60-69)
    else if (index == 60) {
      return PlayingCard(suit: 'spades', value: 'K'); // 9 of Hearts
    } else if (index == 61) {
      return PlayingCard(suit: 'hearts', value: '8'); // 10 of Diamonds
    } else if (index == 62) {
      return PlayingCard(suit: 'diamonds', value: '8'); // Jack of Clubs
    } else if (index == 63) {
      return PlayingCard(suit: 'clubs', value: '2'); // Queen of Spades
    } else if (index == 64) {
      return PlayingCard(suit: 'clubs', value: '3'); // King of Hearts
    } else if (index == 65) {
      return PlayingCard(suit: 'clubs', value: '4'); // Ace of Diamonds
    } else if (index == 66) {
      return PlayingCard(suit: 'clubs', value: '5'); // 2 of Clubs
    } else if (index == 67) {
      return PlayingCard(suit: 'clubs', value: '6'); // 3 of Spades
    } else if (index == 68) {
      return PlayingCard(suit: 'spades', value: 'K'); // 4 of Hearts
    } else if (index == 69) {
      return PlayingCard(suit: 'clubs', value: '8'); // 5 of Diamonds
    }

    // Row 8 (indices 70-79)
    else if (index == 70) {
      return PlayingCard(suit: 'spades', value: 'Q'); // 6 of Clubs
    } else if (index == 71) {
      return PlayingCard(suit: 'hearts', value: '9'); // 7 of Spades
    } else if (index == 72) {
      return PlayingCard(suit: 'diamonds', value: '7'); // 8 of Hearts
    } else if (index == 73) {
      return PlayingCard(suit: 'diamonds', value: '6'); // 9 of Diamonds
    } else if (index == 74) {
      return PlayingCard(suit: 'diamonds', value: '5'); // 10 of Clubs
    } else if (index == 75) {
      return PlayingCard(suit: 'diamonds', value: '4'); // Jack of Spades
    } else if (index == 76) {
      return PlayingCard(suit: 'diamonds', value: '3'); // Queen of Hearts
    } else if (index == 77) {
      return PlayingCard(suit: 'diamonds', value: '2'); // King of Diamonds
    } else if (index == 78) {
      return PlayingCard(suit: 'spades', value: 'A'); // Ace of Clubs
    } else if (index == 79) {
      return PlayingCard(suit: 'clubs', value: '7'); // 2 of Spades
    }

    // Row 9 (indices 80-89)
    else if (index == 80) {
      return PlayingCard(suit: 'spades', value: '10'); // 3 of Hearts
    } else if (index == 81) {
      return PlayingCard(suit: 'hearts', value: '10'); // 4 of Diamonds
    } else if (index == 82) {
      return PlayingCard(suit: 'hearts', value: 'Q'); // 5 of Clubs
    } else if (index == 83) {
      return PlayingCard(suit: 'hearts', value: 'K'); // 6 of Spades
    } else if (index == 84) {
      return PlayingCard(suit: 'hearts', value: 'A'); // 7 of Hearts
    } else if (index == 85) {
      return PlayingCard(suit: 'clubs', value: '2'); // 8 of Diamonds
    } else if (index == 86) {
      return PlayingCard(suit: 'clubs', value: '3'); // 9 of Clubs
    } else if (index == 87) {
      return PlayingCard(suit: 'clubs', value: '4'); // 10 of Spades
    } else if (index == 88) {
      return PlayingCard(suit: 'clubs', value: '5'); // Jack of Hearts
    } else if (index == 89) {
      return PlayingCard(suit: 'clubs', value: '6'); // Queen of Diamonds
    }

    // Row 10 (indices 90-99)
    else if (index == 91) {
      return PlayingCard(suit: 'spades', value: '9'); // Ace of Spades
    } else if (index == 92) {
      return PlayingCard(suit: 'spades', value: '8'); // 2 of Hearts
    } else if (index == 93) {
      return PlayingCard(suit: 'spades', value: '7'); // 3 of Diamonds
    } else if (index == 94) {
      return PlayingCard(suit: 'spades', value: '6'); // 4 of Clubs
    } else if (index == 95) {
      return PlayingCard(suit: 'spades', value: '5'); // 5 of Spades
    } else if (index == 96) {
      return PlayingCard(suit: 'spades', value: '4'); // 6 of Hearts
    } else if (index == 97) {
      return PlayingCard(suit: 'spades', value: '3'); // 7 of Diamonds
    } else if (index == 98) {
      return PlayingCard(suit: 'spades', value: '2'); // 8 of Clubs
    }
    return null;
  });
  return cards;
}