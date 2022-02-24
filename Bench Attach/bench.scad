include <BOSL2/std.scad>
include <BOSL2/metric_screws.scad>


module 2d_form(diameter = 20) {
  difference() {
    radius = diameter / 2;
    added_length = radius;
    length = radius * 2 + added_length;
    width = radius * 2.6;
    right(added_length/2) square(size = [length, width], center = true);
    circle(r = radius, $fn=50);
    left(.01)
      polygon([[0,0],[-radius, width/2],[-radius, -width/2]]);
  }
}

module clip(diameter=19, width = 40, screw_size=4, show_screw = false) {
  difference() {
    down(width/2) linear_extrude(height = width) 2d_form(diameter=diameter);
    
    head_diameter = get_metric_bolt_head_size(screw_size);
    head_hight = 3.2;
    
    right(diameter/2 + head_hight) 
    yrot(-90) {
      if (show_screw) {
        #metric_bolt(headtype="button", size=screw_size, l=10, details=true, phillips="#2");
      }
      cyl(d=head_diameter+1, h=head_hight*2, anchor=DOWN, $fn=50);
      up(.01) cyl(d=screw_size+1, h=diameter*10, anchor=UP, $fn=50);
    }
  }
}


//back(12) clip();
//fwd(12) clip(diameter = 12, width = 15, screw_size = 2, show_screw = true);
//clip(width=7, show_screw = true);

clip();