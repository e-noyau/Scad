include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn=100;

INSIDE_DIA=55;
INSIDE_HEIGHT = 34;
SHELLY_HEIGH = 16.7;
SHELLY_WIDTH = 45.7;
BASE_HEIGHT = 3;

inset = .25;


module notch() {
  left(3) cuboid([5, 2.5, 2.5], rounding=.5, anchor=LEFT+TOP);
}

module insert () {

  difference () {
    // Cylinder fittong inside the housing
    up(.01) cyl(d1=INSIDE_DIA-.3, d2=INSIDE_DIA, h=INSIDE_HEIGHT, anchor = BOTTOM);
    // rough estimate of the size of the Shelly button 
    cuboid([SHELLY_WIDTH, SHELLY_WIDTH, SHELLY_HEIGH],
           rounding=SHELLY_WIDTH/3, 
           except=[TOP, BOTTOM],
           anchor = BOTTOM);
  
    // Removing material not necessary
    zrot_copies(n=4) left(SHELLY_WIDTH/1.7) fwd(SHELLY_WIDTH/1.7)
    cuboid([SHELLY_WIDTH, SHELLY_WIDTH, INSIDE_HEIGHT-BASE_HEIGHT],
           rounding=SHELLY_WIDTH/3,
           except=[TOP, BOTTOM],
           anchor = BOTTOM);
  
    // Screw hole for fixing in place (4 is way too many, using only two is probably fine)
    zrot_copies(n=4)
      up(INSIDE_HEIGHT-BASE_HEIGHT)left(INSIDE_DIA*inset) back(INSIDE_DIA*inset) xrot(180)     
        screw_hole("M3", length=6, head="flat", anchor = TOP);
    
    // sockets to insert the locking pins
    zrot_copies(n=2) up(INSIDE_HEIGHT-4) right(INSIDE_DIA/2-1) scale(1.1) notch();

  }

}

up(INSIDE_HEIGHT) xrot(180) insert();

up(2.5) fwd(INSIDE_DIA/2+2) zrot_copies(n=2) left(3) scale([1.2,1,1]) notch();