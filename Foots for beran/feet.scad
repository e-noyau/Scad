include <BOSL2/std.scad>
use <noyau/utils.scad>


HEIGHT=12.8;
TOP_DIA=24;
BOTTOM_DIA=26.30;
BORE_DIA = 8.13;
INSERT_DIA = 12;
INSERT_DEPTH = 8.53;


module feet() {
  $fn=200;
  difference() {
    cyl(h=HEIGHT, d1=BOTTOM_DIA, d2=TOP_DIA);
    cyl(h=HEIGHT+.1, d=BORE_DIA);
    up((HEIGHT-INSERT_DEPTH)/2+.1) cyl(h=INSERT_DEPTH, d=INSERT_DIA);
  }
}



feet();


