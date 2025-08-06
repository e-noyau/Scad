include <BOSL2/std.scad>

// This makes for a minimal wallet.
// Inspired by https://n-o-d-e.net/wallet.html

// This was mostly done to add support for my own middle card, which hold one
// key and can also be used as money clip to wrap bills around. While I was at
// it I reimplemented the top and bottom.

// Size of the side indent used to push the cards out.
FINGER_ELIPSE = [15, 9];

// I like a slim wallet, but if you prefer something more chunky, you can bump up this number.
DEPTH = 1.5;

// Owner name
FIRST_NAME = "Contact↓";
LAST_NAME = "↓Info";

// Contact info
CONTACT_PHONE = "+33 (0)6 03 70 56 37";
// Email
EMAIL = "eric@noyau.net";


// The font used to render the text. See Help/Font List in OpenSCAD for the list of available fonts.
FONT = "calibri:style=bold";

// Font size, in points. Will be divided by two to make two lines on the back of the tag.
FONT_SIZE = 5;


/* [Hidden] */
// Size of a credit card
LENGTH = 85.6;
WIDTH = 53.98;

// Generic size for the elastic.
ELASCTIC_WIDTH = 31;
ELASCTIC_DEPTH = 1.1;

$fs = .2;
$fa = 3;

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

module embeddedText() {
  first_name_size = textmetrics(text = FIRST_NAME, size = FONT_SIZE, font = FONT).size;
  last_name_size = textmetrics(text = LAST_NAME, size = FONT_SIZE, font = FONT).size;
  max_name_height = max(first_name_size[1], last_name_size[1]);

  depth = DEPTH - .2;
  up(.21)
  color([ .2,  .2, .2]) union() {
    union() back(WIDTH/2 - max_name_height - (WIDTH-ELASCTIC_WIDTH)/8) {
      skip = (LENGTH-FINGER_ELIPSE[0])/4 + FINGER_ELIPSE[0]/2;
      left(skip) text3d(text = FIRST_NAME, size = FONT_SIZE, font = FONT, h = depth, anchor = BOTTOM);
      right (skip) text3d(text = LAST_NAME, size = FONT_SIZE, font = FONT, h = depth, anchor = BOTTOM);
    }
    skew =  ELASCTIC_WIDTH / 5;
    back(skew) text3d(text = CONTACT_PHONE, size = FONT_SIZE, font = FONT, h = depth, atype = "ycenter", anchor = CENTER+BOTTOM);
    fwd(skew) text3d(text = EMAIL, size = FONT_SIZE, font = FONT, h = depth, atype = "ycenter", anchor = CENTER+BOTTOM);
  }
}

// The top of the wallet.
module WalletTop() {
  difference() {
    linear_extrude(height = DEPTH, convexity = 3) WalletBase2D();
    embeddedText();
  }
  if(false) { //$preview) {
    wave_texture = texture("wave_ribs");
    color([ .4,  .4, .4]) up(DEPTH + ELASCTIC_DEPTH) yrot(90) #linear_sweep(
      rect(size = [ELASCTIC_DEPTH, ELASCTIC_WIDTH]),
      h = LENGTH,
      texture = wave_texture,
      tex_size = [3,3],
      style = "concave",
      anchor = CENTER+RIGHT);
  }
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

module jmp4_key() {
  left(13.622) fwd(30.74) linear_extrude(2.3)
    difference() {
      import("JPM4x1200.svg", dpi = 500);
      import("JPM4x1200_hole.svg", dpi = 500);
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

    // Key imprint
    down(.01) right(7) fwd(10) zrot(-80) jmp4_key();
    // Key push hole 
    right(15) fwd(5.5) cyl(d=15,10);

  }
}

// At the top level so it van be exported directly as a 3dmf and printed in two colors.
ydistribute(spacing = WIDTH + 10) {
  //KeyCard();
  WalletTop();
  WalletBottom();
}
embeddedText();
