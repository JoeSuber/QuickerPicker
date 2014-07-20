use <MCAD/involute_gears.scad>;
use </home/suber1/SuckUp/cone_holio.scad>;
use </home/suber1/SuckUp/faninterface_ring.scad>;

//gear (circular_pitch=700,
//	gear_thickness = 12,
//	rim_thickness = 15,
//	hub_thickness = 17,
//	circles=8);
// or...
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
$fn=80;
measurebox= 26.69;
mbigbox=62.5;

module mbox(mb=measurebox){
	difference(){
		cube([mb,mb,.6], center=true);
		cube([.93*mb,.93*mb,1.1], center=true);
	}
}

// mbox();

gear (number_of_teeth=21,
	circular_pitch=2*23.2*3.141592654,
	gear_thickness = 1.46,
	rim_thickness = 2,
	hub_thickness = 5,
	pressure_angle=23,
	clearance = 0.3,
	rim_width=3,
	hub_diameter=9,
	bore_diameter=5.6,
	circles=0,
	backlash=0,
	twist=0,
	involute_facets=0,
	flat=false);

module airgear(mbig=mbigbox, holescale=0.78, tranz=0, spin=0){
	translate([46,0,7+tranz]) rotate([180,0,spin]){
		//mbox(mb=mbig);
		difference(){
			gear (number_of_teeth=75,
				circular_pitch=2*23.2*3.141592654,
				gear_thickness = 1.46,
				rim_thickness = 7,
				hub_thickness = 7,
				pressure_angle=23,
				clearance = 0.3,
				rim_width=40,
				hub_diameter=mbig,
				bore_diameter=0,
				circles=0,
				backlash=0,
				twist=0,
				involute_facets=0,
				flat=false);
			// air holes
			scale([holescale,holescale,1])
			linear_extrude(height = 14.2, center = true, convexity = 10, twist = 0, slices = 30, scale = 1){
				pieslice(incoming=mbigbox, rimin=5.1, angin=55);
			}
			// switch bumper track-ring
			translate([0,0,6]) rotate([0,180,30])
				volcano();
			translate([0,0,6]) rotate([0,180,60])
				volcano();
				//difference(){
				//	cylinder(r=conebase/3, h=7, center=true, $fn=128);
				//	cylinder(r=cubein/3, h=7.1, center=true, $fn=128);
				//}
		}
	}
}

airgear();



//for alignment checking
//airgear(tranz=7, spin=90);
	


