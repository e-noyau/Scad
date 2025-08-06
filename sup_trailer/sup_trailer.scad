include <BOSL2/std.scad>
use <noyau/utils.scad>

$fn = $preview ? 80: 300;

// Tube geometry
tube_inner_radius = 14;
tube_outer_radius = 16;
tube_length = 770;

overlapping_tube_radius = tube_outer_radius + .13;

// Diameter of the hole for the tension string
string_dia = 7.5;

// Caracteristics of the locking tongue
depth_lock = 16;
height_lock = 8;
width_lock = 20;
height_pin = 8; // Estimated!!!
lock_support_depth = 15;

wall_size = 2;
tongue_depth = 10;

module main_tube() {
  #tube(
    h=tube_length, or=tube_outer_radius, ir=tube_inner_radius,
    orient = LEFT, anchor = TOP
  );
}

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

module bike_anchor() {
  zrot(-90) yrot(-90) zflip_copy() linear_extrude(height = width_lock/2, scale=.95)
  trapezoid(
    h = depth_lock,
    w1 = height_lock,
    ang = [85, 90],
    anchor = FRONT + RIGHT,
    rounding = [0, 6, 0, 0]
  );
}

module end_cap_anchor() {
  end_cap(outer_length = lock_support_depth);
  difference() {
    prismoid(
      h = (height_lock + height_pin) * 2,
      size1 =  [lock_support_depth, width_lock],
      size2 =  [lock_support_depth, tube_outer_radius * 2],
      anchor =  RIGHT+TOP, rounding = [0,3,3,0]
    );
    right(.5) cyl(h = lock_support_depth + 1, r = string_dia + 3, orient = RIGHT, anchor = TOP );
  }
  down(height_pin + tube_outer_radius) bike_anchor();
}

module middle_anchor() {
  zrot(180) down(height_pin + tube_outer_radius) bike_anchor();
  difference() {
    hull() {
      tube(
        h = lock_support_depth, ir = overlapping_tube_radius, wall = wall_size,
        orient = RIGHT, anchor = BOTTOM
      );
      down(height_pin + tube_outer_radius) cuboid(
        [lock_support_depth, width_lock, height_lock],
        anchor = LEFT+TOP, rounding = 6, edges = BOTTOM+RIGHT
      );
    }
    left(.1) cyl(
      h=tube_length, r=overlapping_tube_radius,
      orient = LEFT, anchor = TOP,
      circum = true
    );
  }
}

module twist_part(endcap = false) {
  module front_part() {
    // Around the tube front
    tube(
      h = depth_lock + tongue_depth, ir = overlapping_tube_radius, wall = wall_size,
      orient = LEFT, anchor = BOTTOM
    );
    // Tongue to hold the part in place
    left(depth_lock) intersection() {
      down(tube_outer_radius) cuboid(
        [tongue_depth, width_lock, (height_lock + height_pin + wall_size) * 2],
        anchor = RIGHT
      );
      tube(
        h = tongue_depth,
        ir = overlapping_tube_radius, wall = height_lock + height_pin + wall_size,
        orient = LEFT, anchor = BOTTOM
      );
    }
  }

  module back_part() {
      // Around the tube back
      tube(
        h = lock_support_depth, ir = overlapping_tube_radius, wall = wall_size,
        orient = RIGHT, anchor = BOTTOM
      );
  }

  module connection_part() {
    // Connection between the front and the back
    back_half(y = -10) top_half() 
    scale([1.2,1,1])
      difference() {
        sphere(r = tube_outer_radius *1.5);
        sphere(r = (tube_outer_radius *1.5) - wall_size);
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
          h = lock_support_depth * 4, r = overlapping_tube_radius + wall_size +clearance,
          orient = RIGHT
        );
      }
      scale([1.2,1,1])
          sphere(r = tube_outer_radius *1.5);
    }
  }

  module middle_twist_assembly() {
    difference() {
      union() {
        front_part();
        right(lock_support_depth+.3) back_part();
        right(lock_support_depth /2) {
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
    left(tongue_depth + depth_lock -7) end_cap(rounded = false, inner_length = depth_lock + tongue_depth - 7);
  middle_twist_assembly();
}

module full_assembly() {
  plastic() main_tube();
  steel() zrot(180) left(tube_length) end_cap();
  steel() end_cap_anchor();
  right(150) {
    #steel() middle_anchor();
    stainless() twist_part();
  }
}

module locked_full_assembly() {
  plastic() main_tube();
  steel() zrot(180) left(tube_length) end_cap();
  steel() twist_part(endcap=true);
  middle_anchor();
  right(150) zrot(180) {
    middle_anchor();
    stainless() twist_part();
  }
}

if ($preview) {
  locked_full_assembly();
} else {
  back(50) yrot(-90) right(lock_support_depth) end_cap_anchor();
  fwd(50) yrot(-90) right(lock_support_depth) zrot(180) middle_anchor();
  right(55) yrot(-90) right(7) end_cap();
  left(60) yrot(-90) right(lock_support_depth*2) twist_part();
  yrot(-90) right(lock_support_depth + tongue_depth) twist_part(endcap=true);

}
