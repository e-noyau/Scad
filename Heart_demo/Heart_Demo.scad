include <BOSL2/std.scad>

// To make things more visible in openscad.
module black()  { color([.3, .3, .3]) children(); }
module orange() { color([ 1, .7,  0]) children(); }

// Quick way to make a heart
module 2d_heart(size) {
  half = size/2;
  fwd(5) zrot(-45) {
    square(size, center=true);
    mirror_copy([1,1,0]) translate([0, half, 0]) circle(half);
  }
}

// To make a small border around the heart
module 2d_heart_border(size) {
  difference() {
    2d_heart(size);
    2d_heart(size-1);
  }
}

// Make a heart with the name printed on it. Finetune the text size for the text to fit.
module heart(name, size = 20, textsize = 7) {
  black() linear_extrude(height = 1)
    2d_heart(size);
  orange() linear_extrude(height = 2) {
    text(name, halign="center", valign="center", size=textsize, font= "Comic Sans MS");
    2d_heart_border(size);
  }
}

// Build and arrange the badges for a set of names using a for loop. The inconvenient is that the
// text size must be tuned to the largest first name. 
module option_1() {
  names = [
    "Marie", "Thomas", "Camille", "Nicolas", "Léa", "Julien", "Manon", "Quentin", "Chloé",
    "Maxime", "Laura", "Alexandre", "Julie", "Antoine", "Sarah", "Kevin", "Pauline", "Clément",
    "Mathilde", "Romain", "Marine", "Pierre"];
  
  for (i = [0:1:len(names)-1])
    right(floor(i/5)*40) back(i%5*40) heart(names[i], textsize=4.5);
}

// Use BOSL2 distribution methods, which are unfortunately incompatible with a for loop.
module option_2() {
  xdistribute(spacing=30) {
    ydistribute(spacing=40) {
       heart("Marie");
       heart("Thomas", textsize=6);
       heart("Camille", textsize=6);
       heart("Nicolas", textsize=6);
    };
    ydistribute(spacing=40) {
       heart("Léa");
       heart("Julien");
       heart("Manon", textsize=6);
       heart("Quentin", textsize=5.5);
       heart("Chloé");
    };
    ydistribute(spacing=40) {
       heart("Maxime", textsize=5.5);
       heart("Laura");
       heart("Alexandre", textsize=4.5);
       heart("Julie");
    };
    ydistribute(spacing=40) {
       heart("Antoine", textsize=6);
       heart("Sarah");
       heart("Kevin");
       heart("Pauline", textsize=6);
       heart("Clément", textsize=5.5);
    };
    ydistribute(spacing=40) {
       heart("Mathilde", textsize=5);
       heart("Romain", textsize=6);
       heart("Marine", textsize=6);
       heart("Pierre", textsize=6);
    };
  }
}

//option_1();
option_2();
