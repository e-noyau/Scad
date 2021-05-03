include <BOSL2/std.scad>
use <noyau/utils.scad>


HEIGHT = 84;
WIDTH = 104;

INSET = 1;

RIGHT_TO_SLOT_1 = 35.5;
RIGHT_TO_SLOT_2 = 72.4;
SLOT_WIDTH = 7.5;
SLOT_HEIGHT = 23;

SCREW_DIA = 3.5;
SCREW_DIA_TOP_LEFT = 4.2;

RIGHT_TO_SCREW = 10.8;
BOTTOM_TO_SCREW = 10.8;

SCREW_TO_SCREW_H = 78 - 2.5;
SCREW_TO_SCREW_V_RIGHT = 62.7;
SCREW_TO_SCREW_V_LEFT = 65.5;


INSET_LAYER_DEPTH = .9;
COVER_LAYER_DEPTH = .6;
CUTOUT_LAYER_DEPTH = 3;
TOP_LAYER_DEPTH = .9;
TOTAL_DEPTH = INSET_LAYER_DEPTH + COVER_LAYER_DEPTH + CUTOUT_LAYER_DEPTH + TOP_LAYER_DEPTH;

POWER_OFFSET = 18.2;

// print separate.
POST_HEIGHT = 1.5;
POST_DIA = 7.20;

module screw_hole(flare, depth) {
  cyl(h=depth * 2, d = SCREW_DIA, circum = true, orient = UP, anchor = UP+DOWN, $fn=10);
  if (flare)
    up(depth/2) zcyl(depth/2+.1, d1=SCREW_DIA, d2=9, anchor = DOWN, $fn=20);
}

module screw_holes(flare, depth) {
  down(1.3) union() {
  fwd(HEIGHT/2 - BOTTOM_TO_SCREW) 
  right(WIDTH/2 - RIGHT_TO_SCREW) 
      screw_hole(flare, depth);
      
  fwd(HEIGHT/2 - BOTTOM_TO_SCREW) 
  right(WIDTH/2 - RIGHT_TO_SCREW - SCREW_TO_SCREW_H)
      screw_hole(flare, depth);
  
  fwd(HEIGHT/2 - BOTTOM_TO_SCREW - SCREW_TO_SCREW_V_RIGHT) 
  right(WIDTH/2 - RIGHT_TO_SCREW)
      screw_hole(flare, depth);
  
  fwd(HEIGHT/2 - BOTTOM_TO_SCREW- SCREW_TO_SCREW_V_LEFT)
  right(WIDTH/2 - RIGHT_TO_SCREW - SCREW_TO_SCREW_H)
      screw_hole(flare, depth);
}}

module slot(inset, depth) {
  up(depth/2) cuboid([SLOT_WIDTH + inset*2, SLOT_HEIGHT + inset, depth*2], anchor = FRONT);
}

module slots(depth, inset = 0) {
  fwd(HEIGHT/2) right(WIDTH/2 - RIGHT_TO_SLOT_1- SLOT_WIDTH/2) slot(inset, depth);
  fwd(HEIGHT/2) right(WIDTH/2 - RIGHT_TO_SLOT_2- SLOT_WIDTH/2) slot(inset, depth);
}

module cutout(depth) {
  fwd(HEIGHT/2 - 25)
  right(WIDTH/2 - 25) 
    down(depth/2) cuboid([7, 50, depth * 2], anchor = BOTTOM+FRONT);
}

module power(depth) {
  down(depth/2)
  difference() {
    union() {
      left(POWER_OFFSET)
        cyl(r=25, h=depth*2, anchor = BOTTOM, $fn=200);
      right(14) back(17+8) cuboid([30, 16, depth*2], anchor = BOTTOM);
      left(3.8) back(21.7) zrot(45) cuboid([20, 12, depth*2], anchor = BOTTOM);
    };
    left(POWER_OFFSET)
      cyl(r=2.5, h=depth*2, anchor = BOTTOM);
  }
}

module body(depth, inset=0, slots = false, cutout = false, power = false) {
  width  = WIDTH  - inset * 2;
  height = HEIGHT - inset * 2;
  difference () {
    cuboid([width, height, depth], rounding = 6, edges = edges("Z", except=LEFT), anchor = BOTTOM);
    if (slots) slots(inset, depth);
    if (cutout) cutout(depth);
    if (power) power(depth);
  }
}

module layer1() {
  down(INSET_LAYER_DEPTH+COVER_LAYER_DEPTH)
    body(depth = INSET_LAYER_DEPTH, inset = INSET, slots = true, cutout = true);
  down(COVER_LAYER_DEPTH)
    body(depth=COVER_LAYER_DEPTH, cutout = true);
}

module imprint() {
  body(depth=.20, power=true, cutout = true);
}

module quad_lock() {
  quad_lock_height = 5;
  difference() {
    union() {
      up(5) xrot(90) import("Quad_Lock_Screw.stl");
      cyl(r1=5,r2= 15, h=quad_lock_height, anchor = BOTTOM);
      cyl(r1=11.5,r2=13.7, h=quad_lock_height-2, anchor = BOTTOM, $fn = 200);
    };
    cyl(r=20, h=20, anchor=TOP);
  }
}

module layer2() {
  body(depth=CUTOUT_LAYER_DEPTH, power=true, cutout = true);
  up(CUTOUT_LAYER_DEPTH) body(depth=TOP_LAYER_DEPTH);
  up(CUTOUT_LAYER_DEPTH+TOP_LAYER_DEPTH-.9) left(POWER_OFFSET) quad_lock();
}

module full_model() {
  difference() {
    union() {
      metal() layer1();
      layer2();
    }
    screw_holes(flare=true, depth=TOTAL_DEPTH);
  }
}

module oriented_full_layer1() {
  xrot(180) difference() {
    layer1();
    screw_holes(flare=false, depth=TOTAL_DEPTH);
  }
}

module oriented_full_layer2() {
  difference() {
    layer2();
    screw_holes(flare=true, depth=TOTAL_DEPTH);
  }
}

module oriented_full_imprint() {
  difference() {
    imprint();
    screw_holes(flare=false, depth=TOTAL_DEPTH);
  }
}

//back(HEIGHT/2+1) right(WIDTH/2+1) full_model();
fwd(HEIGHT/2+1) right(WIDTH/2+1)  oriented_full_layer2();
back(HEIGHT/2+1) left(WIDTH/2+1)  oriented_full_layer1();
fwd(HEIGHT/2+1)  left(WIDTH/2+1)  oriented_full_imprint();



