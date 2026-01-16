// Measured thickness of a single card. 
CardThickness = .33;

// Separation between two decks one behind each other
SeparationCardCount = 20;

// Separation between two decks side by side.
SideSeparation = 18;

// Angle of the cards
angle = 40;

// Ignore, testing things
testing = 0;
testSlice = 0;

// Space available inside the box
BoxSize = [293, 210, 54];

// Size of the various cards. There are 3 types of cards in Kemble's cascade.
// Adding 1mm of space on the sides.
SpaceCardSize  = [88 + 1, 63, CardThickness];
SensorCardSize = [44 + 1, 63, CardThickness];
OtherCardSize  = [44 + 1, 63, CardThickness];

// How high the insert will be.
insertHeight = BoxSize.z * .3;

// All the decks that need to fit in the box, grouped by card size.
SpaceCardDecks = [
    ["Squadon1", 23],
    ["Wormhole1", 16],
    ["Tunnel1", 11],
    ["Asteroid1", 22],
    ["Fleet1", 16],
    ["Special", 3],
    ["Bosses", 4],
    ["Banshee", 8],
    ["Behemoth", 8],
    ["Cannonram", 4],
    ["Tundrageist", 8],
];

SensorDecks = [
    ["Sensor", 40],
    ["ShipMods", 17], // Not used with alternate player boards.
    ["Weapons", 17],
];

OtherDecks = [
    ["Mission", 8],
    ["Achievement", 22],
    ["PowerUp", 23],
    ["Score", 5],
];

// Returns the total number of cards in a deck. Use dot product to calculate fast.
function cardCountForDecks(decks) =
  [for(p=decks) 1]*[for(d=decks) d[1]] + (len(decks) - 1) * SeparationCardCount;

// Horizontal size taken by a slanted deck of cards.
function inclinedDeckThicknessForCardCount(angle, count) =
  (count * CardThickness) / cos(angle);

// Calculate the distance between two decks.
DeckSeparation = inclinedDeckThicknessForCardCount(angle, SeparationCardCount);

// Returns a vector of the horizontal positions to be applied for each subdecks.
// The returned vector length is one more than the passed in, to have the end position.
function positionsForDecks(angle, decks) =
  [for (a = 0, i = 0;  i <= len(decks); a = a + (i<len(decks) ? decks[i][1] : 0), i = i+1)
      inclinedDeckThicknessForCardCount(angle, a + (i<len(decks) ? i : i-1) * SeparationCardCount) + 1];

// Primitive to build a skewed cube. 
// * Skews a cube by the given angle along the y axis
// * Like a cube, size is a vector of three values [x,y,z]
module skewedCube(angle, size) {
  skew = sin(angle) * size.x / cos(angle);
  rotate([angle+90,0,90])
    translate([0, size.z/2,0])
      linear_extrude(v = [0, skew, size.x])
          square([size.y, size.z], center=true);
}

// Idealized size of a deck of card, based on its size and the number of cards
// in the deck.
// * size is a vector of three values [x,y, thickness] definining the size of a
//   card in that deck.
module cardDeck(angle, size, count) {
  skewedCube(angle, [count*size.z, size.x, size.y]);
}

// This take a full deck of cards, split it in subdecks, and then place them
// one behind each other.
// * size is a vector of three values [x,y,z] definining the size of a card in
//   that deck.
// * decks is a list of subdecks [name, count], count being the number of 
//   cards in this subdeck.
module PlacedDecks(angle, size, decks) {
  positions = positionsForDecks(angle, decks);
  for (deckIndex = [0: len(decks)-1]) {
    deck = decks[deckIndex];
    name = deck[0];
    count = deck[1];

    translate([positions[deckIndex], 0, 0])
      cardDeck(angle, size, count);
  }
  translate([-DeckSeparation/3,0,0])
    skewedCube(angle, [(cardCountForDecks(decks) + SeparationCardCount/3)*size.z, size.x - 28, size.y]);
}

// Generates text for each decks.
module textForDecks(angle, size, decks, textPosition) {
  positions = positionsForDecks(angle, decks);
  for (deckIndex = [0: len(decks)-1]) {
    deck = decks[deckIndex];
    name = deck[0];
    count = deck[1];
    translate([positions[deckIndex]+textPosition.x, textPosition.y, textPosition.z]) {
      rotate([0,0,-90]) color("red") linear_extrude(h=1, convexity = 3)
        text(text=name, size = DeckSeparation * .5, halign="right", valign = "center"); 
    }
  }
}

module allOrganizedDecks(angle) {
  AfterSpace = inclinedDeckThicknessForCardCount(angle,cardCountForDecks(SpaceCardDecks)+SeparationCardCount);
  AfterSensors = inclinedDeckThicknessForCardCount(angle,cardCountForDecks(SensorDecks)+SeparationCardCount);
  
  PlacedDecks(angle, SpaceCardSize, SpaceCardDecks);
  translate([AfterSpace,0, 0]) {
    translate([0, -(SensorCardSize.x + SideSeparation)/2, 0])
      PlacedDecks(angle, SensorCardSize, SensorDecks);
    translate([0, (SensorCardSize.x + SideSeparation)/2, 0])
        PlacedDecks(angle, OtherCardSize, OtherDecks);
  }
}

module allOrganizedText(angle) {
  AfterSpace = inclinedDeckThicknessForCardCount(angle,cardCountForDecks(SpaceCardDecks)+SeparationCardCount);
  AfterSensors = inclinedDeckThicknessForCardCount(angle,cardCountForDecks(SensorDecks)+SeparationCardCount);

  textForDecks(angle, SpaceCardSize, SpaceCardDecks, [20.5,32,insertHeight]);
  translate([AfterSpace,0, 0]) {
    translate([0, -(SensorCardSize.x + SideSeparation)/2, 0]) 
      textForDecks(angle, SensorCardSize, SensorDecks, [20.5,9.5,insertHeight]);
    translate([0, (SensorCardSize.x + SideSeparation)/2, 0])
      textForDecks(angle, OtherCardSize, OtherDecks, [20.5,9.5,insertHeight]);
  }
}

module boxInsert() {
  splitx = .55;
  holeLength = 74;
  border = 3;

  difference(){
    union() {
      // The insert for the box
      translate([0,-BoxSize.y * splitx / 2, 0]) 
        cube([BoxSize.x, BoxSize.y * splitx + SideSeparation ,insertHeight]);
      // All the text
      translate([-10, 0, 0])
        allOrganizedText(angle);
    }
  // Space for decks
  translate([3, 0, 3])
        allOrganizedDecks(angle);

  // A hole to drop the rest.
  translate([BoxSize.x - 3 -holeLength, -(BoxSize.y * splitx - 6)/2 , 3])
    cube([holeLength, BoxSize.y * splitx - 6 + SideSeparation ,BoxSize.z]);
  }
}

if(testing) {
  gap = SpaceCardSize.y*2;
  
  translate([0, 0 * gap, 0])
    boxInsert();

  translate([0, 2 * gap, 0]) {
    allOrganizedDecks(angle);
    allOrganizedText(angle);
  }

  side = inclinedDeckThicknessForCardCount(angle, SeparationCardCount);

  translate([0, 3 * gap, 0]) {
      PlacedDecks(angle, SpaceCardSize, SpaceCardDecks);
      for(i=positionsForDecks(angle, SpaceCardDecks)) {
        translate([i,SpaceCardSize.y/2,0])
          color("red") cube([5,5,5], center =true);
        translate([i+36.5,SpaceCardSize.y/2,50])
          color("blue") cube(side, center =true);
    }
  }
  translate([0, 4 * gap, 0]) 
      cardDeck(angle, SpaceCardSize, 20);
} else if (testSlice) {
  intersection() {
    boxInsert();
    translate([137.2,30,0]) cube([65,50,50], center = true);
  }
} else {
  boxInsert();
}
