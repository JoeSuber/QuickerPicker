
wide=41.9; 
end_d=7;
metalthick = .9;
hole_d=4.1;

// first the attach points
module crossbar(wide=41.9, end_d=7, thick=metalthick, hole_d=4.1){
	difference(){
		
		hull(){
			translate([-(wide-end_d)/2, 0, 0])
				cylinder(r=end_d/2, h=thick, center=true, $fn=48);
			translate([(wide-end_d)/2, 0, 0])
				cylinder(r=end_d/2, h=thick, center=true, $fn=48);
		}
	//translate([-((wide-end_d)/2) + .4, 0, 0])
				cylinder(r=hole_d/2, h=thick+.1, center=true, $fn=48);
	//translate([((wide-end_d)/2) - .4, 0, 0])
				cylinder(r=hole_d/2, h=thick+.1, center=true, $fn=48);
	}
	// negatives for mount screws centered in holes
	//translate([-((wide-end_d)/2) + .4, 0, -12])
	//			cylinder(r=hole_d/2-.5, h=wide, center=true, $fn=48);
	//translate([((wide-end_d)/2) - .4, 0, -12])
	//			cylinder(r=hole_d/2-.5, h=wide, center=true, $fn=48);
}

// note wires are not stiff
module small_stepper(can_d=28, 
							canheight=19.25, 
							catch_h=20.41,
							catch_rad=9.12/2,
							shaft_h=29,
							shaft_d=5,
							shaft_flat=3,
							shaft_flat_h=6,
							cubelen1=31 - 2.55,
							cubew1=17.5,
							cubelen2=31,
							cubew2=14.6,
							wires=40){
	difference(){
		union(){
			cylinder(r=can_d/2, h=canheight, center=true, $fn=96);
			translate([0,-8, (catch_h - canheight)/2])
				cylinder(r=catch_rad, h=catch_h, center=true, $fn=36);
			translate([0,-8, (shaft_h - canheight)/2])
				cylinder(r=shaft_d/2, h=shaft_h, center=true, $fn=36);
			translate([0,-8, (shaft_h - canheight)/2])
				cylinder(r=shaft_d/2, h=shaft_h, center=true, $fn=36);
			translate([0,(cubelen1-can_d)/2, 0])
				cube([cubew1, cubelen1, canheight], center=true);
			translate([0,(cubelen2-can_d)/2, 0])
				cube([cubew2, cubelen2, canheight], center=true);
			// rear screw access
			hull(){
				translate([0,0,(canheight - metalthick)/2])
					crossbar();
				translate([0,0,(-canheight + metalthick)/2])
					crossbar();
			}
			// negatives for mount screws centered in holes
			translate([-((wide-end_d)/2) + .4, 0, 6])
					cylinder(r=hole_d/2-.5, h=wide, center=true, $fn=48);
			translate([((wide-end_d)/2) - .4, 0, 0])
					cylinder(r=hole_d/2-.5, h=wide, center=true, $fn=48);
			translate([((wide-end_d)/2) - .4, 0, 17])
					cylinder(r=2.6, h=2.5, center=true, $fn=6);
			translate([-((wide-end_d)/2) + .4, 0, 17])
					cylinder(r=2.6, h=2.5, center=true, $fn=6);

			// wire exit
			for (xx=[-4.7, -2.35, 0, 2.35, 4.7]){
				translate([xx, cubelen2/2, canheight/2- 2.2]) rotate([-90,0,0])
					cylinder(r=2, h=wires, center=false, $fn=8);
			// dome and alternate exit
			translate([0, cubelen2/2+(cubelen2-cubelen1)/2, 0]) rotate([0,0,0]) scale([2,.83,1])
				cylinder(r=cubew2/4, h=canheight, center=true, $fn=64);
			}
		}
		// cut out the flats on drive shaft
		translate([0,-7.8+(shaft_d - shaft_flat/2)/2, (shaft_h + (shaft_flat_h/2))/2+.5])
			cube([shaft_d+.1, (shaft_d - shaft_flat)/2+.2, shaft_flat_h+.2], center=true);
		translate([0,-8.2-(shaft_d - shaft_flat/2)/2, (shaft_h + (shaft_flat_h/2))/2+.5])
			cube([shaft_d+.1, (shaft_d - shaft_flat)/2+.2, shaft_flat_h+.2], center=true);
	}
}

// sample
small_stepper();


		

