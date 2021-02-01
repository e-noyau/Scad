include <BOSL2/std.scad>
use <noyau/utils.scad>
use <threading/Threading.scad>


// Existing mailbox has a hole with two side squares to prevent spinning.
hole_dia = 17.6;
hole_depth = 1;
hole_pin_width = 4;
hole_pin_length = 20;
hole_clearance = .1;

mailbox_depth = 1;

// How much the barrel stick out on the outside
barrel_out = 3;

// How much the barrel stick out on the inside
barrel_in = 9;

// Diameter of the barrel outside, locking agains the metal
barrel_ext_dia = hole_pin_length + 1;

// Diameter of the hole inside the barrel where the axis rotates.
barrel_hole_dia = 8;

// Add some slop to everything.
printer_slop = .2;


// Modeling the existing box
module hole () {
  union() {
    circle(d = hole_dia);
    square([hole_pin_width, hole_pin_length], center = true);
  };
}

module mailbox () {
  yrot(90) metal() linear_extrude(height=.9) difference () {
    square(100, center = true);
    hole();
  }
}


// A simple clip
// TODO: needs tapering.
module clip() {
  width = 1.8;
  clip_length = 2.5;
  clip_height = .5;
  total_length = 3.51;
  support_height = 1;

  hole_width = width + .2;
  hole_depth = 2;
  hole_length = total_length - 1;
  
  if ($negative) {
     up(hole_depth)
       left(clip_length + .2)
         cuboid([total_length + .2, hole_width, hole_depth * 2],
                rounding = support_height/2, edges = BOTTOM, anchor = LEFT+TOP);
  } else {
    left(clip_length)
        cuboid([total_length, width,support_height],
               rounding = support_height/2, edges = BOTTOM, anchor = LEFT+TOP);
    prismoid([clip_length,width], [1,1], shift = [(clip_length-1)/2 ,0],
             h = clip_height, anchor = RIGHT+BOTTOM); 
  }
}


// The barrel has a screw on the inside, a nut locks it in place..
screw_pitch = 3;
screw_angle = 45;
screw_slop = printer_slop * 3;

module barrel_screw() {
  orange() difference() {
    union () {
      rounding = 1.5;
      yrot(90)
          threading(d = hole_dia - hole_clearance,
                    windings = barrel_in/screw_pitch -1, pitch=screw_pitch, angle=screw_angle,
                    full=true);
      right(mailbox_depth) union() {
        cyl(h = mailbox_depth +.1, d = hole_dia - hole_clearance, circum = false, orient = RIGHT, anchor = UP);
        cuboid([mailbox_depth+.1, hole_pin_length - hole_clearance, hole_pin_width - hole_clearance], anchor = RIGHT);
      }
      cyl(h = barrel_out, d = barrel_ext_dia, circum = true, orient = LEFT, anchor = DOWN);
    };
    cyl(h = 50, d = barrel_hole_dia, circum = true, orient = RIGHT);
  }
}

module barrel_nut() {
  right(screw_pitch) difference() { 
    yrot(90)
      Threading(D=barrel_ext_dia, d = hole_dia - hole_clearance + screw_slop,
                windings = barrel_in/screw_pitch-1, pitch=screw_pitch,
                angle=screw_angle);
    xrot_copies(n=24) back(barrel_ext_dia/2) cyl(h = barrel_in, d = 1.5, orient = LEFT, $fn=12);
  }
}



// The knob to turn the lock includes the axis.
module knob() {
  left(barrel_out * 1.5) union() {
    cyl(h = barrel_in + barrel_out * 1.5 +5, 
      d = barrel_hole_dia-printer_slop*2, circum = false, orient = RIGHT, anchor=DOWN);
      let($negative = false) clip();
    }
  difference() {
    left(barrel_out/2) cyl(h = barrel_out * 2 , d = barrel_ext_dia + 5, circum = true, orient = LEFT, anchor = DOWN);
    cyl(h = barrel_out + printer_slop, d = barrel_ext_dia+ printer_slop *2, circum = true, orient = LEFT, anchor = DOWN);
    xrot_copies(n=24) left (barrel_out *1.5) back((barrel_ext_dia + 5)/2) cyl(h = barrel_in, d = 1.5, orient = LEFT, $fn=12);
  }
}

// The latch clips at the end of the axis.
module latch() {

  latch_radius = 10; // latch circle
  axis_radius = barrel_ext_dia / 2; // center circle
  spread = 30; // Distance betweent the two circles
  cutout_radius = 25;

  module body() {
    linear_extrude(height = 3) hull() {
       circle(r=axis_radius);
       translate([0, spread, 0])
         circle( r=latch_radius );
    }
  }

   right(barrel_in+printer_slop*3) yrot(90) union() {
     body();
     
     bump = latch_radius * 1.5;
     inset = 3;
     translate([0, spread, bump - inset])
     difference() {
       sphere(r=bump);
       translate([0,0,inset + .1]) cuboid([bump *2, bump*2 , bump* 2]);
     };
 } 
 
}



module assembly () {
  //mailbox();
  barrel_screw();
  metal() barrel_nut();
  knob();
  latch();
}

module sliced_assembly() {
  difference() {
    assembly();
    cuboid([40, 120, 80], anchor = UP);
  }
}


module ready_to_print() {
  up(barrel_out) left(12)  yrot(-90) barrel_screw();
  down(screw_pitch) right(12)  yrot(-90) barrel_nut();
  up(barrel_out * 2.5) back(25) yrot(-90) knob();
  right(40) yrot(90) left(barrel_in+printer_slop*3 + 3) latch();
}

sliced_assembly();
//assembly();
left(100) ready_to_print();
