include <BOSL2/std.scad>
use <noyau/utils.scad>

$fn=100;

DEPTH=15;

DIA_TOP=48;
DIA_BOTTOM=25;
DIA_PIN=10;

module raindrop(h, d){
  angle = 20;
  down(h/2) union() {
    cylinder(h = h, d = d);
	  linear_extrude(height = h)
	    polygon(points=[[d/2 * -cos(angle), d/2 * sin(angle)],
                      [d/2 * cos(angle), d/2 * sin(angle)],
                      [0, d/2 * 2.2]],
              paths=[[0,1,2]]);
  }
}



module feet() {
  cyl(h=DEPTH+.1, d=DIA_PIN, anchor=BOTTOM);
  cyl(h=150, d1=DIA_BOTTOM, d2=DIA_TOP, anchor = TOP);
}

module support() {
  wall = 4;
  squeeze = wall - DIA_PIN/2 + .5;
  difference() {
    union() {
      cyl(h=DEPTH, d=DIA_PIN + wall, anchor=BOTTOM);
      fwd(squeeze) cuboid([DIA_TOP, wall, DEPTH], anchor=BOTTOM+FRONT, rounding = 2, edges="Z");
    }
    cyl(h=DEPTH, d=DIA_PIN, anchor=BOTTOM);
    cuboid([DIA_PIN, DIA_TOP/2, DEPTH+.1], anchor=BOTTOM+FRONT);
    fwd(squeeze-wall) cuboid([DIA_TOP, DIA_TOP/2, DEPTH+.1], anchor=BOTTOM+FRONT);
    up(DEPTH/2) line_of(DIA_TOP/1.5) xrot(90)
      union() {
        raindrop(h=100, d=4);
        up(15) up(25) raindrop(h=50, d=7);
      };
  }
}


//raindrop(100, 4);
metal() feet();
support();