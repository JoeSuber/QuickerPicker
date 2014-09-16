// this  

echo("turner.scad - small gears for runners and drive of big gear, with nut-d_shaft insert");
echo(".... uses stl import of 'whiskers_small.stl'");

insideB = 7.67/2;       // nominally 8mm, compensating for printer fattening
nutd = 6.5/2;

module gearbear(nutd=nutd) {
    // bearing insert
	difference(){
		cylinder(r=insideB, h=10.1, center=false, $fn=36);
        translate([0,0,0-.05])
		cylinder(r=1.66, h=10.1, center=false, $fn=16);
		translate([0,0,0+10])
			cylinder(r=nutd, h=5, center=true, $fn=6);
	}
    // gear and it's subtractions
	rotate([0,0,0])
		difference(){
		translate([0,-47.8,-5.6]) 
			import("whiskers_small.stl");
        // m3 thread bolt
		cylinder(r=1.66, h=18, center=true, $fn=16);
        translate([0,0,-5.7])
            cylinder(r1=nutd, r2=nutd-.05, h=1.6, center=false, $fn=6);
        translate([0,0,-5.7+1.5])
        cylinder(r1=nutd-.05, r2=1.66, h=2, center=false, $fn=16);
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

module armplate(midlen=16, rad=nutd, thick=3.6, stubs=false){
    difference(){
        linear_extrude(height=thick, convexity=10){
            difference(){
                hull(){
                    translate([-midlen,0,0])
                        circle(r=rad*2, $fn=20);
                    translate([midlen,0,0])
                        circle(r=rad*2, $fn=20);
                }
                for (i=[rad*2/3:rad*4:midlen*2-rad/6]){
                    translate([i - midlen, 0, 0]){
                        echo("armplate bolt-hole center at: ", i-midlen);               
                        circle(r=1.66, $fn=16);
                    }
                }
                
            }
        }
        for (i=[rad*2/3:rad*4:midlen*2-rad/6]){
            translate([i - midlen, 0, 1]){             
                    cylinder(r=rad, h=thick-1, $fn=6);
                    translate([0,0,thick-2])
                        cylinder(r=insideB+.1, h=2, center=false, $fn=24);
            echo("armplate nut-hole center at: ", i-midlen);
            if (stubs > 0){
                d_shaft(hexplugH=6, fraction_cut=100);
                }
            }
        }
    }
}

module armnhammer(stubs=true){

    armplate(midlen=9, stubs=2);

}

module gear_nut(){
	    gearbear(nutd=3);
        translate([0,0,8])
            difference(){
            cylinder(r=nutd-.25, h=3.5, $fn=6);
            translate([0,0,-.1])
                cylinder(r=1.66, h=10, $fn=12);
            }
}

module elbow(rad=nutd, thk=2){
   translate([0,0,thk/2]){
        cylinder(r=rad+.13, h=thk, center=true, $fn=24);
        d_shaft();
    }
}
   

//translate([20,0,0]) rotate([0,0,90]){
 //   armplate();
 //   translate([0,-14,0])
  //  armnhammer();
//}

translate([0,0,5.8]){
	    gearbear();

}

translate([-20,0,5.8])
	gearbear();

//translate([-10,2.5,0])
 //   elbow();

translate([-12,15,6])
    gear_nut();

translate([2,16,0])
	d_shaft();

