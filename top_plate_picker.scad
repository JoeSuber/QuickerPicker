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

use <inside_tracker.scad>;
sleeve(outside_r=cubein/2 + sleeve_wall, 
		inside_r=cubein/2,
		ht=sleeve_height);

translate([0,0,sleeve_height/2 - coneheight]){
	difference(){
		scale([2,1.2,1])
		cylinder(r=conebase/2, h=coneheight*2, center=true, $fn=128);
		translate([0,0,1])
		cylinder(r=roundwall/2, h=coneheight*2 -1, center=true, $fn=64);
	}
}

translate([0,0,sleeve_height/2+coneheight/2])
	import("faninterface_ring.stl");