// Rechargeable phone support.


// The wire charging loop, must be as close as possible as the phone
LoopDiameter = 42;
LoopHeight = 1.7;

// The rubber support for the loop
LoopSupportDiameter = 50;
LoopSupportHeight = 1;

// The electronics circuit
CircuitWidth = 35;
CircuitShortLength = 83;
CircuitMidLength = 86.6;
CircuitFullLength = 91;
CircuitExtremeWidth = 12;
CircuitHeight = 1;
CircuitShortToMid = CircuitMidLength - CircuitShortLength;
CircuitShortToFull = CircuitFullLength - CircuitShortLength;


// The two simple holes in the circuit
PinDiameter = 1.35;
PinSeparation = 31.18 - PinDiameter;
PinFromSide = 17.5;

// The two screwing holes
PostDiameter = 4.05;
PostHole = 2;
PostSeparation = 28 - PostDiameter;

PinPostSeparation = 64.64 - PostDiameter / 2 - PinDiameter / 2;

wall = 1.5;

// Same as mirror() but duplicates the children as opposed to just move it.
module mirrored(v) {
  union() {
    children();
    mirror(v = v)
      children();
  } 
}

module Circuit2D() {
  // A polygon do do a side, mirrored for the other side.
  mirrored([1, 0, 0])
    polygon([
			[0, CircuitShortLength / 2],
      [CircuitWidth / 2, CircuitShortLength / 2],
      [CircuitWidth / 2, -CircuitShortLength / 2],
      [CircuitExtremeWidth / 2, -CircuitShortLength / 2 - CircuitShortToMid],
      [CircuitExtremeWidth / 2, -CircuitShortLength / 2 - CircuitShortToFull],
      [0, -CircuitShortLength / 2 - CircuitShortToFull],
    ]);
}

module CircuitSimulation() {
	PinFromCenterY = CircuitShortLength / 2 - PinFromSide;
	PostFromCenterY = PinFromCenterY - PinPostSeparation;
	difference() {
    linear_extrude(CircuitHeight + .01) Circuit2D();
		mirrored([1, 0, 0]) {
			translate([PinSeparation / 2, PinFromCenterY, 0])
			  cylinder(r = PinDiameter / 2, h = 10 + .02, center = true, $fn = 100);
	  }
		mirrored([1, 0, 0]) {
			translate([PostSeparation / 2, PostFromCenterY, 0])
			  cylinder(r = PostHole / 2, h = 10 + .02, center = true, $fn = 100);
	  }
  }
}

module InductionSimulation() {
	translate([0, 0, LoopSupportHeight / 2 + CircuitHeight]) union () {
    cylinder(r = LoopSupportDiameter / 2, h = LoopSupportHeight + 0.1, center = true, $fn = 200);
		translate([0, 0, LoopSupportHeight])
      cylinder(r = LoopDiameter / 2, h = LoopHeight +.01, center = true, $fn = 200);
  }
}

module inner() {
  union() {
    CircuitSimulation();
    InductionSimulation();
		translate([0, 0, CircuitHeight/ 2])
      cylinder(r = LoopSupportDiameter / 2, h = CircuitHeight + 0.1, center = true, $fn = 200);
  }
}

height = CircuitHeight + LoopSupportHeight + LoopHeight + wall + 0.1;

difference() {
  translate([0,0,height/2 + 0.01]) 
    cylinder(height, 55, 55, center = true, $fn = 500);
  inner();
  //cube([10, 200, 200]);
}