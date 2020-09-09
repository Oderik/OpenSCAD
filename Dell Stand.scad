rubberWidth = 6.3;
rubberDistance = 15.7;
rubberElevation = 2.5;

rubberAura = 7;
auraElevation = 1;

rubberAuraElevation = rubberElevation - auraElevation;

baseHeight = 5;

baseWidth = 180;
baseLength = 130;

mainAngle = 30;

notebookFrontHeight = 15;
ventStart = 150;


pillarSize = 30;

pillarMaxHeight = baseLength * sin(mainAngle);


module plinth() {
    plinthSize = (2 * rubberAura + rubberWidth) * 1.1;
    plinthHeights = plinthSize / 2;
    
    cube([plinthSize, plinthSize, plinthSize], center = true);
    
    translate([0, 0, -plinthHeights])
        resize([plinthSize, plinthSize, plinthHeights])
            rotate([0, 0, 45])
                cylinder(h=20, r1=0, r2=1, $fn=4);
}

module notebook() {
    
    
}

notebook();

*plinth();


difference() {
    translate([-baseWidth / 2, 0, 0])
        rotate([90, 0, 90])
            linear_extrude(baseWidth)
                polygon(points = [[-baseHeight, 0], [baseLength, 0], 
                [baseLength, baseHeight + sin(mainAngle)  * baseLength], [baseLength - pillarSize, baseHeight + sin(mainAngle) * (baseLength - pillarSize)], [baseLength - pillarSize, baseHeight],
                    [0, baseHeight], [-baseHeight * cos(mainAngle), baseHeight + notebookFrontHeight*sin(mainAngle)], [baseHeight - baseHeight * cos(mainAngle), baseHeight + cos(mainAngle) * notebookFrontHeight - sin(mainAngle) * baseHeight], [-baseHeight - sin(mainAngle) * (notebookFrontHeight + baseHeight/ 2), cos(mainAngle) * (notebookFrontHeight + baseHeight / 2)]
                ]);
    
    translate([-baseWidth / 2 + pillarSize, -3 * baseHeight, 0]) {
    difference() {
            cube([baseWidth - 2 * pillarSize, baseLength + 4 * baseHeight, pillarMaxHeight + baseHeight]);
        
        translate([0, 3* baseHeight + baseLength - pillarSize, 0]) cube([baseWidth, pillarSize, baseHeight]);
    }
    }
    
}