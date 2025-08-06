// OpenSCAD simple script for a customizable round tube endcap
// By Magonegro JUNE-2016
// Use your own parameters to customize your endcap.
// Open this in OpenSCAD, then press F6 wait for it to render the CAP and export to stl.
// At print time remember that Buildplate only support ir required tor the upper CAP external overhanging diameter. 
InnerMAXDiameter = 20; // Max inner diameter for the rings
InnerMINDiameter = 18; // Keep same as MAX for cylindrical shape
Rings=6;        // Number of rings.
RingHeight=3;   // Max insertion height = Rings*RighHeight
RingsRatio=1;   // Each ring's diameter will be this ratio the vaule of its precedent. 
                // Enter 1 for uniform rings or 0.97 (for 6 rings) for a conical shape.
                // Beware the inner hole, it should be smaller than the last ring.
CAPOuterDiameter=24; // This should equal tube external diameter
CAPHeight=10; // Height of the CAP, included Fillet
Facets=100; // Resolution parameter, minimum value 3 for a triangular CAP, Defaults to 100 for smooth round CAP. Values lower than 30 could render artifacts
InnerHoleDiameter=InnerMINDiameter/1.5; // Average value
InnerHoleHeight=Rings*RingHeight; // Defaults till the cap
Fillet=6; // Fillet radius for the CAP, should be less or equal than CAPHeight. Zero for no fillet. Should be also less o equal than CAPOuterDiameter/2.

module MakeCap()
{
    difference()
    {
        union()
        {
            // Rings
            for(i=[0:Rings-1])
            {
                Ratio=1-((1-RingsRatio)*(Rings-i));
                translate([0,0,i*RingHeight])
                    cylinder(h = RingHeight, 
                        r1 = Ratio*InnerMINDiameter/2, 
                        r2 = Ratio*InnerMAXDiameter/2, 
                        center = false,$fn=Facets);
            }
            // Cap
            translate([0,0,RingHeight*Rings])
                cylinder(h = CAPHeight-Fillet, 
                    r = CAPOuterDiameter/2, 
                    center = false,$fn=Facets);
            translate([0,0,RingHeight*Rings+CAPHeight-Fillet])
                cylinder(h = Fillet, 
                    r = CAPOuterDiameter/2-Fillet, 
                    center = false,$fn=Facets);
            rotate([0,0,360/2*Facets])
            translate([0, 0, RingHeight*Rings+CAPHeight-Fillet])
                rotate_extrude(convexity = 10,$fn = Facets)
                    translate([CAPOuterDiameter/2-Fillet, 0, 0])
                        intersection()
                            {
                            circle(r = Fillet, $fn = Facets);    
                            square(Fillet);
                            }
        }
    // Hole
    cylinder(h = InnerHoleHeight, 
                r = InnerHoleDiameter/2, 
                center = false,$fn=Facets);
    
    }
}

// Main
MakeCap();
