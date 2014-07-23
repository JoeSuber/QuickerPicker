use <small_step.scad>;
use <roundwave.scad>;
use <faninterface_ring.scad>;
use <608zz_run_free.scad>;
use <my_motors.scad>;
//import <608zz_run_toshaft.stl>;

echo("main picker assembly");



fanrad = 57/2;
fanheight = 25;
screwcenter = 48.5/2;
// actual box outside is 2mm bigger due to curve
outsidebox = 64.5;
outextendo = 25.5;
screwd = 1.6;
gearheight = 7.1;
pinrad = .865;
// bearing placements
bx=28;
by=30+outextendo;
bz=20;
// flaps for airflow valve
flapthick = 1.2;
truss = 9;		// knobby bit on flap
sprd = .6;
knobrad = 1.2;		// on side of chamber
lowknob = 9.5 + knobrad;  // distance from wire

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

module m3nut(d=6.4, 			// nut at end of bolt for cut-outs also has access tunnel
				h=2.7, 
				rodd=3.1, 
				rodlen=19, 
				hdled=3, 
				hdrad=6/2, 
				capture_channel=20, 
				channel_dir=90, 
				fat=.1){
	translate([0,0,-rodlen/2+h/2]){
		// nut on end of threads
		cylinder(r=d/2, h=h, center=true, $fn=6);
		// 'tunnel' to nut
		translate([(capture_channel/2)*cos(channel_dir-90), (capture_channel/2)*sin(channel_dir-90), 0]) rotate([0,0,channel_dir]) 
			cube([d, capture_channel, h], center=true);
	}
	// head of bolt is hexxed even if round
	translate([0,0,rodlen/2 - hdled/2])
		cylinder(r=hdrad+fat, h=hdled, center=true, $fn=6);
	// threaded part
	cylinder(r=rodd/2+fat, h=rodlen, center=true, $fn=12);
}


module z608z(mntrad=7.45/2, ht=7, innermnt=2.35, race=2.6, edge=2.35){
// 608zz bearing mount cutter
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
module LMB6mm(OD=12, 
				OD_groove=11.41, 
				ID=6, len=18.86, 
				stripe=1.25, 
				stripe_to_end=2.66, 
				rodlen=100){
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
cylinder(r=ID/2, h=rodlen, center=true, $fn=36);
}


module ring(rOD, rID, height)
{
difference(){
	cylinder(r=rOD/2, h=height, center=true, $fn=96);
	cylinder(r=rID/2, h=height, center=true, $fn=96);
	}
}


module fan(side=60.2, w=fanheight, curve=3, screwcenter=screwcenter){
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

module nut_insert(nutrad=6.15/2, nutheight=2.6, into=6, direction=-1) {
// slide in captured nuts
	hull(){
		cylinder(r=nutrad, h=nutheight, center=true, $fn=6);
		translate([into*direction,0, 0])
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
			cylinder(r=1.6, h=30, center=true, $fn=12);
		translate(z) translate([0,0,0])
			cylinder(r=2.65, h=22, center=true, $fn=12);
		translate(z) translate([0,0,-26]){
			cylinder(r=3.1, h=2.5, center=true, $fn=6);
		translate([3*(z[0]/z[1]),0,0])
			cylinder(r=3.6, h=2.5, center=true, $fn=6);
		translate([-3*(z[0]/z[1]),0,0])
			cylinder(r=3.6, h=2.5, center=true, $fn=6);
		}
	}
}
//small switch
module contact_switch(len=13.4, dp=5.4, ht=6.4, blade_ht=65, bladew=1.8, bladethk=1){
	cube([len, dp, ht], center=false);
	for (i=[.5, 5, 10.5]){
		translate([i+bladethk/2, dp/2, ht+blade_ht/2]) 
			cube([bladethk, bladew, blade_ht], center=true);
	}
}
			
// main section
module main(baselevel=-46.8){
	difference(){
		translate([0,outextendo/2,-18])
		union(){
		// the big box
			minkowski(){
			cube([outsidebox,outsidebox+outextendo,60], center=true);
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
			ring(fanrad*2+5, fanrad*2-.1, gearheight);
		// m3bearing bolt-head access
		
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
		translate([-bx, by*.8, bz])
			LMB6mm(rodlen=120);
		translate([bx, by*.8, bz])
			LMB6mm(rodlen=120);
		// captured nuts for attachments
		translate([-screwcenter, -(outsidebox-fanrad)+3, 0])
			rotate([90,0,0]) m3nut();
		translate([screwcenter, -(outsidebox-fanrad)+3, 0])
			rotate([90,0,0]) m3nut();
		translate([0, -(outsidebox-fanrad)+3, 0])
			rotate([90,0,0]) m3nut();
		//switches man, switches
		translate([-29, (outsidebox+outextendo)/2+8, -48.1])
			contact_switch();
		translate([8, (outsidebox+outextendo)/2-9, -48.1]) rotate([0,0,-7])
			contact_switch();
		translate([-8, -(outsidebox)/2-5.5, -48.1]) rotate([0,0,0])
			contact_switch();
		// ring mount bearings
		forbearance();
		// stepper for turning ring
		//translate([0,52,-11]) rotate([90,0,0])
		//	small_stepper();
		// tiny gearmotor
		translate([0,34.7,-1]) rotate([0,-90,90])
			gearmotor();
		// spool mount hole for thread-drive of ring
		translate([0,outsidebox/2+2.5, -16.0]) rotate([0,0,0])
			cylinder(r=4.68, h=7, center=true, $fn=128);
		// thread passageway
		translate([0,outsidebox/2+2.5, -16.3]) rotate([0,90,0])
			cylinder(r=.7, h=60, center=true, $fn=6);
	}

}

module main_bottom(){
	difference(){
		main();
		translate([0,0+outextendo/2,-.1])
			cube([100,100+outextendo,fanheight], center=true);
	}
}

module main_top(){
translate([(outsidebox+10), +29, 26/2])
	difference(){
		main();
		translate([0,0+outextendo/2,-42.4])
			cube([100,100+outextendo,60], center=true);
	}
}
module inner_ring(){
// inner ring for printing
translate([outsidebox+3, +outextendo, 0])
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
			cylinder(r1=fanrad-.6, r2=fanrad-.1, h=7.15, center=false, $fn=128);
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
		
		translate([0,0+outextendo/2,-50])
			cube([100,100+outextendo,58], center=true);
		translate([0,0+outextendo/2,-10])
			cube([100,100+outextendo,15.5], center=true);
		translate([0,0+outextendo/2,-10])
			cube([100,100+outextendo,15.5], center=true);
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
	translate([0,-(outsidebox+5)+outextendo/2,-16])
		cube([70,70+outextendo+10,12], center=true);
	}
}

module ring_holder(){
translate([0,0+outextendo+1,22])
	difference(){
		main_bottom();
		translate([0,0+outextendo/2,-50])
			cube([100,100+outextendo,56], center=true);
	}
}

module spool(){
// round thread puller for motor attach
//first some spacers for flap-wires
translate([15,+outextendo,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
translate([-15,+outextendo,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
translate([-10,+outextendo,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
translate([10,+outextendo,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
translate([0,-10+outextendo,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
translate([0,10+outextendo,0])
	difference(){
		cylinder(r=pinrad+1, h=12, center=false, $fn=18);
		cylinder(r=pinrad+.1, h=12.1, center=false, $fn=18);
	}
	// remember to adjust socket in main if changing radius here
translate([0,+outextendo,7/2]){
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
rotate([0,180,0]) translate([0,0,-fanheight])
	main_top();

//print_gasket();

//inner_ring();

spool();
rotate([0,0,-90]) translate([50,20,0])
	can_holder();

ring_holder();

// m3nut(capture_channel=50, channel_dir=13);
pusher_down();

//contact_switch();

// sample bearing
//z608z();
		
	

