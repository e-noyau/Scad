include <BOSL2/std.scad>

// Lost corner for a PVC window.

top_length = 60;
shift = 1;
height = 11;

box_length  = 48;
box_width = 21;
thickness = .9;

overlay_lenght = top_length-box_width;
overlay_shift = 3.3;
overlay_height = 2;

corner_length = 10;

bottom_length = top_length + shift;
bottom_overlay_length = overlay_lenght + overlay_shift;

module corner_shell () {
  difference() {
    union() {
      difference() {
        // Base
        prismoid(size1=[bottom_length,bottom_length], size2=[top_length,top_length],
                 h=height, shift=[shift/2,shift/2], anchor=BOTTOM+RIGHT+BACK);
             
        back(1) right(1) cuboid([11,11,height*3], anchor=RIGHT+BACK);

        // Removing the inside
        down(thickness) back(thickness)
        right(thickness)
        prismoid(size1=[bottom_length,bottom_length],
                 size2=[top_length,top_length],
                 h=height, shift=[shift/2,shift/2], anchor=BOTTOM+RIGHT+BACK);

      }
      // Adding back the core inside
      down(.001) fwd(bottom_length-box_length) left(bottom_length-box_length) 
      difference() {
        prismoid(size1=[box_length,box_length],
                 size2=[box_length-shift,box_length-shift],
                 h=height, shift=[shift/2,shift/2], anchor=BOTTOM+RIGHT+BACK);
        
                 fudge_w = - thickness*2;
                 fudge_l = fudge_w + shift;
        down(.001) fwd(box_length-box_width) left(thickness)
            cuboid([box_length + fudge_w, box_width + fudge_l, height-thickness], anchor=BOTTOM+RIGHT+BACK);
        down(.001) fwd(thickness) left(box_length-box_width)
                cuboid([box_width + fudge_l, box_length + fudge_w, height-thickness], anchor=BOTTOM+RIGHT+BACK);
      }
    }
    
    //Removing the middle
    back(.01) right(.01) 
    cuboid([top_length-box_width, top_length-box_width, height*3], anchor=RIGHT+BACK);
  }
}

module top_shell() {
  up(height)
  difference() {
    // #rect_tube(size1=[bottom_overlay_length,bottom_overlay_length],
    //           size2=[overlay_lenght,overlay_lenght],
    //           isize1=[bottom_overlay_length-thickness,bottom_overlay_length-thickness],
    //           isize2=[overlay_lenght-thickness,overlay_lenght-thickness],
    //           //shift=[overlay_shift/2,overlay_shift/2],
    //           h=overlay_height, anchor=BOTTOM+RIGHT+BACK
    //         );
    prismoid(size1=[bottom_overlay_length,bottom_overlay_length],
             size2=[overlay_lenght,overlay_lenght],
             h=overlay_height, shift=[overlay_shift/2,overlay_shift/2], anchor=BOTTOM+RIGHT+BACK);
    back(.01) right(.01) 
    down(thickness) cuboid([overlay_lenght,overlay_lenght, overlay_height],
           anchor=BOTTOM+RIGHT+BACK);

    //
    //
    down(.001) prismoid(size1=[corner_length,corner_length],
            size2=[corner_length+overlay_shift*2,corner_length+overlay_shift*2],
            h=overlay_height+.002, anchor=BOTTOM+RIGHT+BACK);
   }
}

//yrot(-95.15) right(bottom_length) union() {
// yrot(180)
// {
//   corner_shell();
//   top_shell();
// }

right(10) fwd(10) up(height) yrot(180) corner_shell();
up(overlay_height) yrot(180) down(height) top_shell();
