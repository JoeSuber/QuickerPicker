
$fn=32;
sleeve_height=52;
sleeve_inside=31;
sleeve_wall=5;

// burrower is to be used 6 times, one on each section to make a circle-groove
module burrower (degrees=360/6, 
					section_num=0,		// passed in for echo debug
					upndown=0, 			// ie -20, 0, 20 - relative rise / fall
					currentline=20, 		// starting z-level
					radius=30, 				// of can
					quant=40, 				// how many cuts/section
					bulge=4,				// radius of cutter-sphere
					huck=24,				// fine-ness of cutter '$fn'
					){
		echo("currentline = ", currentline, " section = ", section_num);
		for (i=[0 : degrees/quant : degrees - (degrees/quant)*.5]){
			rotate([0, 0, i])
			translate([radius, 0, currentline - upndown*cos(i/degrees*180)*.5 + upndown/2])
				sphere(r=bulge, center=true, $fn=huck);
		}
}

s=12;
q=10;
lvl1 = 28;
lvl2 = 60;
digmap = [[1, lvl1, 0], [2, lvl1, -s], [3, lvl1-s , -s], [4, lvl1-s-s ,s], [5, lvl1-s, s], [6, lvl1, 0] ];

airmap = [[1,lvl2, q], [2, lvl2+q, -q], [3, lvl2, 5*q], [4, lvl2+5*q, -8*q], [5, lvl2-3*q, 2*q], [6, lvl2-q, q]];

module digdug (sections=6, instructions=digmap){
	for (shovel=instructions){
	rotate([0,0,(shovel[0]-1)*(360/sections)]){
		if (shovel[0] < 3){
			#burrower(currentline=shovel[1], 
						section_num=shovel[0], upndown=shovel[2]);
			echo("section ",shovel[0]," is done");
		}
		else {
			#burrower(currentline=shovel[1], 
						section_num=shovel[0], upndown=shovel[2]);
		}
	}
	}
}

//difference(){
//	translate([0,0,sleeve_height/2])
//		sleeve(outside_r=sleeve_inside+sleeve_wall, inside_r=sleeve_inside, ht=sleeve_height);
	digdug();
	digdug(instructions=airmap);
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

/*
translate([0,0,sleeve_height/2])
	sleeve(outside_r=sleeve_inside, inside_r=sleeve_inside-2, ht=sleeve_height);
*/
module strude(angle=45, xtilt=1, ytilt=1, cylinder_rad=sleeve_inside, cutter_rad=5){
	multmatrix(m = [ [cos(angle), sin(angle), 0, 0],
	                [-sin(angle), cos(angle), 0, 0],
	                [xtilt, ytilt, 1, 0],
	                [0, 1, 0,  1]
	              ]) union() {
	   //cylinder(r=cylinder_rad,h=cutter_rad*2,center=false);
		rotate_extrude(twist=90){
			translate([cylinder_rad, cutter_rad, cutter_rad])
				circle(r=cutter_rad);
		}
	}
}

//strude();
module score (steptheta=25, ht=sleeve_height){
	for (theta=[0:steptheta:360-(360%steptheta)]){
	translate([0,0,theta/360*ht - ht/2])
		strude(angle=theta, xtilt=.61, ytilt=.61, cylinder_rad=sleeve_inside, cutter_rad=5);
	}
}

module groove(){
	difference(){
		sleeve(outside_r=sleeve_inside+sleeve_wall, 
				inside_r=sleeve_inside,
				ht=sleeve_height);
		score(steptheta=180);
	}
}

