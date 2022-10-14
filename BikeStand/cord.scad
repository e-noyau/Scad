include <BOSL2/std.scad>
use <noyau/utils.scad>

cord_dia = 6;
knots_dia = cord_dia * 2.2;
height = 30;
thickness = 2;

module inside() {
  mirror_copy([1, 0, 0]) left(cord_dia/2.5)
    cyl(d1=knots_dia, d2=cord_dia, h = height, anchor = BOTTOM);
}

module outside() {
  difference() {
    hull() mirror_copy([1, 0, 0]) left(cord_dia/2.5)
      cyl(d1=knots_dia+thickness, d2=cord_dia+thickness, h = height - .2, anchor = BOTTOM);
    
    down(.1) inside();
  }
}

outside($fn=64);

