


include <BOSL2/std.scad>
use <noyau/utils.scad>
use <threading/Threading.scad>

hole_dia = 17.6;
hole_depth = 1;
hole_pin_width = 4;
hole_pin_length = 20;
hole_clearance = .1;

mailbox_depth = 1;

barrel_out = 3;
barrel_in = 9;
barrel_ext_dia = hole_pin_length + 1; 
barrel_hole_dia = 8;

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


// First attempt at a barrel with clips. Not clipping well enough.
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

module solid_barrel () {
  union () {
    rounding = 1.5;
    cyl(h = barrel_in,  d = hole_dia - hole_clearance,
        rounding1 = 3, circum = false,
        orient = LEFT, anchor = UP);
    cyl(h = barrel_out, d = barrel_ext_dia, 
        circum = true,
        orient = LEFT, anchor = DOWN);
    right(mailbox_depth + rounding)
        cuboid([rounding*2, hole_pin_length - hole_clearance, hole_pin_width - hole_clearance],
               rounding = rounding, edges = RIGHT,
               anchor = RIGHT);
  };
}

module barrel_with_clips () {
  difference () {
    solid_barrel();
    rot_copies(n=6, v=LEFT) let($negative = true)
      right(mailbox_depth) up(hole_dia/2 - .3) zrot(180) clip();    
  }
  rot_copies(n=6, v=LEFT)  let($negative = false)
    right(mailbox_depth) up(hole_dia/2 - .2) zrot(180) clip();
}


// The barrel now screw on itself. Easier to print.
screw_pitch = 1.50;
module barrel_screw() {
  orange() difference() {
    union () {
      rounding = 1.5;
      yrot(90)
          threading(d = hole_dia - hole_clearance,
                    windings = barrel_in/screw_pitch -1, pitch=screw_pitch, angle=25,
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
   right(screw_pitch) yrot(90)
      Threading(D=barrel_ext_dia, d = hole_dia - hole_clearance + printer_slop * 2,
                    windings = barrel_in/screw_pitch-1, pitch=screw_pitch, angle=25);
  
  
  // plastic() difference() {
  //   right(mailbox_depth) cyl(h = barrel_in, d = barrel_ext_dia, circum = false, orient = LEFT, anchor = UP);
  //   let($slop = printer_slop)
       //threaded_rod(d=hole_dia - hole_clearance, l=barrel_in*2*4, pitch=screw_pitch, internal=true, bevel = false, orient = LEFT);
       
  //}
}



// The knob to turn the lock
module knob() {
  left(barrel_out * 1.5) cyl(h = barrel_in + barrel_out * 1.5 +5, 
      d = barrel_hole_dia-printer_slop*2, circum = false, orient = RIGHT, anchor=DOWN);
  difference() {
    left(barrel_out/2) cyl(h = barrel_out * 2 , d = barrel_ext_dia + 5, circum = true, orient = LEFT, anchor = DOWN);
    cyl(h = barrel_out + printer_slop, d = barrel_ext_dia+ printer_slop *2, circum = true, orient = LEFT, anchor = DOWN);
  }
}






module assembly () {
  //mailbox();
  barrel_screw();
  metal() barrel_nut();
  knob();
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
}

//sliced_assembly();
//assembly();
left(100) ready_to_print();
