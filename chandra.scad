lenseD = 60;
depth = 20;
rim = 4;
center=18;

flange();

mirror([1,0,0])
	translate([-lenseD/2-center/2,0,0])
		lensebody();

translate([-lenseD/2-center/2,0,0])
	lensebody();
//torus();

module torus(r=lenseD/2, circ=rim){
	rotate_extrude($fn=96){
		translate([r,0,0])
			circle(r=circ, $fn=36);
		}
}

module head(){
	scale([4,7,1])
		sphere(r=lenseD, $fn=64);
}

module flange(rad=lenseD/2, flare=0.4){
	rotate_extrude($fn=64){
		translate([rad,0,0]) rotate([0,0,0])
			difference(){
				scale([1.6,1,1]) 
					circle(r=3, $fn=36);
				translate([-2,0,0]) scale([1.6,1,1])
					circle(r=3, center=true);
			}
	}
}

module lensebody(rad=lenseD/2, d=depth){
	difference(){
		union(){
			cylinder(r=rad, h=d-10, $fn=128, center=true);
			translate([0,0,-(d/2)])
				cylinder(r1=rad-rim, r2=rad, h=d-10, $fn=128, center=true);
			translate([0,0,-3])	
				torus(r=rad-1, circ=2);
			translate([0,0,4]) rotate([0,6,0])
				flange();
			for (i=[1:20:360]){
				translate([rad*cos(i), rad*sin(i), 0]) rotate([0,0,i])
					minkowski(){
						cube([1.5,0.5,10], center=true);
						rotate([0,90,0])
							cylinder(r=.5, h=.1, center=true, $fn=16);
					}
			}
		}
		translate([0,0,-d+7])
			cylinder(r=rad-1, h=d/2, $fn=128, center=true);
		translate([0,0,-depth/3])
			cylinder(r=rad-rim, h=d/4, $fn=128, center=true);
		translate([0,0,d/2])
			cylinder(r=rad-1, h=d/2+0.1, $fn=128, center=true);
		translate([0,0,0])
			cylinder(r=rad-3, h=d/2, $fn=128, center=true);
		translate([1.7*rad*2,d*2.1,d*2.8])	
			head();
	}
}


