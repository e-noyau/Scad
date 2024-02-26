include <BOSL2/std.scad>
use <noyau/utils.scad>

LENGTH=137;
WIDTH=10.90;
HEIGHT=6.03;
HEIGHT_TIP=4.82;
BUTTON_LENGTH=44.94;
BUTTON_MIN_LENGTH=41;
BUTTON_WIDTH=15.09;
BUTTON_HEIGHT=12.90;
HOLE_WIDTH=13.65;
HOLE_DIA=7.4;
HOLE_SEPARATION=84.3;

module holes() {
  difference() {
    union() {
      cuboid([LENGTH/2, WIDTH, HEIGHT],
              anchor=BOTTOM+RIGHT, rounding=WIDTH/3, $fn=100,
              edges=[LEFT+FRONT, LEFT+BACK]);
  
      cuboid([BUTTON_LENGTH/2, BUTTON_WIDTH, BUTTON_HEIGHT],
              anchor=BOTTOM+RIGHT, rounding=BUTTON_WIDTH/2.3, $fn=100,
              edges=[LEFT+FRONT, FRONT+TOP, BACK+TOP, LEFT+BACK]);
  
      left(HOLE_SEPARATION/2)
        cyl(d=HOLE_WIDTH, h=HEIGHT, anchor=BOTTOM, $fn=50);
    }
    left(HOLE_SEPARATION/2) union() {
      down(HEIGHT/2) cyl(d=HOLE_DIA, h=HEIGHT*2, anchor=BOTTOM, $fn=50);
      scale([1.1,1.1,1.01]) up(HEIGHT) xrot(180)
        wedge([WIDTH, (LENGTH-HOLE_SEPARATION)/2, HEIGHT-HEIGHT_TIP], anchor=BOTTOM+BACK, spin=-90);
    }
  }
}



zrot_copies(n=2)  
  holes();
