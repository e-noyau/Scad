include <BOSL2/std.scad>
use <noyau/utils.scad>

// Inside diameter of the tube to connect
outside_diameter = 27;

// Tube thickness, aka the difference between the inside and outside diameter.
thickness = 2;

// The difference in size between the pin and the pin receptacle. Depends on
// your printer's precision.
friction_scale = 1.03;

// Number of faces on round surfaces.
$fn=100;


module Printy_L_connector() {
  import("printy-pipes-construction-toy-updated-model_files/L Connector/L Connector.stl");
}

nudge = .001;

module pin(inside_d = outside_diameter - thickness,
           inside_l = undef, rounded = true, scale = 1 / friction_scale) {
  
  inside_l = (inside_l == undef) ? inside_d : inside_l;
  
  rounding_vectors = rounded ? [0,0,1,1] : [0,0,0,0];
  scale(scale) xrot(180) yflip_copy()
    prismoid(
      size1 = [inside_d / 3, inside_l / 3],
      h=inside_d / 5,
      xang = 60, yang = 90,
      rounding = rounding_vectors,
      orient = FWD, anchor = TOP+BACK);
}

// Base modules to build the connectors


module inserts(inside_d) {
    insert_dia = 2.7 * 2;
    insert_depth = 6;
    
    xrot(90) zflip_copy() up(inside_d /2)
      cyl(d = insert_dia, h = insert_depth, anchor = TOP);
}


module base_connector(
  inside_d, outside_d, inside_l, outside_l) {
  
  zrot(90) up(outside_l) difference() {
    union () {
      cyl(d = inside_d, h = inside_l, anchor = BOTTOM, chamfer2 = inside_d/40);
      cyl(d = outside_d, h = outside_l, anchor = TOP);
    }
    up(inside_l+nudge) xrot(180)
      pin(inside_d, inside_l, rounded = false, scale = 1);
    up(inside_l / 2) inserts(inside_d);
  }
}

module base_L_connector(
  inside_d = outside_diameter - thickness, outside_d = outside_diameter,
  inside_l = undef, outside_l = undef) {

  inside_l = (inside_l == undef) ? inside_d : inside_l;
  outside_l = (outside_l == undef) ? outside_d / 2 : outside_l;
  
  yrot(90) difference() {
    union() {
      base_connector(inside_d, outside_d, inside_l, outside_l);
      xrot(90)
        base_connector(inside_d, outside_d, inside_l, outside_l);
      sphere(d = outside_d);
    }
    cuboid(
      [
        (outside_l + inside_l) * 3,
        outside_d * 3,
        (outside_l + inside_l) * 3
      ],
      anchor = LEFT);
  }
}

module base_T_connector(
  inside_d = outside_diameter - thickness, outside_d = outside_diameter,
  inside_l = undef, outside_l = undef) {

  inside_l = (inside_l == undef) ? inside_d : inside_l;
  outside_l = (outside_l == undef) ? outside_d / 2 : outside_l;

  yrot(90) difference() {
    union() {
      base_connector(inside_d, outside_d, inside_l, outside_l);
      xrot(90) base_connector(inside_d, outside_d, inside_l, outside_l);
      xrot(180) base_connector(inside_d, outside_d, inside_l, outside_l);
      sphere(d=outside_d);
    }
    cuboid(
      [
        (outside_l + inside_l) * 3,
        outside_d * 3,
        (outside_l + inside_l) * 3
      ],
      anchor = LEFT);
  }
}

module base_I_connector(
  inside_d = outside_diameter - thickness, outside_d = outside_diameter,
  inside_l = undef, outside_l = undef) {

  inside_l = (inside_l == undef) ? inside_d : inside_l;
  outside_l = (outside_l == undef) ? outside_d / 2 : outside_l;

  yrot(90) difference() {
    union() {
      base_connector(inside_d, outside_d, inside_l, outside_l / 2);
      xrot(180) base_connector(inside_d, outside_d, inside_l, outside_l / 2);
    }
    cuboid(
      [
        (outside_l + inside_l) * 3,
        outside_d * 3,
        (outside_l + inside_l) * 3
      ],
      anchor = LEFT);
  }
}

module base_X_connector(
  inside_d = outside_diameter - thickness, outside_d = outside_diameter,
  inside_l = undef, outside_l = undef) {

  inside_l = (inside_l == undef) ? inside_d : inside_l;
  outside_l = (outside_l == undef) ? outside_d / 2 : outside_l;

  yrot(90) difference() {
    union() {
      base_connector(inside_d, outside_d, inside_l, outside_l);
      xrot(90) base_connector(inside_d, outside_d, inside_l, outside_l);
      yrot(-90) base_connector(inside_d, outside_d, inside_l, outside_l);
      xrot(180) base_connector(inside_d, outside_d, inside_l, outside_l);
      sphere(d=outside_d);
    }
    cuboid(
      [
        (outside_l + inside_l) * 3,
        outside_d * 3,
        (outside_l + inside_l) * 3
      ],
      anchor = LEFT);
  }
}

// Ready to print

module T_connector(
  inside_d = outside_diameter - thickness, outside_d = outside_diameter) {
  zrot_copies(n = 2) {
    back(outside_d * 1.2) zrot(180) base_T_connector(inside_d, outside_d);
  }
  zrot_copies(n = 3) {
    back(inside_d / 2.5) pin(inside_d, outside_d);
  }
}

module L_connector(
  inside_d = outside_diameter - thickness, outside_d = outside_diameter) {
  zrot_copies(n = 2) {
    back(outside_d) left(inside_d) base_L_connector(inside_d, outside_d);
    back(inside_d / 4) pin(inside_d, outside_d);
  }
}

module I_connector(
  inside_d = outside_diameter - thickness, outside_d = outside_diameter) {
  base_I_connector(inside_d, outside_d, outside_l = 5);
  zrot_copies(n = 2) {
    left(inside_d * 2) pin(inside_d, outside_d);
  }
}

module 4ways_connector(
  inside_d = outside_diameter - thickness, outside_d = outside_diameter) {
  fwd(outside_d / 2 + 2) base_X_connector(inside_d, outside_d);
  back(outside_d / 2 + 2) zrot(180) base_T_connector(inside_d, outside_d);
  zrot_copies(n = 4) {
    left(outside_d * 1.4) fwd(outside_d * 1.4) pin(inside_d, outside_d);
  }
}

module fit_test(
  inside_d = outside_diameter - thickness, outside_d = outside_diameter,
  inside_l = undef) {

  inside_l = (inside_l == undef) ? inside_d : inside_l;
  outside_l = 3;

  back(outside_d + 3) zrot_copies(n = 2) right(2) yrot(90) difference() {
      base_connector(inside_d, outside_d, inside_l, outside_l / 2);
    cuboid([
      (outside_l + inside_l) * 3,
      outside_d * 3,
      (outside_l + inside_l) * 3
    ], anchor = LEFT);
  }
  xdistribute(inside_d/2) {
    pin(scale = 1);
    pin(scale = 1.1);
    pin(scale = 1.2);
    pin(scale = 1.3);
  }
}
 
fit_test(); 


/*

for (x = [outside_diameter, outside_diameter*3]) {
  right(x * 5) L_connector(inside_d = x - thickness, outside_d = x);
  left(x * 5) T_connector(inside_d = x - thickness, outside_d = x);
  back(x * 5) I_connector(inside_d = x - thickness, outside_d = x);
  fwd(x * 5) 4ways_connector(inside_d = x - thickness, outside_d = x);
}

base_connector(outside_diameter - thickness, outside_diameter, 
               outside_diameter, outside_diameter);
*/