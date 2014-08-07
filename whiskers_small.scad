use<violated_gears.scad>;
use<gear_ups.scad>;
use<608zz_run_free.scad>;
include<MCAD/constants.scad>;

$fn=64;
in_can = 60/.93;

//translate([0,0,-1])
//	mbox(mb=in_can);



difference(){
	union(){
	scale([.319,.319,.319])
		bevel_gear_pair (
			gear1_teeth = 41,
			gear2_teeth = 8,
			axis_angle = 90,
			outside_circular_pitch=1000);

	}
	cylinder(r=in_can/1.7, h=40, center=true, $fn=128);
	translate([0,47.8,-5])
	my_bearing_cutter(shaftlen=10);
}

