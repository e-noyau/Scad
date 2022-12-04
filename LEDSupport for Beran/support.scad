include <BOSL2/std.scad>

module 2d_volume() {
  difference() {
    square([25,30]);
    right(25-18-3) back(30-18-3) square(18);
    back(30-18-3)  square([30-18, 18+3]);
    back(3) square([25-3, 30-18-3*3]);
  }
}

module support() {
yrot(90)
difference() {
  down(5) linear_extrude(10) 2d_volume();
  left(.1) fwd(.5) cuboid([15, 4, 6], anchor = LEFT+FRONT);
  back(1.5) right(15) xrot(90) cyl(d=6, h=4);

}
}

2d_volume();
//support();