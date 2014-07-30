// generate the parts that move up and down
sleeve_inside = 31.5;
sleeve_height = 52;
split_at_z = 33;
trackball = 3.5;  			// radius of follower nub
echo("splitting at z = ",split_at_z);

use <inside_tracker.scad>;

difference(){
import("inside_tracker.stl");
makesliders();
}

module makesliders(demo=0, thickness=2, gap=1){
	difference(){
		translate([0,0,sleeve_height/2])
		sleeve(outside_r=sleeve_inside+demo, 
				inside_r=sleeve_inside-thickness,
				ht=sleeve_height);
		// a cut-out to gap the slides
		translate([0,0,split_at_z])
		sleeve(outside_r=sleeve_inside+demo+.1, 
				inside_r=sleeve_inside-thickness-.1,
				ht=gap);
	}
	// for air
	translate([sleeve_inside-thickness/2,0,sleeve_height - trackball])
		sphere(r=3.7, center=true, $fn=36);
	// for picker
	translate([sleeve_inside-thickness/2,0,split_at_z - trackball - gap/2])
		sphere(r=3.7, center=true, $fn=36);
}

