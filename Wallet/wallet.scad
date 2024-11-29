include <BOSL2/std.scad>

// This makes for a minimal wallet.
// Inspired from https://n-o-d-e.net/wallet.html

// This was mostly done to add support for my own middle card, which hold one
// key and can also be used as money clip to wrap bills around. While I was at
// it I reimplemented the top and bottom.

// Size of the side indent used to push the cards out.
FINGER_ELIPSE = [15, 9];

// I like a slim wallet, but if you prefer something more chunky, you can bump up this number.
DEPTH = 1.5;

/* [Hidden] */
// Size of a credit card
LENGTH = 85.6;
WIDTH = 53.98;

// Generic size for the elastic.
ELASCTIC_WIDTH = 31;
ELASCTIC_DEPTH = 1.1;

$fs = .2;

// 2D version of the form used for all elements of the wallet.
module WalletBase2D(fingers = true, money_hole = false) {
  difference() {
    rect([LENGTH,WIDTH], rounding=3);
    mirror_copy([1,0,0]) left(LENGTH/2) rect([ELASCTIC_DEPTH*2, ELASCTIC_WIDTH]);
    if (fingers)
      mirror_copy([0,1,0]) fwd(WIDTH/2) ellipse(d = FINGER_ELIPSE);
    if (money_hole)
      fwd(23) rect([80,2.5], rounding=2.5/2);

  }
}

// The top of the wallet is really simple.
module WalletTop() {
  linear_extrude(height = DEPTH) WalletBase2D();
}

// The bottom has holes for sewing the elastic and a recess to hide it.
module WalletBottom() {
  up(DEPTH) xrot(180) difference() {
    linear_extrude(height = DEPTH, convexity = 2) WalletBase2D();
    // Hole in the middle
    cuboid([ELASCTIC_DEPTH*2, ELASCTIC_WIDTH, DEPTH*3]);
    // Sewing holes
    mirror_copy([1,0,0]) left(LENGTH *.34)
      ycopies(n = 9, l = ELASCTIC_WIDTH - 5)
        xcopies(l = 9) cuboid([1,1, DEPTH*3]);
    // Internal space for the elastic
    cuboid([LENGTH - 10, ELASCTIC_WIDTH, ELASCTIC_DEPTH*2]);
  }
}

// This is a rough approximation of the ISEO key I keep in my wallet.
module iseo_key() {
  l1 = 26.69;
  l2 = 15.61;
  depth = 3.2;
  left(6) difference() {
    union() {
      right(l2) union() {
        cuboid([l1,9.45,depth], anchor=LEFT+BOTTOM);
        right(.01) cuboid([l2,12.3,depth], anchor=RIGHT+BOTTOM);
      }
      right(0.02) {
        cuboid([4,12.3,depth], anchor=RIGHT+BOTTOM);
        cyl(d=28.52, h=depth, anchor=RIGHT+BOTTOM);
      }
    }
    left(60 - (l1+l2) + depth) cyl(d=6, h=30);
  }
}

module KeyCard() {
  height = 3.6;
  up(height) xrot(180) difference() {
    linear_extrude(height = height, convexity = 3) WalletBase2D(fingers = false, money_hole = true);
    // Key imprint
    down(.01) left(6.5) back(13) zrot(10) iseo_key();
    // Key push hole 
    left(13) back(6) cyl(d=15,10);
  }
}

ydistribute(spacing = WIDTH + 10) {
  KeyCard();
  WalletTop();
  WalletBottom();
}

