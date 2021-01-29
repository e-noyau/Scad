// Latch for Lulzbot Mini Enclosure
// Uses an M3 bolt to hold them together
// Latch consists of an outside handle and an inside latch arm
// They are keyed with an octagonal slot, so that the handle can 
// have any of eight orientations relative to the latch (45 degrees)

scr=1.75;   // Screw radius (M3 clearance hole)
scr2=3.4;   // Screw head radius (M3 panhead machine screw)
pr=9;       // Radius of large end of latch 
ps=6;       // Radius of the center shaft
ph=2.5;     // Latch height
px=14;      // Latch end offset distance (length of latch) 
ny=2;       // Number of rows

// Inside latch arm
difference() {
    union() {
        hull() {
            cylinder(r=pr,h=ph,$fn=100);
            translate([px,0,0]) cylinder(r=3.1,h=1.8,$fn=16);
            }
        cylinder(r=ps,h=5.5,$fn=100);
        translate([0,0,5.49]) cylinder(r=ps,h=3,$fn=8);
        difference() {
            translate([px,0,-1]) sphere(r=3.6,$fn=100);
            translate([px,0,-5]) cylinder(r=4,h=6.5,$fn=16);
            }
        }
    cylinder(r=scr,h=20.5,$fn=100,center=true);
    cylinder(r=scr2,h=3.4,$fn=6,center=true);
    }    

// Outside Latch Handle
translate([px*1.5,16,0]) rotate([0,0,180]) difference() {
    union() {
        hull() {
            cylinder(r=10,h=ph,$fn=100);
            translate([20,0,0]) cylinder(r=5,h=ph,$fn=16);
            }
        translate([0,0,2.49])cylinder(r1=10.0,r2=13,h=6,$fn=100);
    }
    cylinder(r=scr,h=40.5,$fn=100,center=true);
    cylinder(r=scr2,h=2.4,$fn=20,center=true);
    translate([0,0,5.4]) cylinder(r=ps+.3,h=5,$fn=8);
    }    
