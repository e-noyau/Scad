// Measured thickness of a single card. 
CardThickness = 1;

DeckSeparation = 5;
SideSeparation = 5;

angle = 30;

// Space available inside the box
BoxSize = [300, 300, 30];

// Size of the various cards. There are 3 types of cards in Kemble's cascade.
SpaceCardSize = [100, 70, CardThickness];
SensorCardSize = [50, 70, CardThickness];
OtherCardSize = [40, 60, CardThickness];

// All the decks that need to fit in the box. There could be many subdeck per
// size of cards.
SpaceCardDecks = [
    ["Squadon1", 23],
    ["Wormhole1", 16],
    ["Tunnel1", 11],
    ["Asteroid1", 22],
    ["Fleet1", 16],
    ["Special", 3],
    ["BossWarning", 4],
    ["Banshee", 4],  // double check boss names and counts
    ["Cannonram", 8],
    ["Tundrageist", 8],
    ["Behemoth", 8],
];

SensorDecks = [
    ["Sensor", 40],
];

ShipDecks = [
    ["ShipMods", 17], // Not used with alternate player boards.
    ["Weapons", 17],
];

OtherDecks = [
    ["Mission", 8],
    ["Achievement", 22],
    ["PowerUp", 23],
    ["Score", 5],
];

// Returns the total number of cards in a deck.
function cardCountForDecks(decks) =
  [for(p=decks) 1]*[for (d=decks) d[1]];

// Horizontal size taken by a slanted deck of cards.
function inclinedDeckThicknessForCardCount(count) =
  (count * CardThickness) / cos(angle);

// Returns a list of the cumulative number of cards for each subdeck in the deck.
function cumulativeCountsForDecks(decks) = 
  [for (a = 0, i = 0;  i < len(decks); a = a + decks[i][1], i = i+1) a];

// Returns a list of positions to be applied for each subdecks.
function positionsForDecks(decks) =
  [for (a = 0, i = 0;  i < len(decks); a = a + decks[i][1], i = i+1)
      inclinedDeckThicknessForCardCount(a) + i * DeckSeparation];


// Idealized size of a deck of card, based on its size and the number of cards in the
// deck.
// * size is a vector of three values [x,y, thickness] definining the size of a card in that deck.
module cardDeck(size, count) {
    height = count * size.z;
    
    skew = sin(angle) * height / cos(angle);
    rotate([angle-90,0,0])
      linear_extrude(v = [0, skew, height])
        square([size.x, size.y]);
}

// This take a full deck of cards, split it in subdecks, and then place them
// one behind each other.
// * size is a vector of two values [x,y] definining the size of a card in
//   that deck.
// * decks is a list of subdecks [name, count], count being the number of 
//   cards in this subdeck.
module PlacedDecks(size, decks) {
    positions = positionsForDecks(decks);
    for (deckIndex = [0: len(decks)-1]) {
        deck = decks[deckIndex];
        name = deck[0];
        count = deck[1];

        translate([0, positions[deckIndex], 0])
            cardDeck(size,count);
    }
}

PlacedDecks(SpaceCardSize, SpaceCardDecks);
translate([0, inclinedDeckThicknessForCardCount(cardCountForDecks(SpaceCardDecks)) + DeckSeparation * len(SpaceCardDecks), 0]) {
    PlacedDecks(SensorCardSize, SensorDecks);
    translate([0, inclinedDeckThicknessForCardCount(cardCountForDecks(SensorDecks)) + DeckSeparation * len(SensorDecks), 0])
        PlacedDecks(OtherCardSize, ShipDecks);
    translate([SensorCardSize.x + SideSeparation, 0, 0]) 
      PlacedDecks(OtherCardSize, OtherDecks);
}

cube(BoxSize);