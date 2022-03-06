include <BOSL2/std.scad>
use <noyau/utils.scad>


module support2d_2(dia = 67) {
  difference() {
    circle(d=dia*1.25);
    circle(d=dia);
    back(dia/1.5) zrot(45) square(dia, center=true);
  }
  back(28) mirror_copy([1,0,0]) translate([dia/2 - 7.3, 0, 0]) circle(7);
  difference() { 
    fwd(dia/2) square([68, 20], center=true);
    circle(d=dia);
  }
}


difference() {
    down(15) linear_extrude(height = 30) support2d_2();
    mirror_copy([1,0,0]) left(18) xrot(90) cyl(d=7, h=100);
    mirror_copy([1,0,0]) left(18) xrot(90) cyl(d=10, h=70);
}