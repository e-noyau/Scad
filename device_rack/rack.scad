
include <BOSL/constants.scad>
use <BOSL/sliders.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <noyau/utils.scad>;


Depth = 15;
Width = 20;
Floor = 3;
Hole = 35;
Height = 100;
PrinterSlop = .05;


module base() {
   xrot(90) xmove(Hole/2) mirrored([1,0,0]) xmove(-Hole/2) {
    cuboid(
        size=[Hole/2,Depth,Floor],
        p1=undef, p2=undef,
        chamfer=undef,
        fillet=undef,
        edges=EDGES_TOP,
        trimcorners=true,
        align=[1,0,1]
    );
    difference() {
        zmove(Floor) rail(l=Depth, w=12, h=10, chamfer=1, ang=30, orient=ORIENT_Y);
        cuboid([6-.01, Depth+0.01, 10+Floor + .01], align=[-1,0,1]);
    };
  };
}

module support() {
  xrot(90) difference() {
    union() {
      xmove(-13) zmove(Floor) yrot(-70) cuboid(
        size=[Height,Depth-0.01,Floor],
        p1=undef, p2=undef,
        chamfer=undef,
        fillet=undef,
        edges=EDGES_ALL,
        trimcorners=true,
        align=[1,0,-1]
      );
      zmove(20-Floor+1) xrot(180)
          slider(l=Depth, w=12, h=10, chamfer=0, base=5, wall=5, ang=30, orient=ORIENT_Y, align=V_UP, slop=PrinterSlop);
    };
    xmove(-19) zmove(Floor) yrot(-70) cuboid(
      size=[Height*2,Depth*2,Floor*2],
      p1=undef, p2=undef,
      chamfer=undef,
      fillet=undef,
      edges=EDGES_ALL,
      trimcorners=true,
      align=[1,0,-1]
    );
    zmove(.0001) cuboid(
        size=[Hole/2,Depth*2,Floor],
        p1=undef, p2=undef,
        chamfer=undef,
        fillet=undef,
        edges=EDGES_TOP,
        trimcorners=true,
        align=[-1,0,1]
    );
  };  
}

module front_connector() {
  difference() { 
    union() {
      slider(l=Width*2 + Depth, w=12, h=10, chamfer=1, base=5, wall=5, ang=30, orient=ORIENT_Y, align=V_UP, slop=PrinterSlop);
      cuboid(
          size=[10, Width*2 + Depth,Floor+ 15],
          p1=undef, p2=undef,
          chamfer=undef,
          fillet=undef,
          edges=EDGES_TOP,
          trimcorners=true,
          align=[-1,0,1]
      );
    };
    zmove(-.5) xmove(-5) cuboid(
              size=[11, Width*2 + Depth + 1,Floor+ 16],
              p1=undef, p2=undef,
              chamfer=undef,
              fillet=undef,
              edges=EDGES_TOP,
              trimcorners=true,
              align=[-1,0,1]
    );
  };  
}

module rear_connector() {
  difference() {
    union() {
      cuboid(
          size=[22,Width*2+Depth+0.1,Floor],
          p1=undef, p2=undef,
          chamfer=undef,
          fillet=undef,
          edges=EDGES_TOP,
          trimcorners=true,
          align=[0,0,1]
      );
      zmove(Floor) rail(l=Width*2+Depth+0.1, w=12, h=10, chamfer=1, ang=30, orient=ORIENT_Y);
    };
    zmove(-1) xmove(-6) cuboid(
        size=[12,Width*2+Depth+3,20],
        p1=undef, p2=undef,
        chamfer=undef,
        fillet=undef,
        edges=EDGES_TOP,
        trimcorners=true,
        align=[0,0,1]
    );  
  };
}

module assembly() {
  plastic() spread([-Hole,0,0], [-Hole*3,0,0], n=3) mirrored([0,1,0]) ymove(Width) xrot(-90) base();
  metal() spread([0,0,0], [-Hole*2,0,0], n=3) mirrored([0,1,0]) ymove(Width) xrot(-90) support();
  //iron() zmove(18) xmove(Hole) yrot(180) front_connector();
  stainless() zmove(18) xmove(-Hole*3) zrot(180) yrot(180) front_connector();
  rear_connector();
}

assembly();
xmove(80) zmove(Depth/2) base();
xmove(200) support();
xmove(-200) front_connector();
ymove(200) rear_connector();
ymove(-200) union() { spread([-Hole,0,0], [-Hole*3-0.01,0,0], n=3) base(); };
