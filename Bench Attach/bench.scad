include <BOSL2/std.scad>
include <BOSL2/metric_screws.scad>


module 2d_form(diameter = 10) {
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

module clip(diameter=10, width = 20, screw_size=3, show_screw = false) {
  difference() {
    down(width/2) linear_extrude(height = width) 2d_form(diameter=10);
    
    head_diameter = get_metric_bolt_head_size(screw_size);
    head_hight = get_metric_bolt_head_height(screw_size);
    
    right(diameter/4 + head_hight + 1.5) yrot(-90) {
      if (show_screw) {
        #metric_bolt(headtype="button", size=screw_size, l=10, details=true, phillips="#2");
      }
      cyl(d=head_diameter+.3, h=head_hight*2, anchor=DOWN, $fn=50);
      up(.01) cyl(d=4+.3, h=10, anchor=UP, $fn=50);
    }
  }
}


back(12) clip();
fwd(12) clip(diameter = 12, width = 15, screw_size = 4, show_screw = true);
