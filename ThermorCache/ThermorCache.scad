include <BOSL2/std.scad>
use <noyau/utils.scad>

// I own and Thermor Malicio 2 water heater. Which is great. Except that the face plate has a bunch
// of LED lights and illuminated buttons. So much so that it light up the bathroom at night
// sufficiently to make it visible from the bedroom. I like the dark, hence this cach is a magnetic
// cover to snap on to just to hide the lights (And the logo, while we're at it)
//
// The print needs to be stopped at the right time to insert the magnets.
//
$fn=100;

FACEPLATE_SIZE = 130;
FACEPLATE_DEPTH = 10;
MARGIN=20;
BOTTOM_MARGIN=35;
NUDGE=1;

module magnet() {
  metal() cuboid([20.2, 6.2, 1.7], anchor=TOP+BACK);
}

module cache() {
  difference () {
      down(1) back((BOTTOM_MARGIN-MARGIN)/2)
          cuboid([FACEPLATE_SIZE+MARGIN*2, FACEPLATE_SIZE+BOTTOM_MARGIN+MARGIN, FACEPLATE_DEPTH+1],
                 rounding = 2, edges="Z", anchor=BOTTOM);
      cuboid([FACEPLATE_SIZE+NUDGE*2, FACEPLATE_SIZE+NUDGE*2, FACEPLATE_DEPTH+NUDGE*2],
             rounding = 2, edges="Z", anchor=BOTTOM);
      yflip_copy() fwd(FACEPLATE_SIZE/2+NUDGE+2) up(FACEPLATE_DEPTH-.5) magnet();
  }
}

down(FACEPLATE_DEPTH) cache();
