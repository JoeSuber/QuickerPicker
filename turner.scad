
echo("turner.scad - small gears for runners and drive of big gear, with nut-d_shaft insert");
echo(".... uses stl import of 'whiskers_small.stl'");

module gearbear() {
	difference(){
		cylinder(r=7.97/2, h=7.1, center=false, $fn=24);
		cylinder(r=1.65, h=7.1, center=false, $fn=12);
		translate([0,0,0+7.1])
			cylinder(r=6.3/2, h=5, center=true, $fn=6);
	}
	rotate([180,0,0])
		difference(){
		translate([0,-47.8,0]) 
			import("whiskers_small.stl");
	
		cylinder(r=1.65, h=18, center=true, $fn=12);
		translate([0,0,6]) 
			cylinder(r=5.6/2, h=2.2, center=true, $fn=16);
		translate([0,0,4.6]) 
			cylinder(r1=1.5, r2=5.6/2, h=1, center=true, $fn=16);
		}
}

// the little nubby insert for motor shaftage
module d_shaft(hexplugD=6.0, hexplugH=4, shaftrad=1.69, fraction_cut=5){
	difference(){
	cylinder(r=hexplugD/2, h=hexplugH, center=false, $fn=6);
		difference(){
			translate([0, 0, (hexplugH+.1)/2])
				cylinder(r=shaftrad, h=hexplugH+.1, center=true, $fn=16);
			translate([shaftrad - shaftrad / fraction_cut, 0, (hexplugH+.15)/2])
				cube([2*(shaftrad) / fraction_cut, hexplugD*.75, hexplugH+.15], center=true);
		}
	}
}

module armplate(midlen=16){
    difference(){
    linear_extrude(height=3, convexity=10){
        difference(){
            hull(){
                translate([-midlen,0,0])
                    circle(r=6);
                translate([midlen,0,0])
                    circle(r=6, $fn=16);
            }
            for (i=[2:midlen*2/3:midlen*2-1]){
                translate([i - midlen, 0, 0]){               
                    circle(r=1.66, $fn=16);
                }
            }
            
        }
    }
    for (i=[2:midlen*2/3:midlen*2-1]){
        translate([i - midlen, 0, 1])               
                cylinder(r=6.3/2, h=2.1, $fn=6);
    }
    }
}

translate([20,0,0]) rotate([0,0,90])
    armplate();

translate([0,0,6])
	gearbear();

translate([-20,0,6])
	gearbear();

translate([-12,15,6])
	gearbear();

translate([2,16,0])
	d_shaft();
translate([6,20,0])
	d_shaft();
translate([10,24,0])
	d_shaft();
translate([14,29,0])
	d_shaft();
