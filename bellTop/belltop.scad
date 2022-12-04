include <BOSL2/std.scad>
include <BOSL2/metric_screws.scad>

$fn=100;

cyl(d=16, h=2.5, anchor=TOP);
shoulder=1.5;
cyl(d=7, h=shoulder, anchor = BOTTOM);
up(shoulder) cyl(d1=7, d2 = 4, h=3.5-shoulder, anchor = BOTTOM);
cyl(d=3, h=20, anchor=BOTTOM);