use <quicker_pickerupper5.scad>;
use <MCAD/involute_gears.scad>;
use <my_motors.scad>;
use <MCAD/hardware.scad>;

baserad=50;
tallness = 360;

/*
module gear (
	number_of_teeth=15,
	circular_pitch=false, diametral_pitch=false,
	pressure_angle=28,
	clearance = 0.2,
	gear_thickness=5,
	rim_thickness=8,
	rim_width=5,
	hub_thickness=10,
	hub_diameter=15,
	bore_diameter=5,
	circles=0,
	backlash=0,
	twist=0,
	involute_facets=0,
	flat=false)
{
*/
module bar(out=19.35, in=16.1, len=tallness, fatten=.6){
	difference(){
		cube([out+fatten/2,out+fatten/2,len], center=true);
		cube([in-fatten/2,in-fatten/2,len+.1], center=true);
	}
}

module tripod(rad=baserad/1.76, lift=tallness/2-6, extrafat=.1, xtra=14){
	for (i=[0,120, 240]){
		translate([rad*cos(i), rad*sin(i), lift]) rotate([0,0,i])
			bar(fatten=extrafat);

	}
	for (i=[0,120, 240]){
		translate([(xtra+rad)*cos(i), (xtra+rad)*sin(i), -4]) rotate([0,89,i]){
			z608z();
			// d=6.4, h=2.7, rodd=3.1, rodlen=19, hdled=3, hdrad=6/2, capture_channel=20, channel_dir=90, fat=.1
			m3nut(d=12.41, h=6.3, rodd=6.26, rodlen=60, hdled=3.95, hdrad=6.26/2, capture_channel=67, channel_dir=90);
		}
	}
}

module bases (thkness=18){
	difference(){
		cylinder(r1=baserad, r2=baserad-4, h=thkness, center=true, $fn=128);
		tripod();
		translate([0,0,tallness/2])
			cylinder(r=6.05, h=tallness, center=true, $fn=32);
		translate([-baserad+15,0,0]) rotate([0,180,45])
		
			stepper_motor_mount(17,slide_distance=0, mochup=true, tolerance=.1);
	}
}

bases();


