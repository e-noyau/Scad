// A replacement for the plastic cover on the bar right below the windshield on
// a KTM 790 Adventure..

use <noyau_utils.scad>;

bottom_width = 16.30;
bottom_width_inside = 11.40;
top_width = 21.60;
top_width_inside = 15.5;

length = 99.80;

bottom_height = 3.70;
top_height = 5;

body_points = [
 [0, top_width/2, 0],  // 0 Top tribord
 [0, -top_width/2, 0], // 1 top babord
 [length, -bottom_width/2, 0], // 2 bottom babord
 [length, bottom_width/2, 0], // 3 bottom tribord

 [0, top_width_inside/2, top_height],  // 4 Top inside tribord
 [0, -top_width_inside/2, top_height], // 5 top babord
 [length, -bottom_width_inside/2, bottom_height], // 6 bottom babord
 [length, bottom_width_inside/2, bottom_height], // 7 bottom tribord
];

module body() {
  polyhedron( points = body_points, faces = [
    [0,1,2,3], // front face
    [4,5,1,0], // top face
    [5,6,2,1], // babord
    [0,3,7,4], // tribord
    [6,7,3,2], // bottom
    [7,6,5,4], // back face
  ]);
}


module deep_body() {
  difference() {
    body();

    translate([0,0,2]) linear_extrude(5) #polygon([
      [2, -bottom_width/2 + 2], 
      [2, bottom_width/2 - 2], 
      [length-2, bottom_width_inside/2 - 2 ], 
      [length-2, -bottom_width_inside/2 + 2]
    ]);
  }
}

deep_body();