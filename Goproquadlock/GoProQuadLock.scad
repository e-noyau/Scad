include <BOSL2/std.scad>
use <noyau/utils.scad>


module connector() {
 difference() {
   metal() up(10) left(7.5) yrot(90) import("GoPro_Arm_Short_Twist.stl");
   cuboid([50,50,50], anchor=UP);
 }
}

connector();
down(21) plastic() import("integrated_quadlock_v4b.stl");

