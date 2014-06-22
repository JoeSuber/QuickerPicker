echo(version=version());
echo("main picker assembly");

fanrad = 57/2;
screwcenter = 48.5/2;
// actual box outside is 2mm bigger due to curve
outsidebox = 64.5;
screwd = 1.5;
gearheight = 7.1;
pinrad = .865;
// bearing placements
bx=34;
by=26;
bz=-43;
// flaps for airflow valve
flapthick = 1.2;
truss = 9;		// knobby bit on flap
sprd = .6;
knobrad = 1.2;		// on side of chamber
lowknob = 9.5 + knobrad;  // distance from wire


module flapattach(ra=3, t=flapthick, trusslen=truss){
// the little bit going from rod to flap
	difference(){
	// disk-hull-disk
	hull(){
		union(){
			cylinder(r1=ra-1, r2=ra, h=t, center=true, $fn=36);
			translate([0,0,t])
				cylinder(r1=ra, r2=ra-1, h=t, center=true, $fn=36);
		}
		translate([trusslen,0,0])
		 union(){
			 cylinder(r1=ra-1, r2=ra, h=t, center=true, $fn=36);
			 translate([0,0,t])
				 cylinder(r1=ra, r2=ra-1, h=t, center=true, $fn=36);
		 }
		} // end of disk-hull-disk
	// hole for metal pin or wire (to swivel on)
	cylinder(r=pinrad+.1, h=t*6, center=true, $fn=12);
	}
}

module flap(rd=fanrad-1, t=flapthick, trs=truss){
// make quarter-section of stopper
	difference(){
		union(){
		difference(){
			cylinder(r=rd, h=t, center=false, $fn=128);
			translate([rd/2, -rd/2, t/2])
				cube([rd,rd,t*2], center=true);
			translate([-rd/2, -rd/2, t/2])
				cube([rd,rd,t*2], center=true);
			translate([-rd/2, rd/2, t/2])
				cube([rd,rd,t*2], center=true);
		}
		translate([0, trs, -6]) rotate([90,-60,0])
			flapattach();
		translate([0, rd-trs, -6]) rotate([90,-60,0])
			flapattach();
		}
	translate([rd/2, rd/2, t*3])
		cube([rd*2,rd,t*4], center=true);
	}
}

module flaps(){
	difference(){
		flap();
		rotate([0,0,-90])
			flap();
	}
}

module nodule(rat=45){
// cam for valve leaves
	rotate([0,0,rat]) scale([2,1,.5])
		sphere(r=2.4, $fn=64);
}

// nut with bolt in it for cut-outs
module m3nut(d=6.4, h=2.4, rodlen=20){
	translate([0,0,-h])
		cylinder(r=d/2, h=h, center=true, $fn=6);
	cylinder(r=3/2, h=rodlen, center=true, $fn=12);
}

// 608zz bearing mount cutter
module z608z(mntrad=7.45/2, ht=7, innermnt=2.35, race=2.6, edge=2.35){
	translate([0,0,0])
		union(){
			ring((innermnt+mntrad)*2, mntrad*2,  height=ht-.1);
			ring((innermnt+mntrad+race)*2, (innermnt+mntrad)*2-.1,  height=ht-.25);
			ring((innermnt+mntrad+race+edge)*2, (innermnt+mntrad+race)*2-.1,  height=ht+.1);
			// thread-groove cutter:
			ring((innermnt+mntrad+race+edge)*2+.35, (innermnt+mntrad+race+edge)*2-.1, height=.7);
		}
}

// linear bearing for 6mm w/ rod sticking through it
module LMB6mm(OD=12, OD_groove=11.41, ID=6, len=18.86, stripe=1.25, stripe_to_end=2.66, rodlen=38){
difference(){
	union(){
		// body of bearing, stacked up
		translate([0,0,-.05])
			cylinder(r=OD/2, h=stripe_to_end+.1, $fn=64);
		translate([0,0,stripe_to_end])
			cylinder(r=OD_groove/2, h=stripe+.05, $fn=48);
		translate([0,0,stripe_to_end+stripe])
			cylinder(r=OD/2, h=len-stripe*2-stripe_to_end*2+.05, $fn=64);
		translate([0,0,len-stripe-stripe_to_end])
			cylinder(r=OD_groove/2, h=stripe+.05, $fn=48);
		translate([0,0,len-stripe_to_end])
			cylinder(r=OD/2, h=stripe_to_end+.05, $fn=64);
		// transition for printing upright
		translate([0,0,len])
			cylinder(r=OD/2-1.1, h=stripe/2, $fn=64);
		}
	// hole for rod
	cylinder(r=ID/2, h=stripe_to_end, $fn=64);
}
// rod stand-in for use in cuts
cylinder(r=ID/2+.1, h=rodlen, center=true, $fn=36);
}


module ring(rOD, rID, height)
{
difference(){
	cylinder(r=rOD/2, h=height, center=true, $fn=64);
	cylinder(r=rID/2, h=height, center=true, $fn=64);
	}
}


module fan(side=57.2, w=25, curve=3, screwcenter=screwcenter){
// box fan 60mm sqr nominal x 25mm high + 50mm OD air hole
// fan is a tad bigger here to allow for shrink
	realside = curve*2 + side;
	oldz = 1;
	translate([29,18,0])
		cube(size=[7, 2, 22], center=true);
	translate([38,18,5])
		cube(size=[35, 2, 5], center=true);
	translate([0,0,-32.4])
		cylinder(r=fanrad, h=40, center=true, $fn=64);
	for (z = [[screwcenter-9.4,screwcenter+7.7],
				[screwcenter-9.4,-screwcenter-7.7],
				[-screwcenter+9.4,screwcenter+7.7],
				[-screwcenter+9.4,-screwcenter-7.7]]){
		translate(z) 
			cylinder(r=1.6, h=130, center=true, $fn=12);
	}
	difference(){
		minkowski(){
			cube(size=[side-curve, side-curve, w], center=true);
			cylinder(r=curve, h=.1, $fn=20);
		}
	//translate([29,20,0])
	//	cube(size=[4, 2, 2], center=true);
	echo("realside = ", realside);
	}
}

module nut_insert(nutrad=6.15/2, nutheight=2.5, into=6, direction=-1) {
// slide in captured nuts
	hull(){
		cylinder(r=nutrad, h=nutheight, center=true, $fn=6);
		translate([0, into*direction, 0])
			cylinder(r=nutrad, h=nutheight, center=true, $fn=6);
		}
}		

module forbearance(screw=screwcenter+4.75){
// bearings cut into four corners
	for (z = [[screw,screw],
				[screw,-screw],
				[-screw,screw],
				[-screw,-screw]]){
		translate(z) translate([0,0,-15.9])
			z608z();
		// m3 bolts through 608zz centers
		translate(z) translate([0,0,-15.9])
			cylinder(r=1.5, h=30, center=true, $fn=12);
		translate(z) translate([0,0,-29]){
			nut_insert();
			nut_insert(nutrad=6.15/2, nutheight=2.5, into=6, direction=1);
		}
	}
}

module pusher_down(fr=fanrad, rad=5, section=45, hgt=7){
// push down flaps with this thread groove
	rotate([45,0,0])
	rotate([0,-90,0])
	mirror()
	scale([1.4,1,1])
	difference(){
		ring(rad*2, (rad-1.5)*2, hgt);
		translate([0, rad*cos(180-section),-.1])		
			cube([rad*2.1, rad*2, hgt+.2], center=true);
		translate([0, 0, hgt/2])
		rotate([0,20,0])	
			cube([rad*4, rad*2.1, hgt], center=true);
	}
}

module springy(rd=34, cb=6, thk=.4, w=gearheight){
// torsion springs for pushing flaps down
	difference(){
		scale([1,1,1]){
			translate([0,0,.3])
			minkowski(){
			cube([rd-2, cb-2, cb-2], center=true);
			sphere(r=1.2, $fn=32);}
			translate([rd/2-cb/2,rd/4+cb/2,0])
				difference(){
				cube([cb,rd/2,cb], center=true);
				rotate([atan(-cb/(rd/2)),0,0]) translate([0,cb/2,cb/2])
					cube([cb,rd/2+4,cb], center=true);
				}
			translate([-rd/2+cb/2,-rd/4-cb/2,0])
				difference(){
				cube([cb,rd/2,cb], center=true);
				rotate([atan(cb/(rd/2)),0,0]) translate([0,-cb/2,cb/2])
					cube([cb,rd/2+4,cb], center=true);
				}
			//mirror()
			//	translate([16-2.5,8,0])
			//	cube([5,16,5], center=true);
		}
	scale([rd/cb, 1, 1])
		sphere(r=cb/2+.25, center=true, $fn=128);
	}
}
			
// main section
module main(){
	difference(){
		translate([0,0,-18])
		union(){
		// the big box
			minkowski(){
			cube([outsidebox,outsidebox,60], center=true);
			cylinder(r=2, h=.1, $fn=20);
		}		
		translate([-bx, by*.6, bz/2+4.5]) scale([.4,1.8,1])
			cylinder(r=8.8, h=26, center=true, $fn=64);
		translate([bx, by*.6, bz/2+4.5]) scale([.4,1.8,1])
			cylinder(r=8.8, h=26, center=true, $fn=64);
		//translate([0, -by*1.48, bz/2+3]) scale([1.8,.4,1])
		//	cylinder(r=9, h=26, center=true, $fn=64);
		//translate([0,33.15/2,-12]) rotate([0,90,0])
		//	cylinder(r=screwd, h=71, center=true, $fn=20);
		//translate([0,0,-12]) rotate([0,90,0])
		//	cylinder(r=screwd, h=71, center=true, $fn=20);
		}
		fan();
		// groove for gear
		translate([0,0,-16])
			ring(fanrad*2+5, fanrad*2, gearheight);
		// 4 pin holes for flap control
		translate([0,0,-17-lowknob]) rotate([0,90,45])
			cylinder(r=pinrad, h=fanrad*2+10, center=true, $fn=5);
		translate([0,0,-17-lowknob]) rotate([0,90,-45])
			cylinder(r=pinrad, h=fanrad*2+10, center=true, $fn=5);
		translate([0,0,-21.5]) rotate([0,90,51])
			cylinder(r=pinrad, h=fanrad*2+10, center=true, $fn=5);
		translate([0,0,-21.5]) rotate([0,90,-39])
			cylinder(r=pinrad, h=fanrad*2+10, center=true, $fn=5);
		// can is gripped here
		translate([0,0,-38])
			ring(64.75, 63, 25);
		// taper to can
		translate([0,0,-45])
			cylinder(r1=62.2/2, r2=fanrad, 12, center=true, $fn=64);
		// linear bearing holders
		translate([-bx, by*.6, bz])
			LMB6mm(rodlen=120);
		translate([bx, by*.6, bz])
			LMB6mm(rodlen=120);
		// captured nuts for attachments
		translate([-screwcenter, outsidebox-(outsidebox-fanrad), 0])
			rotate([90,0,0]) m3nut();
		translate([screwcenter, outsidebox-(outsidebox-fanrad), 0])
			rotate([90,0,0]) m3nut();
		translate([0, outsidebox-(outsidebox-fanrad), 0])
			rotate([90,0,0]) m3nut();
		// ring mount bearings
		forbearance();
		// spool mount hole for thread-drive of ring
		translate([0,outsidebox/2+2.5, -20]) rotate([90,0,0])
			cylinder(r=4.65, h=7, center=true, $fn=128);
	}

// flaps for valve
translate([sprd, -sprd, bz-3.8]) rotate([180,0,0])
	flaps();
translate([sprd, sprd, bz-3.8]) rotate([180,0,90])
	flaps();
translate([-sprd, sprd, bz-3.8]) rotate([180,0,180])
	flaps();
translate([-sprd, -sprd, bz-3.8]) rotate([180,0,-90])
	flaps();

// knobs for valve leaves
for (i = [45,-45,135,-135]){
	translate([.5*fanrad/sin(i),.5*fanrad/cos(180-i),-17.8-lowknob])
		nodule(rat=i);
	//translate([fanrad*sin(i+40),fanrad*cos(180-(i+40)),-13.7-lowknob])
	//	nodule(rat=(i+40));
// push_down the flaps as they rotate
	translate([fanrad*sin(i+40),fanrad*cos(180-(i+40)),-13.7-lowknob])
		sphere(r=3.2);
	}
}

module main_bottom(){
	difference(){
		main();
		translate([0,0,-.1])
			cube([100,100,27], center=true);
	}
}

module main_top(){
translate([-(outsidebox+5), 0, 25/2])
	difference(){
		main();
		translate([0,0,-42.4])
			cube([100,100,60], center=true);
	}
}
module inner_ring(){
// inner ring for printing
translate([outsidebox+1, 0, 0])
	difference(){
		union(){
			// bottom bevel grabber
			cylinder(r1=fanrad+2.1, r2=fanrad+1.8, h=.5, center=false, $fn=128);
			// mid-section w/ thread	
			translate([0,0,0.5])
				cylinder(r1=fanrad+1.8, r2=fanrad+1.4, h=3, center=false, $fn=128);
			translate([0,0,3.5])
				cylinder(r1=fanrad+1.4, r2=fanrad+1.8, h=3, center=false, $fn=128);
			// top bevel grabber
			translate([0,0,6.5])
				cylinder(r1=fanrad+1.8, r2=fanrad+2.1, h=.5, center=false, $fn=128);
		}
		// cut out from center
		translate([0,0,-0.1])
			cylinder(r1=fanrad-.5, r2=fanrad, h=7.15, center=false, $fn=128);
		// wire holder holes
		translate([0,0,.9]) rotate([0,90,0])
			cylinder(r=pinrad, h=(fanrad+1)*2, center=true, $fn=6);
		translate([0,0,.9]) rotate([90,0,0])
			cylinder(r=pinrad, h=(fanrad+1)*2, center=true, $fn=6);
	}
}

module print_gasket(screw=screwcenter+4.75){
translate([(outsidebox+8), -(outsidebox+5), 21])
	difference(){
		main_bottom();
		translate([0,0,-50])
			cube([100,100,58], center=true);
		translate([0,0,-10])
			cube([100,100,15.5], center=true);
		translate([0,0,-10])
			cube([100,100,15.5], center=true);
		for (z = [[screw,screw],
				[screw,-screw],
				[-screw,screw],
				[-screw,-screw]]){
			// m3 hex-bolt-heads
			translate(z) translate([0,0,-21.75+1.5])
				cylinder(r=2.75, h=3, center=true, $fn=12);
		}
	}
}
module can_holder(){
translate([0, 0, 23+(50/2)])
	difference(){
	translate([0,-(outsidebox+5),0])
		main_bottom();
	translate([0,-(outsidebox+5),-16])
		cube([70,70,12], center=true);
	}
}

module ring_holder(){
translate([0,0,22])
	difference(){
		main_bottom();
		translate([0,0,-50])
			cube([100,100,56], center=true);
	}
}

module some_springs(xpos=75, ypos=4, wide=gearheight-.2){
// for printing
	translate([xpos,ypos-(wide+1),(wide)/2])
		springy();
	//translate([xpos,ypos+(wide+1),(wide)/2])
	//	springy();
}


module spool(){
// round thread puller for motor attach
//first some spacers for flap-wires
translate([15,0,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
translate([-15,0,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
translate([-10,0,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
translate([10,0,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
translate([0,-10,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
translate([0,10,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
	// remember to adjust socket in main if changing radius here
translate([0,0,7/2]){
	difference(){
	translate([0,0,-7/2]) union(){
	cylinder(r1=4.5,r2=4.2, h=1.5, center=false, $fn=128);
	translate([0,0,1.5])
		cylinder(r1=4.2,r2=4.65, h=1.5, center=false, $fn=128);
	translate([0,0,3])
		cylinder(r1=4.65,r2=4.3, h=2, center=false, $fn=128);
	translate([0,0,5])
		cylinder(r1=4.3,r2=4.65, h=2, center=false, $fn=128);
			}
		// nub insert for gear-motor
		translate([0,0,(7-5.25)/2]){
			difference(){
				cylinder(r=3.63, h=5.3, center=true, $fn=64);
				translate([3.57,0,0])
					cube([(3.57-4.9/2)*2, 5.4, 6], center=true);
				translate([-3.57,0,0])
					cube([(3.57-4.9/2)*2, 5.4, 6], center=true);
			}
		}
		cylinder(r=1, h=8, center=true, $fn=12);
		translate([0,0,1.35]) rotate([0,90,0])
			cylinder(r=.6, h=10, center=true, $fn=12);
		translate([0,0,0])
			cube([5.7,.4,3.7], center=true);
	}
}}


// samples for export

some_springs();

main_top();

print_gasket();

inner_ring();

spool();

can_holder();

ring_holder();

//pusher_down();

// sample bearing
//z608z();
		
	

