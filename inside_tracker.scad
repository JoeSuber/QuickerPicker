
$fn=32;
sleeve_height=57;
sleeve_inside=31;
sleeve_wall=4.5;
sleeve_outside=sleeve_inside+sleeve_wall;

// burrower is to be used 6 times, one on each section to make a circle-groove
module burrower (degrees=360/6, 
					section_num=0,		// passed in for echo debug
					upndown=0, 			// ie -20, 0, 20 - relative rise / fall
					currentline=20, 		// starting z-level
					radius=32, 				// of can
					quant=60, 				// how many cuts/section
					bulge=3.5,				// radius of cutter-sphere
					huck=24,				// fine-ness of cutter '$fn'
					){
		echo("currentline = ", currentline, " section = ", section_num);
		for (i=[0 : degrees/quant : degrees - (degrees/quant)*.5]){
			rotate([0, 0, i])
			translate([radius, 0, currentline - upndown*cos(i/degrees*180)*.5 + upndown/2])
				sphere(r=bulge, center=true, $fn=huck);
		}
}

s=8;
q=10;
lvl1 = 24;
lvl2 = 52;
digmap = [[1, lvl1, 0], [2, lvl1, -s], [3, lvl1-s , -s], [4, lvl1-s-s ,s], [5, lvl1-s, s], [6, lvl1, 0] ];

airmap = [[1,lvl2,-q], [2, lvl2-q, -q], [3, lvl2-2*q, 0], [4, lvl2-2*q , 0], [5, lvl2-2*q ,q], [6, lvl2-q, q]];

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

//difference(){
//	translate([0,0,sleeve_height/2])
//		sleeve(outside_r=sleeve_inside+sleeve_wall, inside_r=sleeve_inside, ht=sleeve_height);
	digdug(); 
	//rotate([0,0,120]) digdug(); rotate([0,0,240]) digdug();

	digdug(instructions=airmap); 
	//rotate([0,0,120]) digdug(instructions=airmap); 
	//rotate([0,0,240]) digdug(instructions=airmap);
//}

module sleeve(outside_r=sleeve_inside+sleeve_wall, 
				inside_r=sleeve_inside,
				ht=sleeve_height){
	echo("outside_r=",outside_r, 
				"inside_r=",inside_r,
				"ht=",ht);
	difference(){
		cylinder(r=outside_r, h=ht, center=true, $fn=128);
		cylinder(r=inside_r, h=ht+.1, center=true, $fn=128);
	}
}


