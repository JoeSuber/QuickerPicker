// chandra nalaar's goggles

lenseD = 60;
depth = 20;
rim = 4;
center=18;
use <flatsine.scad>;
translate([0,-48,0])
noseparts();

//nosebend();
eyeparts();
//sideguard();
//translate([-28,0,0])
//    noseconnect(cut=360*$t);

module noseparts(){
    translate([25,0,0])
        hingepin();
    translate([-23,0,0])
        clip();
    translate([-21,0,-4])
        rotate([90,45,0]){
            difference(){
            noseconnect(cut=360*$t);
            translate([-1.5,1.5,0])
                rotate([45,90,0])
                    cube([100,100,4], center=true);
            }
            rotate([180,180,0])
                translate([-1.5,-16.5,-12])
                difference(){
                    noseconnect_top();
                    translate([-6,6,0])
                    rotate([45,90,0])
                        #cube([100,100,4], center=true);
                }
            }
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
shaft=1.8;
pinh=1;
pinthk=1;
knobrad=2.2;

module hingepin(fat=0){
// the round part everything attaches to 
    pinD=nose/2;
    pinring= pinD - 2;
    cylinder(r1=pinD/2+1+fat, r2=pinD/2+fat, h=base, $fn=36);
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
        difference(){
            cylinder(r=knobrad, h=pinthk*4, $fn=24);
            cylinder(r=0.8, h=pinthk*4+.1, $fn=3);
        }
    }
}

module nosebend(rad=2.5, spread=10, rod=3.3/2, rodlen=13, extend=6){
    for (i=[1,-1]){
        translate([0,spread/2*i,0])
            difference(){
                rotate([90*i,0,0])
                    hull(){
                        translate([extend/2,0.05,0])
                            cylinder(r=rad, h=1+rodlen-spread, $fn=24, center=true);
                        translate([-extend/2,0.05,0])
                            cylinder(r=rad, h=1+rodlen-spread, $fn=24, center=true);
                    }
                 rotate([90*i,0,0])
                    hull(){
                        translate([extend/2-(rad-rod), 0, (rodlen-spread)/2])
                            cylinder(r=rod, h=1.1, $fn=24, center=true);
                        translate([-extend/2+(rad-rod), 0, (rodlen-spread)/2])
                            cylinder(r=rod, h=1.1, $fn=24, center=true);
                    }
                rotate([90*i, 0, 0])
                    translate([extend/2-(rad-rod), 0, (rodlen-spread)/2])
                            cylinder(r=rod+.1, h=rodlen-spread, $fn=24, center=true);
            }
    }
    translate([extend/2-(rad-rod), 0, 0]) rotate([90,0,0])
        %cylinder(r=rod, h=rodlen, $fn=16, center=true);
}


module noseconplate(cut=1){
    // the plate that hooks to hingepin from the goggle-eye
    vital=.75*nose;
    curve= nose/4;
    intersection(){
        difference(){
            minkowski(){
                cube([vital,vital,(shaft+base) - 0.1], center=false);
                cylinder(r=curve, h=0.05, center=false, $fn=32);
            }

        }
        // trim off extra plate-area
        rotate([0,0,0.12*360]) scale([2.2,.55,1]) translate([-3,0,0])
            cylinder(r=vital, h=shaft, $fn=64, center=false);
    }
}

module noseconnect(){
    translate([0,15,0]){
        rotate([-45,90,-90]) translate([1.5,17,2])
            difference(){
            cylinder(r=5.5/2, h=9.1, $fn=36, center=true);
                hull(){
                    cylinder(r=1.7, h=9.6, $fn=36, center=true);
                    translate([-4,-17,0])
                        cylinder(r=1.54, h=9.6, $fn=36, center=true);
                }
            }
        difference(){
            noseconplate();
            translate([3,3,0]){
                hingepin(fat=0.3);
                translate([0,0,1])
                    cylinder(r=10, h=1, $fn=36);
        }
        }
    }
}

module noseconnect_top(){
    translate([15,15,0]){
        rotate([-45,90,-90]) translate([-3.5,-17,-2])
            difference(){
            cylinder(r=5.5/2, h=9.1, $fn=36, center=true);
                hull(){
                    cylinder(r=1.7, h=9.6, $fn=36, center=true);
                    translate([-2,17,0])
                        cylinder(r=1.54, h=9.6, $fn=36, center=true);
                }
            }
        difference(){
            rotate([0,0,180])
            noseconplate();
            translate([-3,-3,0]){
                rotate([0,180,0])
                translate([0,0,-3])
                    hingepin(fat=0.3);
                translate([0,0,1])
                    cylinder(r=10, h=1, $fn=36);
            }
        }
    }
}


module sideguard(rad=lenseD/2, ht=40, thk=2){
    scale([1,1,1]){
        difference(){
            translate([0,-40/2, 0]) 
                linear_extrude(convexity=10, height=25){
                    difference(){
                        circle(r=27, $fn=64);
                        circle(r=24.5, $fn=96);
                    }
                }
            rotate([0,90,0]) scale([5,4,3]) translate([-4,-18,-13])
            linear_extrude(convexity=10, height=50){
                sinewave(portion=180);
            }
        }
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

                translate([30,12,-4]) rotate([0,-35,20])
                    nosebend();
                translate([-30,7,6]) rotate([0,-48,165])
                    nosebend();
                translate([-24,0,5]) rotate([0,0,90])
                    sideguard();
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
        translate([3,-24,5]) rotate([0,0,187])
            sideguard();
	}
}



