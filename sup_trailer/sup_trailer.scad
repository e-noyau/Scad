include <BOSL2/std.scad>
use <noyau/utils.scad>

$fn = $preview ? 80: 300;

// Geometry of the tube all the parts are sliding into or over.
tube_inner_radius = 14;
tube_outer_radius = 16;
tube_length = 770;

// To let thing rotate greely around the tube, this is the clearance between the
// tube and the thing that are rotating over it.
radius_clearance = .13;

// Internal radius of the parts rotating around the tube.
overlapping_tube_radius = tube_outer_radius + radius_clearance;

// Diameter of the hole for the tension string
string_dia = 6;

// Caracteristics of the locking tongue

// How munch thelocking tongue is protuding horizontally under the bike support.
depth_tongue = 16;

// The height of the tongue, the higher the stronger, but too high and it's
// impossible to slide in position.
height_tongue = 8;

// Full width of the tongue
width_tongue = 34;

// The small inner vertical part (also used by the rotating bit)
width_inner_lock = 21;

// The depth of the small inner lock
depth_inner_lock = 3;

// Length of the tongue support over the tube
lock_support_depth = 15;

// Lenght of the back of the twisting part.
back_length = 20;

// Controls the printed tube walls
wall_size = 4;

// Length of the rotating lock over the tube.
depth_lock = 10;

// Space between the tongue and the rotating tube.
height_pin = 7 + wall_size; // Estimated!!!


module main_tube() {
  #tube(
    h=tube_length, or=tube_outer_radius, ir=tube_inner_radius,
    orient = LEFT, anchor = TOP
  );
}

// The plug at the far end of the tube, with a hole inside to let the string
// go through.
module end_cap(inner_length = 40, outer_length = 7, cap_radius = tube_outer_radius, rounded =true) {
  // The part that slides inside the main tube
  tube(
    h = inner_length, or = tube_inner_radius, wall = tube_inner_radius - (string_dia/2),
    orient = LEFT, anchor = TOP,
    circum = true, irounding1 = 3, orounding1 = 3
  );
  // The end cap preventing it from going inside.
  tube(
    h = outer_length, or = cap_radius, wall = cap_radius - (string_dia/2),
    orient = LEFT, anchor = BOTTOM,
    circum = true, irounding2 = 3, orounding2 = rounded ? 3:0
  );
}

module tongue() {
  zrot(-90) yrot(-90) zflip_copy() 
    linear_extrude(height = width_tongue/2, scale=.95)
      trapezoid(
        h = depth_tongue,
        w1 = height_tongue,
        ang = [85, 90],
        anchor = FRONT + RIGHT,
        rounding = [0, 6, 0, 0]
      );
}

module rotating_tongue() {
  zrot(180) down(height_pin + overlapping_tube_radius) tongue();
  difference() {
      union() {
        hull() {
          tube(
            h = lock_support_depth,
            ir = overlapping_tube_radius,
            wall = wall_size,
            orient = RIGHT, anchor = BOTTOM
          );
          down(height_pin + overlapping_tube_radius)
            cuboid(
              [lock_support_depth, width_tongue, height_tongue],
              anchor = LEFT+TOP, rounding = 6, edges = BOTTOM+RIGHT,
              teardrop = 45
            );
        }
        // inner lock
        left(depth_inner_lock)
        difference() {
          down(height_pin + overlapping_tube_radius) 
          cuboid(
            [depth_inner_lock, width_inner_lock, height_pin * 2], anchor=LEFT+BOTTOM,
            rounding = 1.5, edges = [LEFT+TOP, LEFT+BACK, LEFT+FRONT]);
          left(.1) cyl(
                h=depth_inner_lock*3, r=overlapping_tube_radius + wall_size + .51,
                orient = LEFT, anchor = TOP,
                circum = true
              );
            }
    }
    left(.1) cyl(
      h=tube_length, r=overlapping_tube_radius+.1,
      orient = LEFT, anchor = TOP,
      circum = true
    );
  }
}

module twist_lock(endcap = false) {
  module front_part() {
    // Around the tube front
    tube(
      h = depth_tongue + depth_lock,
      ir = overlapping_tube_radius + .1,
      wall = wall_size,
      orient = LEFT, anchor = BOTTOM
    );
    // Lock to hold the part in place
    left(depth_tongue) intersection() {
      down(overlapping_tube_radius) cuboid(
        [depth_lock, width_inner_lock, (height_pin + wall_size) * 2],
        anchor = RIGHT
      );
      tube(
        h = depth_lock,
        ir = overlapping_tube_radius, wall = height_pin + wall_size,
        orient = LEFT, anchor = BOTTOM
      );
    }
  }

  module back_part() {
      // Around the tube back
      tube(
        h = back_length, ir = overlapping_tube_radius + .1, wall = wall_size,
        orient = RIGHT, anchor = BOTTOM
      );
  }

  module connection_part() {
    // Connection between the front and the back
    back_half(y = -10) top_half(z = -10)
    scale([1.2,1,1])
      difference() {
        sphere(r = tube_outer_radius + wall_size + 7.5);
        sphere(r = (tube_outer_radius + wall_size + 4.5));
      }
  }

  module ridges_part() {
    clearance = 1;
    // Ridges to rigidify the connection
    intersection() {
      difference () {
        yrot(90) arc_copies(d=tube_outer_radius, sa=97, ea=198, n=5)
          cuboid([20,3,lock_support_depth*4], anchor = LEFT);
        cyl(
          h = lock_support_depth * 4, r = overlapping_tube_radius + wall_size + clearance,
          orient = RIGHT
        );
      }
      scale([1.2,1,1])
          sphere(r = tube_outer_radius + wall_size + 6.5);
    }
  }

  module middle_twist_assembly() {
    difference() {
      union() {
        front_part();
        right(lock_support_depth+.3) back_part();
        z_angle = endcap ? 180 : 0;
        right(lock_support_depth /2) zrot(z_angle) {
          connection_part();
          ridges_part();
        }
      }
      //Make sure the tube fits through without rubbing
      cyl(
        h=tube_length, r=overlapping_tube_radius,
        orient = LEFT,
        circum = true
      );
    }
  }

  if(endcap)
    left(depth_lock + depth_tongue - 7)
      end_cap(
        rounded = false, 
        inner_length = depth_tongue + depth_lock - 7.2,
        cap_radius = tube_outer_radius + wall_size
      );
  middle_twist_assembly();
}

module full_assembly() {
  plastic() main_tube();
  steel() zrot(180) left(tube_length) end_cap();
  steel() twist_lock(endcap=true);
  rotating_tongue();
  right(150) zrot(180) {
    rotating_tongue();
    stainless() twist_lock();
  }
}

if ($preview) {
  full_assembly();
  //rotating_tongue();
} else {
  back(50) yrot(-90) right(lock_support_depth) zrot(180) rotating_tongue();
  fwd(50) yrot(-90) right(lock_support_depth) zrot(180) rotating_tongue();
  right(55) yrot(-90) right(7) end_cap();
  left(60) yrot(-90) right(lock_support_depth*2) twist_lock();
  yrot(-90) right(lock_support_depth + depth_lock) twist_lock(endcap=true);

}
