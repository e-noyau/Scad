include <BOSL2/std.scad>

size = 20;

module heart(name) {
    fwd(15) zrot(45) linear_extrude(height = 1) union() {
      square(size);
      translate([size/2, size, 0])
          circle(size/2);

      translate([size, size/2, 0])
          circle(size/2);
    }
    linear_extrude(height = 3)
        text(name, halign="center", size=7, font= "Comic Sans MS");
}

module option_1() {
  names = ["Éric", "Bob", "Ali"];
  for (i = [0:1:len(names)-1])
    right(i*40) heart(names[i]);
}

module option_2() {
  distribute(spacing=40, dir=RIGHT) {
     heart("Éric");
     heart("Bob");
     heart("Ali");
  }
}

option_1();
fwd(40) option_2();