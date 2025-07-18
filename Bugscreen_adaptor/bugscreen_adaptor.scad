include <BOSL2/std.scad>
use <noyau/utils.scad>

$fn = 30;

H = 75;
L = 40;
Depth_left = 20;
Depth_right = 25;


Screw1_H = H - 47;
Screw1_L = 35;
Screw2_H = H - 70.5;
Screw2_L = 25.5;
screw_dia = 5;


module trucmuche(Depth = D) {
    difference() {
    union() {
        // Main body with centering point
        cuboid([H,L,Depth], anchor=FRONT+LEFT);
        translate([H - 21, L/2, 0]) up(4) cyl(d=6, h=Depth, circum = false );
    }

    // Remove the bottom corner
    translate([-.01, -.01, 0]) cuboid([31, 20, Depth*2], anchor=FRONT+LEFT);

    // Adapt to the window 
    translate([-.01, -.01, 0]) cuboid([H*2,15,Depth*2], anchor=FRONT+LEFT);

    // Remove two screw holes
    translate([Screw1_H, Screw1_L, 0]) cyl(d=screw_dia, h=Depth*2, circum = true);
    translate([Screw2_H, Screw2_L, 0]) cyl(d=screw_dia, h=Depth*2, circum = true);
    
    // Remove the weird angle
    translate([Screw1_H, L, 0]) rot(22) cuboid([Screw1_H * 2, 20, Depth*2], anchor=FRONT+RIGHT);
    }
}

trucmuche(Depth_right);
mirror([0,1,0]) trucmuche(Depth_left);
