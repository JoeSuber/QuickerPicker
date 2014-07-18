module d_shaft(){
	difference(){
		cylinder(r=3.4/2, h=10, center=true, $fn=64);
		// d shaped shaft
		translate([3.4/2,0,-7.5/2])
			cube([1.25,3,20], center=true);
	}
}


module threadwheel() {
	difference(){
		union(){
			cylinder(r=8.3/2, h=5, center=true, $fn=64);
			translate([0,0,1.55])
				cylinder(r=5.1/2, h=5+3.1, center=true, $fn=36);
		}
	d_shaft();
	rotate([0,100,0]) translate([0,2.4,0])
		cylinder(r=.6, h=30, center=true, $fn=6);
	}
}


threadwheel();