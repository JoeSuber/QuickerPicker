blades=56.9; //55.8
roundwall=57.36; //min measure, varies wider near corners
coneheight=6;
cubeout=60; //59.98
cubein=57.5;  //56.77
conebase = 62;
walls = 1.2;
house_corner = 9.8;
//after printing the first copy, if bad fit, adjust below
//actual_size = blades;
actual_size = blades; // after print, measured diameter of printed fan-blade hole (for scale-up-or-down)

echo("fanterface(); generates a default 60mm CPU-fan holding rim, including an 'inside' part");

module volcano(inside=blades, based=conebase, ht=coneheight){
	difference(){
		difference(){
			cylinder(r1=based/2, r2=inside/2, h=ht, center=true, $fn=85);
 			cylinder(r=inside/2, h=ht+.1, center=true, $fn=85);
		}
		difference(){
			cube([based+1,based+1,ht+.1], center=true);
			cube([cubein, cubein, ht+.1], center=true);
		}
	}
}

module fan_house_inset(interior=cubeout - house_corner, exterior=65, corner_rad=house_corner/2){
	// interior is for use with minkowski to get outside profile of fan-housing cut-out
	difference(){
	// first make the solid tapered outside
		linear_extrude(height = coneheight, center = true, convexity = 10, twist = 0, slices = 30, scale = cubeout/exterior){
			minkowski(){
				square([exterior-house_corner, exterior-house_corner], center=true);
				circle(r=house_corner/2, $fn=85);
				}
		}
		// next take away the interior
		minkowski(){
			cube([interior, interior, 25], center=true);
			cylinder(r=corner_rad+.2, h=.01, $fn=85);
		}
	}
}

module fanterface (){
	scale([(blades)/actual_size, (blades+.5)/actual_size, 1])
		volcano();

	scale([(blades)/actual_size, (blades+.5)/actual_size, 1])
	fan_house_inset();
}

fanterface();
