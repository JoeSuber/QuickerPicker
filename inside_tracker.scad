
$fn=32;
sleeve_height=57;
sleeve_inside=32.27;
sleeve_wall=4.8;
sleeve_outside=sleeve_inside+sleeve_wall;
s=8;
q=10;
lvl1 = 24;
lvl2 = 52;
include <MCAD/regular_shapes.scad>;


digmap = [[1, lvl1, 0], [2, lvl1, -s], [3, lvl1-s , -s], [4, lvl1-s-s ,s], [5, lvl1-s, s], [6, lvl1, 0] ];

airmap = [[1, lvl2-q, 0], [2, lvl2-q, 0], [3, lvl2-q, 0], [4, lvl2-q, q], [5, lvl2, 0], [6, lvl2, -q]];


// burrower is to be used 6 times, one on each section to make a circle-groove
module burrower (degrees=360/6, 
					section_num=0,		// passed in for echo debug
					upndown=0, 			// ie -20, 0, 20 - relative rise / fall
					currentline=20, 		// starting z-level
					radius=sleeve_inside-1, 				// of can
					quant=60, 				// how many cuts/section
					bulge=3.5,				// radius of cutter-sphere
					huck=36,				// fine-ness of cutter '$fn'
					){
		echo("currentline = ", currentline, " section = ", section_num);
		for (i=[0 : degrees/quant : degrees - (degrees/quant)*.5]){
			rotate([0, 0, i])
			translate([radius, 0, currentline - upndown*cos(i/degrees*180)*.5 + upndown/2])
                //rotate([sin(i+degrees/quant)/sin(i)*i, cos(i+degrees/quant)/cos(i)*i, 0])
                //rotate([90,sin(i+degrees/quant)/sin(i)*i, cos(i+degrees/quant)/cos(i)*i])
                rotate([90,90, 0])
                cylinder(r=bulge,
                         h=2*(radius+bulge+.1)*3.141592654/(360/degrees)/quant, center=true, $fn=huck);
                //rotate([i/6,i/6,60 ])
                //linear_extrude(height=bulge, center=true, scale=[cos(i+degrees/quant)/cos(i), sin(i+degrees/quant)/sin(i),1])
				    //square([bulge*2,bulge*2], center=true);
		}
}

module digdug (sections=6, instructions=digmap){
	for (shovel=instructions){
	rotate([0,0,(shovel[0]-1)*(360/sections)]){
		if (shovel[0] < 3){
			burrower(currentline=shovel[1], 
						section_num=shovel[0], upndown=shovel[2]);
			echo("section ",shovel[0]," is done");
		}
		else {
			burrower(currentline=shovel[1], 
						section_num=shovel[0], upndown=shovel[2]);
		}
	}
	}
}

//digdug();
//digdug(instructions=airmap);

module sleeve(outside_r=sleeve_inside+sleeve_wall, 
				inside_r=sleeve_inside,
				ht=sleeve_height){
	echo("outside_r=",outside_r, 
				"inside_r=",inside_r,
				"ht=",ht);
	difference(){
		cylinder(r=outside_r, h=ht, center=true, $fn=256);
		cylinder(r=inside_r, h=ht+.1, center=true, $fn=256);
	}
}

// make a sleeve with all the extra parts so it can be diff'd with the tubes lastly
module turnypart(mid=sleeve_height/2, saturn=10, ringthick=1){
    echo("turnypart (gear-crown) constructed with mid = ", mid);
	translate([0,0,mid])
        union(){
            // main tube
            rotate_extrude(convexity=10, center=true, $fn=128){
                translate([sleeve_inside, 0, mid])
                    polygon(points=[[0,0],
                            [0, mid],
                            [.5, mid],
                            [1 + 4.6/2, mid - 4.6/2],
                            [4.6+1, mid],
                            [6.1, mid],
                            [7, mid - 6],
                            [7, mid - 7],
                            [4, mid - 10],
                            //[2, mid - 10],
                            ]);
            }
        }
}
//turnypart();

// no longer using burrower, digdug etc.
module turn_n_burn(){
// for printing/modeling the whole thing
    difference(){
        turnypart();
	    digdug();
	    digdug(instructions=airmap);
    }
translate([0,0,sleeve_height/2+11]) rotate([0,180,0])
    import("whiskers_big.stl");
}
//rotate([180,0,0])
//turn_n_burn();

module turner_cutter (mid=sleeve_height/2, saturn=10, ringthick=1){
	translate([0,0,mid])
        union(){
            // main tube fattened to cut clearance from picker body
            rotate_extrude(convexity=10, center=true, $fn=128){
                translate([sleeve_inside+.5, 0, mid])
                    polygon(points=[[0,0],
                            [0, mid],
                            [.5, mid],
                            [1 + 4.6/2, mid + 4.6/2],
                            [4.6+1, mid],
                            [6.1, mid],
                            [7, mid - 6],
                            [7, mid - 7],
                            [4, mid - 10],
                            //[2, mid - 10],
                            ]);
            }
            rotate_extrude(convexity=10, center=true, $fn=128){
                translate([sleeve_inside-.5, 0, mid])
                    polygon(points=[[0,0],
                            [0, mid],
                            [.5, mid],
                            [1 + 4.6/2, mid + 4.6/2],
                            [4.6+1, mid],
                            [6.1, mid],
                            [7, mid - 6],
                            [7, mid - 7],
                            [4, mid - 10],
                            //[2, mid - 10],
                            ]);

            }
        }
}

module turn_cut_bracket(sup=5, widest=sleeve_inside+9, makebearings=1 ){
    rotate([180,0,0])
    translate([0,0,-60])
    difference(){
        union(){
        translate([0,0,sleeve_height - sleeve_height/sup + 3])
        cylinder(r1=sleeve_inside-2, r2=widest+sup+1, 
                    h=sleeve_height/sup, $fn=128);

        }
        rotate([0,0,0])
            turner_cutter();
        cylinder(r=sleeve_inside -2, h=100, $fn=128);   
    }
}

module turn_cut_bolts(widest=43, makebearing=1){
    difference(){
        turn_cut_bracket(widest=widest, makebearings=makebearing);
        for (i=[0:120:359]){
            translate([cos(i)*widest, sin(i)*widest, 0]){
                // outside rim sandwich holders
                cylinder(r=6.4/2, h=20, center=true, $fn=12);
                // punch into side bearings
                if (makebearing==1){                
                    rotate([i,90,360-i])
                    translate([-25,0,0]){           // height from floor
                        #cylinder(r=4, h=60, center=true, $fn=18);
                        translate([0,0,-17.0]){     // depth into sides
                        #cylinder(r=11, h=6.45, $fn=32, center=true);
                        translate([0,0,.5])
                        #cylinder(r=13.28/2, h=7.5, $fn=32, center=true);
                        translate([0,0,3.5])
                        #cylinder(r1=11, r2=10.5, h=.5, $fn=32, center=true);
                        }
                       }
                }

                //translate([0,0,5])
                //    cylinder(r=12.42/2, h=5.5, center=false, $fn=6);
            echo("bolts at: ",[cos(i)*widest, sin(i)*widest]);
            }
        } 
    }
}
//
//turn_cut_bracket();
//translate([-42,0,0])
translate([-42,0,0])
     turn_cut_bolts(makebearing=1);

module test_fit(){
    rotate([0,0,-30])
    turn_cut_bolts();

    translate([sleeve_inside+3,0,1+ 4.33/2]) sphere(r=4.33/2);
    translate([sleeve_inside+3,0,0]) cube([2+ 4.33,2+ 4.33,2+ 4.33], center=true);
    translate([0,0,18+1+4.33/2])rotate([0,180,0]) new_gear();
    translate([0,38,-23]) rotate([90,0,0])
	    import("whiskers_small.stl");
}



module inside_job(give=.5, ht=30, ringthk=6, 
                    bearoutrad = 11.15, 
                    bearin_spinrad = 13.28/2,
                    bear_shaft_outrad = 8/2,)
                    { 
//inner bearing holder / freewheeler
// print by itself using "3bearing608zz_inside_job"

widest=43;
    difference(){
        translate([0,0,25])             // positive part
            difference(){
                cylinder(r=sleeve_inside-give, h=ht, center=true, $fn=256);
                cylinder(r=sleeve_inside-give - ringthk, h=ht+.1, center=true, $fn=128);
            } 

    translate([0,0,25-ht/2-.05])        // some aero-style
        cylinder(r1=sleeve_inside-give-1, r2=sleeve_inside-give - ringthk-1, h=ht/2+.1, $fn=196);
    translate([0,0,25])
    cylinder(r2=sleeve_inside-1, r1=sleeve_inside-give - ringthk-1, h=ht/2+.1, $fn=196);
    for (i=[0:120:359]){
        translate([cos(i)*widest, sin(i)*widest, 0]){
            // outside rim sandwich holders
            cylinder(r=6.4/2, h=20, center=true, $fn=12);
            // punch into side bearings
       
                rotate([i,90,360-i])
                translate([-25,0,0]){           // height from floor
                    #cylinder(r=bear_shaft_outrad, h=60, center=true, $fn=18);
                    translate([0,0,-17.3]){     // depth into sides
                    #cylinder(r=bearoutrad, h=6.45, $fn=32, center=true);
                    translate([0,0,.5])
                    #cylinder(r=bearin_spinrad, h=7.5, $fn=32, center=true);
                    translate([0,0,3.5])
                    #cylinder(r1=bearoutrad, r2=bearoutrad - 0.5, 
                                h = 0.5, $fn=32, center=true);
                    }
                   }
            }

                //translate([0,0,5])
                //    cylinder(r=12.42/2, h=5.5, center=false, $fn=6);
            echo("bolts at: ",[cos(i)*widest, sin(i)*widest]);
            }
        }  
}

// use -42 if joining bearing holder to bracket-bb-race
// translate([-42,0,-10])
translate([45,0,-10])
    inside_job();

use <turner.scad>;
translate([-45,0,0]){
translate([20,0,0]) rotate([0,0,90]){
    armplate();
    translate([-20,20,0])rotate([0,0,-105])
    armnhammer();
}

translate([4,-4,5.8]){
	    gearbear();

}

translate([-17,0,5.8])
	gearbear();

translate([-7,2.5,0])
    elbow();

translate([-9,15,6])
    gear_nut();

translate([2,16,0])
	d_shaft();
}


module new_gear(){
        turnypart(mid=9);
    translate([0,0,8.77]) rotate([0,180,0])
        import("whiskers_big.stl");
}

 translate([45,0,18]) rotate([0,180,0]) new_gear();
