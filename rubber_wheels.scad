
$fn=32;
sleeve_height=35;
sleeve_inside=30;
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
		for (i=[0:degrees/quant:degrees]){
			rotate([0, 0, i])
			translate([radius, 0, currentline + upndown*sin(i/degrees*90)])
				sphere(r=bulge, center=true, $fn=huck);
		}
}
//currentline=50
s=11;
lvl = 30;
digmap = [[1, lvl, 0], [2, lvl, -s], [3, lvl-s , -s], [4, lvl-s-s ,s], [5, lvl-s, s], [6,lvl,0]];
module digdug (sections=6, instructions=digmap){
	for (shovel=instructions){
	rotate([0,0,(shovel[0]-1)*(360/sections)]){
		if (shovel[0] <= 3){
			burrower(currentline=shovel[1], 
						section_num=shovel[0], upndown=shovel[2]);
		}
		if (shovel[0] >= 4){
			burrower(currentline=shovel[1], 
						section_num=shovel[0], upndown=shovel[2]);
		}
	}
	}
}
difference(){
	translate([0,0,sleeve_height/2])
		sleeve(outside_r=sleeve_inside+sleeve_wall, inside_r=sleeve_inside, ht=sleeve_height);
	digdug();
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

