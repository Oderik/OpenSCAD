bars = [[0, 31], [13, 11], [12, 21], [12,10], [14, 41], [13, 31], [19, 40]];

module barcode(bars, h=10, index = 0) {
    if (index < len(bars)) {
        bar = bars[index];
        
        translate([bar[0], 0]) {
            square([bar[1], h]);
            
            translate([bar[1], 0]) barcode(bars, h, index + 1);
        }
              
    }
}

color("lightgreen")
    linear_extrude(5)
        translate([52, 0]) 
            scale(0.07)
                barcode(bars, 255);
    
color("black")
    linear_extrude(5) 
        translate([9, 0])
            text("Code", font="Space Frigate");
        
color("black")
    linear_extrude(5)
        translate ([0, -12])
            text("Elements", font="Space Frigate");
