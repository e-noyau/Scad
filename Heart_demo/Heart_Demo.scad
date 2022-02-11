include <BOSL2/std.scad>

module 2d_heart(size) {
  half = size/2;
  fwd(5) zrot(-45) {
    square(size, center=true);
    mirror_copy([1,1,0]) translate([0, half, 0]) circle(half);
  }
}

module 2d_heart_border(size) {
  difference() {
    2d_heart(size);
    2d_heart(size-1);
  }
}

module heart(name, size = 20, textsize = 7) {
  linear_extrude(height = 1)
    2d_heart(size);
  linear_extrude(height = 2) {
    text(name, halign="center", valign="center", size=textsize, font= "Comic Sans MS");
    2d_heart_border(size);
  }
}

module option_1() {
  names = ["Éric", "Bob", "Ali"];
  for (i = [0:1:len(names)-1])
    right(i*40) heart(names[i]);
}

module option_2() {
  xdistribute(spacing=40) {
     heart("Éric");
     heart("Bob");
     heart("Ali");
     heart("Dominique", textsize=4);
  }
}

fwd(40) option_1();
option_2();
