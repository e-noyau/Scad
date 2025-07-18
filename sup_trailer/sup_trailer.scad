include <BOSL2/std.scad>
use <noyau/utils.scad>

WIDTH = 34;
HEIGHT_CLIP = 17;
HEIGHT_LOCK = 8;
DEPTH_CLIP = 20;
ROD_DIA = 16;
ROD_LENGTH = 570;

$fn = 50;

module nonprintedstuff() {
  plastic() {
    left(-10) up(ROD_DIA/2) yrot(90) cyl(r=ROD_DIA/2, h=ROD_LENGTH, anchor = TOP + RIGHT);
    left(DEPTH_CLIP) cyl(d=6, h=31, anchor = BOTTOM);
    up(36) left(DEPTH_CLIP) yrot(90) cyl(d=26, h=3, anchor = BOTTOM);
    down(8) left(DEPTH_CLIP+10) zrot(45) xrot(90) #cyl(d=3, h=80);

    //cuboid([DEPTH_CLIP, WIDTH, HEIGHT_LOCK], anchor = TOP + LEFT);
  }
}

// nonprintedstuff();

// body();
module body2D() {
  right(ROD_DIA * 2 + HEIGHT_CLIP - HEIGHT_LOCK) 
  difference() {
    union() {
      rect(
        [ROD_DIA * 2 + HEIGHT_CLIP, DEPTH_CLIP],
        anchor = BACK + RIGHT,
        rounding = [0, 0, 3, 3]
      );
      trapezoid(
        h = DEPTH_CLIP,
        w1 = ROD_DIA * 2 + HEIGHT_CLIP,
        ang = [85, 90],
        anchor = FRONT + RIGHT,
        rounding = [0, 6, 0, 0]
      );
    }
    rect(
        [ROD_DIA * 2 + HEIGHT_CLIP - HEIGHT_LOCK, DEPTH_CLIP],
        anchor = FRONT + RIGHT,

    );
  }
}

module body() {
    down(HEIGHT_LOCK) zrot(-90) yrot(-90) zflip_copy() linear_extrude(height = WIDTH/2, scale=.95)
    body2D();
}

xrot(90) difference() {
  body();
  nonprintedstuff();
}
