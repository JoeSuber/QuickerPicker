// posts for lifting & bearing the stress

use <gearlift.scad>;
use <innerds.scad>;
for (i=[0:1], j=[0:1], k=[0:1]){
    mirror([j,i,0]) translate([12+22*k,12+22*k,0])
        posthold();
    }

module posthold(){
    difference(){
        cube([21.9, 21.9*1, 21.85], center=true);
        translate([0,0,0]) rotate([0,90,0]){
            cylinder(r=6.37/2, h=40, $fn=14, center=true);
            translate([0,0,-12])
                cylinder(r=11.75/2, h=10, $fn=6, center=true);
        }
        translate([0,0,0]) rotate([90,0,0])
            cylinder(r=2, h=40, $fn=14, center=true);
        translate([-65,-50,-6])
            tray();
        translate([0,-6.67,-3]) rotate([0,0,0])
            cbar(ht=120, fat=.9);
    }
}
