lenseD = 60;
depth = 20;
rim = 4;
center=18;

noseparts();

eyeparts();

module noseparts(){
    translate([25,0,0])
        hingepin();
    translate([-14,0,0])
        clip();
}

module eyeparts(){
translate([-30,0,0]) rotate([0,0,-90])
    lensebody(rotar=360*.3);
mirror([1,0,0])
    translate([-45,0,0]) rotate([0,0,-90])
        lensebody(rotar=360*.3, flip=1);
}

module torus(r=lenseD/2, circ=rim){
	rotate_extrude($fn=96){
		translate([r,0,0])
			circle(r=circ, $fn=36);
		}
}

module head(){
	scale([1.3,1.6,1])
		sphere(r=lenseD, $fn=64);
}

module flange(rad=lenseD/2-3, flare=0.4){
	rotate_extrude($fn=64){
		translate([rad,0,0]) rotate([0,0,0])
			difference(){
				scale([1.6,.5,1]) 
					circle(r=3, $fn=36);
				translate([-2,0,0]) scale([1.6,1,1])
					circle(r=3, center=true);
			}
	}
}

//***********************************************
// *****  nose parts    **************

nose=18;
base=1.2;
shaft=3;
pinh=1;
pinthk=1;
knobrad=2.2;

module hingepin(fat=0){
// the round part everything attaches to 
    pinD=nose/2;
    pinring= pinD - 2;
    cylinder(r=pinD/2+1+fat, h=base, $fn=36);
    translate([0,0,base])
        cylinder(r=pinD/2+fat, h=shaft, $fn=30);
    translate([0,0,base+shaft])
        cylinder(r=pinring/2+fat, h=pinh+fat, $fn=48);
    translate([0,0,base+shaft+pinh])
        cylinder(r1=pinring/2+fat, r2=pinring/2+pinthk+fat, h=pinthk, $fn=48);
}

module clip(){
    // the c-clip that holds it all on the hingepin
    bigrad=(nose-4)/2;
    difference(){
        cylinder(r=bigrad, h=pinh*2, $fn=36);
        translate([0,0,-(base+shaft)+0.05])
            hingepin(fat=.13);
        translate([0,bigrad/2, pinthk])
            cube([nose/2-pinthk*2, bigrad, pinthk*3+.1], center=true);
    }
    //knobbies
    for (i=[44,136]){
    translate([bigrad*cos(i), bigrad*sin(i), 0])
        cylinder(r=knobrad, h=pinthk*4, $fn=24);
    }
}

module noseconnect(cut=1){
    // the plate that hooks to hingepin from the goggle-eye
    vital=.75*nose;
    curve= nose/4;
    intersection(){
        difference(){
            minkowski(){
                cube([vital,vital,shaft - 0.1], center=false);
                cylinder(r=curve, h=0.05, center=false, $fn=32);
            }
            translate([vital-curve/2, vital-curve/2, -0.05 - base]){
                hingepin(fat=0.21);
                translate([0,0,base+shaft/2])
                    cylinder(r=vital*.75, h=shaft/2+.1, $fn=36);
            }
            
        }
        scale([2.2,1,1]) rotate([0,0,0])
            cylinder(r=vital, h=shaft, $fn=64, center=false);
    }
} 

module lensebody(rad=lenseD/2, d=depth, rotar=0){
    translate([0,0,8]){
	    difference(){
            rotate([0,0,rotar])
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
                if (flip==1){
                translate([24.5,5,-2]) rotate([180,0,33])
                    noseconnect();
                }
                else {
                translate([24.5,5,-5]) rotate([0,0,-57])
                    noseconnect();
                }
            }
		    translate([0,0,-d+7])
			    cylinder(r=rad-1, h=d/2, $fn=128, center=true);
		    translate([0,0,-d/3])
			    cylinder(r=rad-rim, h=d/4, $fn=128, center=true);
		    translate([0,0,d/2])
			    cylinder(r=rad-1, h=d/2+0.1, $fn=128, center=true);
		    translate([0,0,0])
                assign(lenserad = rad - 2.2){
			    cylinder(r=lenserad, h=d/2+2, $fn=128, center=true);
            echo("lense radius (as rendered) is: ", lenserad);
            echo("so the diameter is: ", 2*lenserad);}
		    translate([0,d*1.2,d*2.9])	
			    head();
        }
	}
}



