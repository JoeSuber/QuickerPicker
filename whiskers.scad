// note we are not using the library "involute_gears.scad" that is in the openscad sources

use<violated_gears.scad>;
use<gear_ups.scad>;
use<608zz_run_free.scad>;
include<MCAD/constants.scad>;

// must generate two different .stl files for import to other modules
// whiskers_small.stl = used by turner.scad... runners & drive fit to 608zz bearings
// whiskers_big.stl = main ring-bevel gear all by itself for import

$fn=96;
in_can = 60/.93;
downscale = .319;

echo("whiskers.scad says 'in_can' diameter = ", in_can);
echo("whiskers.scad says downscale of bevel gears is = ", downscale);

//translate([0,0,-1])
//	mbox(mb=in_can);

difference(){
	union(){
	scale([downscale,downscale,downscale])
		bevel_gear_pair (
			gear1_teeth = 41,
			gear2_teeth = 7,
			axis_angle = 90,
			outside_circular_pitch=1000);

	}
// expand radius of cylinder to hide big gear & export small
	cylinder(r=in_can/2, h=40, center=true, $fn=128);
	translate([0,47.8,-5])
	my_bearing_cutter(shaftlen=10);
	
// comment out below to see small gear
	translate([0, in_can-15, 0])
		#cube([20,20,20], center=true);
}

