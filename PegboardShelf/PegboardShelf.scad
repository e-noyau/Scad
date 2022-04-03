include <BOSL2/std.scad>

preview = false;

HEIGHT = 60;
PLANK_WIDTH = 50;
PLANK_DEPTH = 4;
MARGIN = 6;
DEPTH = 7;

HOOK_ANGLE = 49;

WIDTH = PLANK_WIDTH + MARGIN * 2;

module right_triangle(side1,side2,corner_radius,triangle_height, hole) {
  $fn = 50;
  translate([corner_radius,corner_radius,0]) {  
    hull() {
      cyl(r=corner_radius,h=triangle_height);
      translate([side1 - corner_radius * 2,0,0])
          cyl(r=corner_radius,h=triangle_height);
      if (hole)
        translate([hole,side2 - corner_radius * 2,0])
          cyl(r=corner_radius,h=triangle_height);  
      translate([0,side2 - corner_radius * 2,0])
          cyl(r=corner_radius,h=triangle_height);  
    }
  }
}

module hook() {
  back(2) up(PLANK_DEPTH+MARGIN) zrot(90) xrot(90)
  import("Pegboard_Hook.stl");
}

module fake_hook() {
  $fn=50;
  fwd(1) left(1) cuboid([37, 2, 4], anchor=LEFT);
  yrot(90) cyl(d=4, h=37, anchor=BOTTOM);
  zrot(HOOK_ANGLE) yrot(90) cyl(d=4, h=50);
}

module side() {
  $fn = 50;
  yrot(-90) difference() {
    right_triangle(HEIGHT,WIDTH,3,DEPTH, PLANK_DEPTH + MARGIN);
    translate([MARGIN, MARGIN, 0]) 
        cuboid([PLANK_DEPTH, PLANK_WIDTH, DEPTH * 2], anchor=LEFT+FRONT);
    back(2) right(PLANK_DEPTH+MARGIN) fake_hook();
    right(HEIGHT/2) cyl(d=HEIGHT/3, h=DEPTH*2);
    if (preview)
      cuboid([200, 200, 50], anchor=TOP);
  }
}



if (preview) {
  side();
  #hook();
} else {
  yrot(90) side();
}