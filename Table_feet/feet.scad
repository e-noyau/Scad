include <BOSL2/std.scad>
use <noyau/utils.scad>
include <BOSL2/metric_screws.scad>


module bolt() {
  // metric_bolt(size=8, headtype="hex", shank=20, l=20, orient=DOWN, anchor=TOP, $fn=100);
  // 14.3 way too small
  // 15.3 way too big
  
  cyl(d=14.7, h=40, anchor=BOTTOM, $fn=6);
}

module feet() {
  cyl(d1=40, d2=30, h=10, anchor=BOTTOM, $fn=100);
}

difference() {
  feet();
  up(4) bolt();
}

