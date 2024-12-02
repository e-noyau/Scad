include <BOSL2/std.scad>
use <noyau/utils.scad>

// Door plate to install a switchbot lock on my entrance door.

$fn=50;

PLATE_LENGTH=220;
PLATE_WIDTH=40;
PLATE_HEIGHT=6;

PLATE_HOLE_DISTANCE=195;
PLATE_HOLE_DIAMETER=4.5;
PLATE_HOLE_RECESS_DIAMETER=7;
PLATE_HOLE_RECESS_DEPTH=3;

LOCK_LENGTH=116;
LOCK_WIDTH=54;
LOCK_ROUNDING=8;
LOCK_POSITION=11;

CYLINDER_DIA=20;
CYLINDER_WIDTH=13;
CYLINDER_BOTTOM=22;
CYLINDER_POSITION=30;

difference() {
  union () {
    // Plate
    cuboid([PLATE_WIDTH, PLATE_LENGTH, PLATE_HEIGHT], 
      rounding = PLATE_WIDTH/2, edges="Z");
      // Lock Base
    fwd(LOCK_POSITION) cuboid([LOCK_WIDTH, LOCK_LENGTH, PLATE_HEIGHT], 
      rounding = LOCK_ROUNDING, edges="Z", anchor=BACK);
  }
  
  // Screw holes
  mirror_copy([0, 1, 0]) fwd(PLATE_HOLE_DISTANCE/2)
    cyl(d = PLATE_HOLE_DIAMETER, h = PLATE_HEIGHT*2, 
      anchor = CENTER);
  // Screw hole recesses
  up(PLATE_HEIGHT/2 - PLATE_HOLE_RECESS_DEPTH) 
  mirror_copy([0, 1, 0]) fwd(PLATE_HOLE_DISTANCE/2)
    cyl(d = PLATE_HOLE_RECESS_DIAMETER, h = PLATE_HOLE_RECESS_DEPTH*2, 
      anchor = BOTTOM);
      
  //Cylinder
  fwd(CYLINDER_POSITION+CYLINDER_DIA/2) union () {
    cyl(d = CYLINDER_DIA, h = PLATE_HEIGHT*2, 
      anchor = CENTER);
    cuboid([CYLINDER_WIDTH, CYLINDER_BOTTOM+CYLINDER_DIA/2, PLATE_HEIGHT*2], 
      rounding = CYLINDER_WIDTH/2, edges="Z", anchor=BACK);
  }
}