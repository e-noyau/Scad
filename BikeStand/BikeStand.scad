include <BOSL2/std.scad>
use <noyau/utils.scad>


tire_dia = 67;
outside_dia = tire_dia*1.14; // With a .6 nozzle, makes it a perfect 6 lines.

module support2d($fn=300) {
  difference() {
    circle(d=outside_dia);
    circle(d=tire_dia);
    back(tire_dia/2) circle(r=tire_dia/2, $fn=4);;
  }
  back(26.2) mirror_copy([1,0,0]) translate([tire_dia/2 - 6.68, 0, 0]) circle(4);
  difference() { 
    fwd(tire_dia/2) square([60, 20], center=true);
    circle(d=tire_dia);
  }
}


difference() {
  height = 25;
    down(height/2) linear_extrude(height = height) support2d();
    mirror_copy([1,0,0]) left(18) xrot(90) cyl(d=7, h=50, $fn=100, anchor = DOWN);
    #mirror_copy([1,0,0]) left(18) xrot(90) cyl(d=10, h=35, $fn=100, anchor = DOWN);
}