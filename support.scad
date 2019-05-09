// Rechargeable phone support.


// The wire charging loop, must be as close as possible as the phone
LoopDiameter = 42;
LoopHeight = 1;

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
    linear_extrude(1) Circuit2D();
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
    cylinder(r = LoopSupportDiameter / 2, h = LoopSupportHeight, center = true, $fn = 100);
		translate([0, 0, LoopSupportHeight])
      cylinder(r = LoopDiameter / 2, h = LoopHeight, center = true, $fn = 100);
  }
}

CircuitSimulation();
InductionSimulation();