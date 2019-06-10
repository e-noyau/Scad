
// Same as mirror() but duplicates the children as opposed to just moving them.
module mirrored(v) {
  union() {
    children();
    mirror(v = v)
      children();
  } 
}

// Build a negative rounded corner to soften a square angle. Extra adds more
// material behind the rounded corner, which is sometimes useful to remove
// stuff.
module rounded_edge(radius, height, extra = 0) {
  translate([radius / 2, radius / 2, 0])
    difference() {
      translate([-extra/2, -extra/2, 0])
      cube([radius + .01 + extra, radius + .01 + extra, height + .01], center = true);
      translate([radius / 2, radius /2, 0])
        cylinder(r = radius, h = height + .02, center = true);
    }
}

// Build a cube with the corners in the z plane softened.
module rounded_cube(v, radius) {
  difference() {
    cube(v, center=true);
    mirrored([0, 1, 0]) mirrored([1, 0, 0])
      translate([-v[0]/2,-v[1]/2,0])
        rounded_edge(radius, v[2]);
  }
}

function number_of_circle_fragments(r) =
  $fn>0 ? ($fn >= 3 ? $fn : 3)
        : ceil(max(min(360 / $fa,
                       r * 2 * PI / $fs),
                   5));

// Build a cylinder garanteed to fit and element of the given radius. Aka, a
// little bit larger than a regular cylinder. Very useful with small fn.
module cylinder_outer(height,radius) {
  fn = number_of_circle_fragments(radius);
  fudge = 1 / cos(180 / fn);
  cylinder(h = height, r = radius * fudge, center = true);
}

// examples
translate([20, 20, 0]) rounded_edge(10, 5, 3);
translate([-20, 20, 0]) rounded_cube([20,15,5], 5);
mirrored([1, 0, 0]) translate([-20, -20, 0])difference() {
  cylinder_outer(5, 12, $fn = 6);
  cylinder(h = 6, r = 12, center = true);
}