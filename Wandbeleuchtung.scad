$fa = 4;
$fs = .75;

stripeThickness = 3;
stripeWidth = 10;

blindThickness = 1.5;
blindSize = 20;

glassThickness = 6;

screwRadius = 2.9;

screwCenterEdgeDistance = 30;

gap = 0.4;
halfGap = gap /  2;

screwEdgeDistance = screwCenterEdgeDistance - screwRadius;

thickness = min(
    blindThickness,
    blindSize - blindThickness - glassThickness - stripeWidth);

tubeThickness = 3;

tubeHeight = blindSize - glassThickness;

innerTubeRadius = screwRadius + thickness;
innerTubeDiameter = 2 * innerTubeRadius;

tubeRadius = innerTubeRadius + gap + thickness;
tubeDiameter = tubeRadius * 2;

supportWidth = 2 * blindSize + tubeDiameter;

fixtureHeight = tubeHeight - blindThickness;

cornerSupportOvershoot = 3 * tubeRadius;

echo("thickness", thickness);
echo("tubeRadius", tubeRadius);



module glass() {
    color("lightblue", 0.3)
        translate([0, 0, tubeHeight])
            difference() {
                translate([-screwCenterEdgeDistance, -screwCenterEdgeDistance])
                    cube([2 * screwCenterEdgeDistance, 2 * screwCenterEdgeDistance, glassThickness]);
                
                cylinder(r = screwRadius, h = glassThickness);

            }
}

module blind() {
   
    color("white")
        translate([- screwCenterEdgeDistance, screwCenterEdgeDistance, 0]) {
    
            translate([0, blindThickness -blindSize]) cube([screwCenterEdgeDistance * 2, blindSize, blindThickness]);
            cube([screwCenterEdgeDistance * 2, blindThickness, blindSize]);
        }
    
}

module tube(rI, rO, h) {
    difference() {
        union() {
            children();
            
            cylinder(r = rO, h = h);
        }
        
        cylinder(r = rI, h = h);
    }
}
module base() {
    color("green") {
        tube(screwRadius, innerTubeRadius, tubeHeight) {
            translate([-innerTubeRadius, 0, 0])
                cube([innerTubeDiameter, screwCenterEdgeDistance + blindThickness, blindThickness]);
            
            translate([-innerTubeRadius, screwCenterEdgeDistance, 0])
                cube([innerTubeDiameter, blindThickness, blindSize]);
            
            translate([-innerTubeRadius, screwCenterEdgeDistance - stripeThickness, blindThickness])
                cube([innerTubeDiameter, stripeThickness, thickness]);
            
            translate([supportWidth / -2, screwCenterEdgeDistance + blindThickness, 0])
                cube([supportWidth, thickness, blindSize]);

            translate([supportWidth / -2, 0, 0])
                cube([supportWidth, screwCenterEdgeDistance + blindThickness - blindSize, blindThickness]);
            
            cylinder(r = tubeRadius, h = thickness);
        }
    }
}


module fixture() {
    color("red") {
        translate([0, 0, blindThickness]) {
            difference() {
                tube(innerTubeRadius + gap, tubeRadius, fixtureHeight) {
                    translate([supportWidth / -2, 0, 0])
                        cube([supportWidth, screwCenterEdgeDistance, thickness]);
                    
                    translate([0, screwCenterEdgeDistance - stripeThickness - thickness, 0]) {
                        cylinder(r = thickness, h = fixtureHeight);
                        
                        translate([supportWidth / -2 + thickness, 0, 0])
                            cylinder(r = thickness, h = fixtureHeight);
                        translate([supportWidth / 2 - thickness, 0, 0])
                            cylinder(r = thickness, h = fixtureHeight);
                            
                    }
                }

                translate([-innerTubeRadius, screwCenterEdgeDistance - stripeThickness, 0])
                    cube([innerTubeDiameter, stripeThickness, thickness]);
            }
        }
    }
}

module mirrorCopy(v = [1, -1, 0]) {
    mirror(v) children();
    children();   
}

module cornerBase() {
    color("green") {
        tube(screwRadius, innerTubeRadius, tubeHeight) {
            cylinder(r = tubeRadius, h = thickness);
            
                        
            
            cube([screwCenterEdgeDistance + blindThickness, screwCenterEdgeDistance + blindThickness, blindThickness]);
            
            
            mirrorCopy() {
                
                translate([-cornerSupportOvershoot, 0, 0])
                    cube([cornerSupportOvershoot + screwCenterEdgeDistance - blindSize + blindThickness, screwCenterEdgeDistance - blindSize + blindThickness, blindThickness]);
                
                translate([0, screwCenterEdgeDistance, 0]) {
                    cube([screwCenterEdgeDistance + blindThickness, blindThickness, blindSize]);
                    
                    translate([-cornerSupportOvershoot, blindThickness, 0])
                        cube([screwCenterEdgeDistance + 2 * blindThickness + cornerSupportOvershoot, thickness, blindSize]);
                }
            }
            
        }
    }
}

module cornerFixture() {
    color("red") {
        translate([0, 0, blindThickness]) {
            tube(innerTubeRadius + gap, tubeRadius, fixtureHeight) {
                mirrorCopy() {
                    translate([-cornerSupportOvershoot, 0, 0])
                        cube([screwCenterEdgeDistance + cornerSupportOvershoot, screwCenterEdgeDistance, thickness]);
                    
                        translate([0, screwCenterEdgeDistance - stripeThickness - thickness, 0]) {
                            cylinder(r = thickness, h = fixtureHeight);
                            
                            translate([-cornerSupportOvershoot + thickness, 0, 0])
                                cylinder(r = thickness, h = fixtureHeight);
                            translate([+cornerSupportOvershoot - thickness, 0, 0])
                                cylinder(r = thickness, h = fixtureHeight);
                        }
                }
                
            }
        }
    }
}



module part() {
    base();
    fixture();
}

module cornerPart() {
    !difference() {
        cornerBase();
        translate([screwCenterEdgeDistance - stripeThickness, screwCenterEdgeDistance, blindThickness + thickness])
            cube([stripeThickness, thickness + blindThickness, blindSize]);
    }
    cornerFixture();
}

*part();
cornerPart();
#blind();
#rotate([0, 0, -90]) blind();
*#glass();