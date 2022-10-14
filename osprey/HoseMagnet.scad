include <BOSL2/std.scad>
use <noyau/utils.scad>
$fn=100;

hose_height = 11.4;
depth = 1.2;

module magnet() {
  metal() up(.4) union() {
    cyl(d=10, h=1.7, anchor=BOTTOM);
    cuboid([10,10,1.7], anchor=BOTTOM+BACK);
  }
}


module receptacle() {
  up(depth)
  difference() {
    black() cyl(d=50, h=10, anchor=UP);
    up(.1) cyl(d=15, h=depth, anchor=UP);
  }
}

module hose() {
  up(hose_height) xrot(90) black() cyl(d=11.3, h=50, $fn=100);
}


module env() {
  hose();
  receptacle();
  magnet();
}


module body() {
  slice = 3;
  difference() {
    union() {
      up(slice) cuboid([15,15,hose_height-slice], anchor=DOWN);
      hull() {
        up(slice) cuboid([15,15,.1], anchor=DOWN);
        up(depth) cyl(d=15, h=.1, anchor=BOTTOM);
      }
      up(hose_height) xrot(90) cyl(d=15, h=15);
      cyl(d=15, h=depth, anchor=BOTTOM);
    }
    env();
    mirror_copy([1,0,0]) right(5.2) up(6.6) hull() {
      down(2) xrot(90) cyl(d=1, h=50, $fn=100);
      left(1) up(3) xrot(90) cyl(d=3, h=50, $fn=100);
    }
    left(7) up(7) xrot(90) zrot(30) cuboid([5,2,50]);
  }
}

//env();
xrot(-90) body();
