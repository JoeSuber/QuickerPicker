use <faninterface_ring.scad>;
use <inside_tracker.scad>;
//use <MCAD/regular_shapes.scad>;
use <eggs.scad>;
// from faninterface
blades=56.9; 		//55.8
roundwall=57.36; 	//min measure, varies wider near corners
coneheight=6;
cubeout=60; 		//59.98
cubein=57.5;  		//56.77
conebase = 62;
walls = 1.2;
house_corner = 9.8;

// from inside_tracker
sleeve_height=57;
sleeve_inside=31;
sleeve_wall=5;

// chosen here!
deckthick= 12;
corn= 2;

//translate([0,0,deckthick+coneheight/2])
//    fanterface();

difference(){
    scale([2,1.3,1]) translate([0,0,deckthick/2])
        minkowski(){
		    cylinder(r=cubeout/2, h=deckthick-corn*2, center=true, $fn=64);
            rotate([90,0,0]) cylinder(h=2, r=corn, center=true, $fn=36);
        }
    translate([0,0,1.2])
    cylinder(r=cubein/2, h=deckthick+.1, $fn=128);
    //cylinder_tube(10,70,3,center=true);
    //translate([0,0, -.1])
    difference(){
        cylinder(r=70, h=5, center=false, $fn=128);
        cylinder(r=65, h=5, center=false, $fn=128);
    }
    translate([0,0, -6.0])
    stopper_egg_basket();
}

