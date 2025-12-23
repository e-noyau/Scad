// Measured thickness of a single card. 
CardThickness = .1;

DeckSeparation = 1;
SideSeparation = 3;

// Size of the various cards. There are 3 types of cards in Kemble's cascade.
SpaceCardSize = [8, 5];
SensorCardSize = [5, 4];
OtherCardSize = [4,3];

// All the decks that need to fit in the box
SpaceCardDecks = [
    ["Squadon1", 23],
    ["Wormhole1", 16],
    ["Tunnel1", 11],
    ["Asteroid1", 22],
    ["Fleet1", 16],
    ["Special", 3],
    ["BossWarning", 4],
    ["Boss1", 4],  // double check boss names and counts
    ["Boss2", 8],
    ["Boss3", 8],
    ["Boss4", 8],
];

SensorDecks = [
    ["Sensor", 40],
];

OtherDecks = [
    ["Mission", 8],
    ["Achievement", 22],
    ["PowerUp", 23],
    ["Score", 5],

    ["ShipMods", 17], // Not used with alternate player boards.
    ["Weapons", 17],
];

function cumulativeCountsForDecks(decks) = 
  [for (a = 0, i = 0;  i < len(decks); a = a + decks[i][1], i = i+1) a];
function cardCountForDecks(decks) =
  [for(p=decks) 1]*[for (d=decks) d[1]];

// Idealized size of a deck of card, based on its size and the number of cards in the
// deck. The size should be one of the known deck size.
module cardDeck(size, count) {
    angle = 30;
    height = count * CardThickness;
    
    skew = sin(angle) * height / sin(90-angle);
    rotate([angle-90,0,0])
      linear_extrude(v = [0,skew,height])
        square([size.x, size.y]);
}


module PlacedDecks(size, decks) {
    counts = cumulativeCountsForDecks(decks);
    echo(counts);
    for (deckIndex = [0: len(decks)-1]) {
        deck = decks[deckIndex];
        name = deck[0];
        count = deck[1];

        position = counts[deckIndex] * CardThickness + DeckSeparation * deckIndex;
        translate([0, position, 0]) cardDeck(size,count);
    }
}

PlacedDecks(SpaceCardSize, SpaceCardDecks);
translate([-SensorCardSize.x - SideSeparation,0,0]) {
  PlacedDecks(SensorCardSize, SensorDecks);
  translate([0, cardCountForDecks(SensorDecks) * CardThickness + DeckSeparation * len(SensorDecks), 0]) 
      PlacedDecks(OtherCardSize, OtherDecks);
}