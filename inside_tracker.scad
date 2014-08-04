
$fn=32;
sleeve_height=57;
sleeve_inside=29;
sleeve_wall=4.8;
sleeve_outside=sleeve_inside+sleeve_wall;
s=8;
q=10;
lvl1 = 24;
lvl2 = 52;
include <MCAD/regular_shapes.scad>;


digmap = [[1, lvl1, 0], [2, lvl1, -s], [3, lvl1-s , -s], [4, lvl1-s-s ,s], [5, lvl1-s, s], [6, lvl1, 0] ];

airmap = [[1, lvl2, -q], [2, lvl2-q, 0], [3, lvl2-q, 0], [4, lvl2-q, 0], [5, lvl2-q, q], [6, lvl2, 0]];


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

digdug();
digdug(instructions=airmap);

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
	translate([0,0,mid])
        union(){
            // main tube
            rotate_extrude(convexity=10, center=true, $fn=128){
                translate([sleeve_inside, 0, mid])
                    polygon(points=[[0,0],
                            [0, mid],
                            [1, mid],
                            [1 + 4.36/2, mid - 4.36/2],
                            [4.36, mid],
                            [5.36, mid],
                            [10, mid - 10],
                            [10, mid - 11],
                            [9, mid - 11],
                            [4, mid - 16],
                            [5.3, mid - 17.5],
                            [4, mid - 19],
                            [4, -mid],
                            [0, -mid]]);
            //sleeve(outside_r=sleeve_outside+ringthick, inside_r=sleeve_outside-.1, ht=saturn);
            }
        // outside tracks for bearings
        //translate([0,0,mid])
        //    sleeve(outside_r=sleeve_outside+1, inside_r=sleeve_outside+.4, ht=7.1);
        //translate([0,0,mid])
         //   sleeve(outside_r=sleeve_outside+.41, inside_r=sleeve_outside, ht=6.4);
        }

}
//turnypart();

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

