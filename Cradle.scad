$fa = 9;
$fs = 0.5;


// Gap for cut out objects
gap = 0.25; //[0 : 1]

lowerShaftHeight = 16.3;
lowerShaftLength=26.8;
lowerShaftWidth=8.5;


upperShaftHeight = 20.5;
upperShaftWidth = 11;
upperShaftLength = 30;

totalHeight = upperShaftHeight + lowerShaftHeight;

usbheight = 16.5;
usbwidth = 6.7;
usblength = 10.9;

usbCableEndDiameter = usbwidth;
usbCableSocketHeight = 8.5;

cableDiameter = 4;
trenchWidth = cableDiameter * .8;

module skew(x = 0, y = 0) {
    multmatrix([
    [ 1, 0, x, 0],
    [ 0, 1, y, 0],
    [ 0, 0, 1, 0],
    [ 0, 0, 0, 1]]) children();
}

module shaft(height = 10, width = 10, length = 20) {
    translate([(length - width) / -2, 0, 0])
        cylinder(height, r = width / 2);
    translate([0, 0, height / 2])    
        cube([length - width, width, height], center = true);
    translate([(length - width) / 2, 0, 0])
        cylinder(height, r = width / 2);
}

module usb() {
    color("red") {
        shaft(usbheight, usbwidth, usblength);
        
        translate([0, 0, usbheight]) {
            
            skew = (usblength - usbCableEndDiameter) / 2;
            
            translate([0, usbCableEndDiameter / 2, 0])
            rotate([90,0,0])
                linear_extrude(usbCableEndDiameter)
                    polygon(points = [[0, usbCableSocketHeight], [-skew, 0], [skew,0]] );

            
            translate([(usblength - usbCableEndDiameter) / -2, 0, 0])
                skew(x = skew / usbCableSocketHeight) cylinder(h = usbCableSocketHeight, r = usbCableEndDiameter / 2);

            translate([(usblength - usbCableEndDiameter) / 2, 0, 0])
                skew(x = skew / -usbCableSocketHeight) cylinder(h = usbCableSocketHeight, r = usbCableEndDiameter / 2);
            
            
            translate([0, 0, usbCableSocketHeight]) {
                cylinder(r = cableDiameter / 2, h = 30);
            }
        }
        
        
    }
}

module snapShaft(h = 10, w = 4, thickness = 1, extent = 1, gap = 1, inset = 0) {
    
    rearGap = gap / 2+ extent;
    
    mirror([0, 0, 1])
    translate([w / -2, inset, 0]) {
        difference() {
            
            translate([-gap, -gap, 0]) cube([w + 2*gap, thickness + gap + rearGap, h]);
            
            cube([w, thickness, h]);

        }
        
        if (inset > 0) {
            translate([-gap, -inset, 0])
            cube([w + 2 * gap, inset - gap, gap]);
        }
    
    }
}

    snapGap = .9;
    snapWidth = 4;
    snapExtend = 1;
    snapThickness = 1.2;
    snapInset = 0.8;


module cutout() {
    translate([0, -1.1, -.2])
    rotate([-2.8, 0, 0])  {
   #usb();
    
        
    translate([trenchWidth / -2, 0, 0])
        cube([trenchWidth, upperShaftWidth, totalHeight * 1.1]);
    }
    

    *snapTransformation() {
               snapShaft(h = lowerShaftHeight, w = snapWidth, extent = snapExtend, inset = snapInset, gap = snapGap, thickness = snapThickness);
                        
    }
}

module mirrorCopy(pane) {
    children();
    mirror(pane) children();
}

module snapTransformation() {
    rotate([0, 0, -90])
    mirrorCopy([0, 1,0])
        translate([0, lowerShaftLength / -2, totalHeight]) {
                children();
            }
}

module body() {
        intersection() {
            shaft(upperShaftHeight, upperShaftWidth, upperShaftLength);
            cube([upperShaftLength - 1, upperShaftWidth, upperShaftHeight * 2], center = true);
        }
        
        translate([0, 0, upperShaftHeight]) {
            color ("green") shaft(lowerShaftHeight, lowerShaftWidth, lowerShaftLength);
            
        }

    *snapTransformation() {
        translate([snapWidth / -2, -snapExtend, 0]) {
            intersection() {
                cube([snapWidth, snapExtend + snapInset + snapThickness, snapThickness]);
                translate([snapWidth / 2, lowerShaftWidth / 2, 0]) cylinder(r = lowerShaftWidth / 2, h =snapThickness);
            }
        }
        
   }

}

module torus(rr = 10, rb = 1, angle=360) {
    rotate_extrude(angle = angle) {
        translate([rr, 0, 0]) circle(r = rb);
    }
}

module clip() {
    
    clipHeight = cableDiameter + 4;
    cableRadius = cableDiameter / 2;
    clipLength = upperShaftLength;
    clipWidth = upperShaftWidth;
    
    tunnelRadius = 1.5* cableDiameter;
    
    difference() {
        union() {
            difference() {
                shaft(clipHeight, clipWidth, clipLength);
                
            
            cylinder(h = clipHeight, r = cableRadius);
            
            rotate([0, 0, 47])
            translate([-clipLength / 2, 0, clipHeight / 2])
                cube([clipLength, clipLength, clipHeight]);
            
           
            }
        
            supportRadius = (tunnelRadius - cableDiameter) / 2;
        
        
            translate([0, 0, clipHeight / 2])
                rotate([0, 0, 45])
                    torus(rr = supportRadius + cableRadius, rb = supportRadius, angle = 225);
        }
    
        translate([0, 0, clipHeight / 2])
            torus(rr = tunnelRadius, rb = cableRadius);

        translate([0, trenchWidth / -2, 0])
            rotate([0, 0, -12])
                cube([clipLength / 2, trenchWidth, clipHeight]);
        
        translate([0, 0, clipHeight / 2])
            difference() {
                
                cylinder(r = tunnelRadius + cableRadius, h = clipHeight / 2);
                cylinder(r = tunnelRadius + cableRadius - trenchWidth, h = clipHeight / 2);
                
            }

    }
    
}

!difference() {
    body();

    cutout();
    }
    
clip();


            
