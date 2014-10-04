// posts for lifting & bearing the stress

use <gearlift.scad>;
use <innerds.scad>;
//for (i=[0:1], j=[0], k=[0:1]){
//    mirror([j,i,0]) translate([12+22*k,12+22*k,0])
        //posthold();
 //       bighold();
 //   }

//weightplug();
tubesquare();

module posthold(){
    difference(){
        cube([21.9, 21.9*1, 21.85], center=true);
        translate([0,0,0]) rotate([0,90,0]){
            cylinder(r=6.4/2, h=40, $fn=14, center=true);
            translate([0,0,-12])
                cylinder(r=12.75/2, h=10, $fn=6, center=true);
        }
        translate([0,0,0]) rotate([90,0,0])
            cylinder(r=1.5, h=40, $fn=14, center=true);
        translate([0,0,0]) rotate([90,0,90])
            #cylinder(r=1.5, h=40, $fn=14, center=true);
        //translate([-65,-50,-6])
        //    tray();
        translate([0,-6.67,-3]) rotate([0,0,0])
            cbar(ht=120, fat=.9);
    }
}

module bighold(){
    difference(){
        cube([21.9, 21.9*1, 21.85], center=true);
        translate([0,0,0]) rotate([0,90,0]){
            cylinder(r=6.4/2, h=40, $fn=14, center=true);
            translate([0,0,-12])
                cylinder(r=12.75/2, h=10, $fn=6, center=true);
        }
        translate([0,0,-3.5]) rotate([90,0,0])
            cylinder(r=1.5, h=40, $fn=14, center=true);
        translate([0,0,3.5]) rotate([90,0,0])
            cylinder(r=1.5, h=40, $fn=14, center=true);
        translate([0,0,0]) rotate([0,0,0])
            #cylinder(r=1.5, h=40, $fn=14, center=true);
        //translate([-65,-50,-6])
        //    tray();
        translate([0,-6.67,-3]) rotate([0,0,0])
            bbar(ht=120, fat=.9);
    }
}

module weightplug(OD=27.9, h=23, nutOD=22.2){
    difference(){
        cylinder(r=OD/2, h=h, center=true, $fn=128);
        cylinder(r=nutOD/2, h=h+0.1, center=true, $fn=6);
    }
}

module tubesquare(ID=15.95, walls=1.6){
    rotate([0,-90,0])
    rotate([0,0,45])
    union(){
    difference(){
        union(){
            rotate_extrude(convexity=10, $fn=64){
                square([ID+walls*2,ID+walls*2]);

            }
            translate([-ID-walls,-ID,+walls])
                cube([ID,ID,ID], center=false);
            translate([0,+walls,+walls])
                cube([ID,ID,ID], center=false);
        }
        translate([-walls,-ID-walls*2, -0.05])
            cube([ID+walls*3,ID+walls*3,ID+walls*2+.1], center=false);
        for (i=[-1,0], j=[0,1]){
            translate([(ID+walls*2)*i, (ID+walls*2)*i, (ID+walls)*j-.05])
                cube([ID+walls*2+.1, ID+walls*2+.1, walls+.1], center=false);

        }
        translate([-(ID+walls*2), -(ID+walls*2), -0.05])
            cube([walls,ID+walls*2+0.1, ID+walls*2+0.1], center=false);
        translate([0, (ID+walls), -0.05])
            cube([ID+walls*2+0.1, walls+0.1, ID+walls*2+0.1], center=false);
        translate([ID/2,ID,ID/2+walls]) rotate([0,90,-180]){
            cbar(ht=120, fat=.5);
        translate([0, ID+ID/2, ID+ID/2]) rotate([-90,0,0]) 
            cbar(ht=120, fat=.5);
        }
        translate([-ID+walls*2, ID-walls*2, ID/2+walls]) rotate([90,0,45]) 
            cube([ID+walls*2+.5, ID+walls*2+.5, 2*walls-0.1], center=true);
        
        }
            // reinforcement for printing
            translate([-ID+walls*2+walls, ID-walls*2-walls*2, ID/2+walls]) rotate([90,0,45])
                cube([ID+walls*2+.5, walls+.5, 2*walls-0.1], center=true);
    }
}
