// Same as mirror() but duplicates the children as opposed to just move it.
module mirrored(v) {
  union() {
    children();
    mirror(v = v)
      children();
  } 
}

// Build a negative rounded corner to soften a square angle.
module rounded_edge(radius, height, extra = 0) {
  translate([radius / 2, radius / 2, 0])
  difference() {
    cube([radius+.01 + extra, radius + .01 + extra, height + .01], center = true);
    translate([radius / 2, radius /2, 0])
      cylinder(r = radius, h = height + .02, center = true, $fn = 100);
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

module cylinder_outer(height,radius,fn){
  fudge = 1/cos(180/fn);
  cylinder(h = height,r = radius*fudge, $fn=fn, center = true);
}
