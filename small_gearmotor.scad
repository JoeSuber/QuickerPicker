module gearmotor(l=25, w=12, h=10, r=3
){
	cube([l,w,h], center=true);
	translate([-5,0,0]) rotate([0,90,0])
		cylinder(r=r, h=l+10+1, center=true, $fn=16);
	translate([l/2,0,0]) rotate([0,90,0])
		cylinder(r=1, h=w, center=true, $fn=16);
	translate([l/2,0,0]) rotate([90,0,0])
		cylinder(r=1.5, h=65, center=true, $fn=16);

}

gearmotor();