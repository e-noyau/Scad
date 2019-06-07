

use <gps_790_insert.scad>
use <noyau_utils.scad>
// This is the size of the insert hole for the AMPs pattern on top. Watch out
// for the depth, as anything longer may get accross the part completely.
amps_insert_radius = 5.9/2;
amps_insert_depth = 5.87;


module one() {
	  insert_receptacles(amps_insert_depth, amps_insert_radius);
}

module two(reduction_percentage) {
	translate([0,0,.01])
	  insert_holes(amps_insert_depth, amps_insert_radius, reduction_percentage);
}

separation = amps_insert_radius* 3.6;
count = 5;

difference() {
	union() {
		for (index = [0:count]) {
			mirrored([1,0,0]) {
			translate([-separation/2, index * separation, 0])
			  one();
		  }
		}
		translate([-10.7, -5, -11])
    cube([20,(count+1)*separation,amps_insert_depth * .75]);
	}
	for (index = [0:count]) {
		percentage = 0.7 + .3 / (count+1) * index;
		echo(percentage);
		mirrored([1,0,0]) {
		translate([-separation/2, index * separation, 0])
		  two(percentage);
	  }
	}
	
  translate([separation/2,-6,-amps_insert_depth*2 +.1])
	  cube([10,(count+2)*separation,amps_insert_depth * 2]);
	translate([0,-6,-amps_insert_depth/1.3 +.1])
		cube([10,(count+2)*separation,amps_insert_depth * 2]);
}