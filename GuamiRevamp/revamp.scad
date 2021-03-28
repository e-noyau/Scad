include <BOSL2/std.scad>
use <noyau/utils.scad>


HEIGHT = 84;
WIDTH = 104;
DEPTH = 2;

INSET = 1;

RIGHT_TO_SLOT_1 = 35.5;
RIGHT_TO_SLOT_2 = 72.4;
SLOT_WIDTH = 7;
SLOT_HEIGHT = 23;

SCREW_DIA = 3.5;
SCREW_DIA_TOP_LEFT = 4.2;

RIGHT_TO_SCREW = 10.8;
BOTTOM_TO_SCREW = 10.8;

SCREW_TO_SCREW_H = 78 - 2.5;
SCREW_TO_SCREW_V_RIGHT = 62.7;
SCREW_TO_SCREW_V_LEFT = 65.5;

// print separate.
POST_HEIGHT = 1.5;
POST_DIA = 7.20;

module screw_hole(flare, depth) {
  cyl(h=depth * 3, d = SCREW_DIA, circum = true, orient = UP, anchor = UP+DOWN, $fn=10);
  if (flare)
    up(depth/2) zcyl(depth/2+.1, d1=SCREW_DIA, d2=9, anchor = DOWN, $fn=20);
}

module screw_holes(flare, depth) {
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
}

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
  union() {
    left(18.5)
      cyl(r=25, h=depth*2, anchor = BOTTOM);
    right(14) back(17+8) cuboid([30, 16, depth*2], anchor = BOTTOM);
    left(3.8) back(21.7) zrot(45) cuboid([20, 12, depth*2], anchor = BOTTOM);
  };
}

module body(depth = DEPTH, inset=0, flare = false, slots = false, cutout = false, power = false) {
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
  inset_depth = .9;
  cover_depth = .6;
  
  down(inset_depth+cover_depth)
    body(depth = inset_depth, inset = INSET, slots = true, cutout = true);
  down(cover_depth)
    body(depth=cover_depth, cutout = true);
}

module imprint() {
  body(depth=.20, power=true, cutout = true);
}

module layer2() {
  quad_lock_height = 6.9;
  body(depth=3, power=true, cutout = true);
  up(3) body(depth=.3, flare=true);
  left(18.5) union() {
    up(quad_lock_height+3.3) xrot(90) import("Quad_Lock_Screw.stl");
    up(3.3) cyl(r=10, h=quad_lock_height-.1, anchor = BOTTOM);
  }
}

module full_model() {
  difference() {
    union() {
      layer1();
      layer2();
    }
    up(1.3) screw_holes(flare=true, depth=DEPTH);
  }
}

module oriented_full_layer1() {
  xrot(180) difference() {
    layer1();
    up(1.3) screw_holes(flare=false, depth=DEPTH);
  }
}

module oriented_full_layer2() {
  difference() {
    layer2();
    up(1.3) screw_holes(flare=true, depth=DEPTH);
  }
}

module oriented_full_imprint() {
  difference() {
    imprint();
    up(1.3) screw_holes(flare=false, depth=DEPTH);
  }
}

//back(HEIGHT/2+1) right(WIDTH/2+1) full_model();
fwd(HEIGHT/2+1) right(WIDTH/2+1)  oriented_full_layer2();
back(HEIGHT/2+1) left(WIDTH/2+1)  oriented_full_layer1();
fwd(HEIGHT/2+1)  left(WIDTH/2+1)  oriented_full_imprint();


module quadlock_body() {
  quad_lock_height = 6.9;
  union () {
    difference () {
      cuboid([WIDTH, HEIGHT, DEPTH], rounding = 6,
        edges = edges("Z", except=LEFT), anchor = BOTTOM);
      screw_holes();
    };
    up(quad_lock_height + DEPTH) xrot(90) import("Quad_Lock_Screw.stl");
    up(DEPTH-.1) cyl(r=10, h=quad_lock_height-.1, anchor = BOTTOM);
  }
}













//quadlock_body();

// intersection () {
//   quadlock_body();
//   left(15) cyl(r=10, h=20, anchor=BOTTOM);
// }

module hook() {
  HOOK_HEIGHT = DEPTH + 3.5;
  HOOK_DEPTH = 2;
  back(HEIGHT/2 - DEPTH/2) right(1/3*WIDTH/2-6)
      cuboid([2/3*WIDTH, DEPTH, DEPTH+18], rounding = DEPTH/2, edges = "Z", anchor = BOTTOM);
  back(HEIGHT/2 - HOOK_HEIGHT/2) right(1/3*WIDTH/2-6) up(DEPTH+18-HOOK_DEPTH)
      cuboid([2/3*WIDTH, HOOK_HEIGHT, HOOK_DEPTH], rounding = DEPTH/2, edges = "Z", anchor = BOTTOM);

}

module full() {
  body();
  hook();
}

module post() {
  difference() {
    zcyl(POST_HEIGHT, d = POST_DIA,  anchor = DOWN, $fn=10);
    down(.2) zcyl(POST_HEIGHT*2, d = SCREW_DIA, anchor = DOWN, $fn=20);
  }
}

//xrot(-90) fwd(HEIGHT/2) full();

//left(80) linear_extrude(1.21) circle(25);

