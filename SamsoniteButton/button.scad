include <BOSL2/std.scad>
use <noyau/utils.scad>

// Replacement button for the broken handle lock on my yellow samsonite luggage.

LENGTH=31;
WIDTH=9;
HEIGHT=2.5;
SLIT_LENGTH=7;
SLIT_WIDTH=4;

BUTTON_HEIGHT=9.80;
BUTTON_LOW=5.5;
BUTTON_DIA=19;

BUTTON_RIDGE_HEIGHT=2.2;
BUTTON_RIDGE_DEPTH=.86;

SPRING_HOLE_HEIGHT=5;
SPRING_HOLE_DIA=11;
SPRING_HOLE_INNER_DIA=SPRING_HOLE_DIA-4.4;

ROD_HOLE_HEIGHT=6;
ROD_HOLE_DIA=3;

module wedged_cyl(d, h1, h2) {
  intersection (){
    cyl(d=d, h=h1, anchor=BOTTOM, $fn=100);
    union() {
      cuboid([d, d, h2], anchor=BOTTOM+CENTER);
      up(h2)
        wedge([d, d, h1-h2], anchor=BOTTOM+CENTER);
    }
  }
}

module wedged_tube(od, id, h1, h2) {
  intersection (){
    tube(od=od, id=id, h=h1, anchor=BOTTOM, $fn=100);
    union() {
      cuboid([od, od, h2], anchor=BOTTOM+CENTER);
      up(h2)
        wedge([od, od, h1-h2], anchor=BOTTOM+CENTER);
    }
  }
}


module holes() {
  difference() {
    union() {
      difference() {
        // Base
        cuboid([LENGTH, WIDTH, HEIGHT],
                anchor=BOTTOM+CENTER, rounding=WIDTH/3, $fn=100,
                edges=[LEFT+FRONT, LEFT+BACK, RIGHT+FRONT, RIGHT+BACK]);
        // slit
        left(LENGTH/2 - SLIT_LENGTH) down(HEIGHT/2)
              cuboid([SLIT_LENGTH+2, SLIT_WIDTH, HEIGHT*2], anchor=BOTTOM+RIGHT);
      }
      // Button
      wedged_cyl(d=BUTTON_DIA, h1=BUTTON_HEIGHT, h2=BUTTON_LOW);
      // Button ridge
      wedged_tube(od=BUTTON_DIA, id=BUTTON_DIA-BUTTON_RIDGE_DEPTH*2,
                  h1=BUTTON_HEIGHT+BUTTON_RIDGE_HEIGHT, h2=BUTTON_LOW+BUTTON_RIDGE_HEIGHT);
    }
    // Spring hole
    down(.01)
    tube(h=SPRING_HOLE_HEIGHT, od=SPRING_HOLE_DIA, id=SPRING_HOLE_INNER_DIA,
          anchor=BOTTOM, $fn=100);
    // rod hole
    down(.01)
    cyl(d=ROD_HOLE_DIA, h=ROD_HOLE_HEIGHT, anchor=BOTTOM, $fn=100);
  }
}

difference() {
  holes();
  //cuboid([100,100,100], anchor=LEFT+CENTER);
}
