bigbox = 80;
bigboxht = 55;
sides = 3;
ledhole=15;

module box (outside=bigbox, height=bigboxht, wt=sides, mid=1){
	difference(){
	cube([outside,outside,height], center=true);
	translate([0,0,wt/2])
		cube([(outside-wt*2)-((outside-wt*2)*(mid-1))+.1,outside-wt*2-((outside-wt*2)*(mid-1))+.1,height-wt+.1], center=true);
	}
}


module cuvette (cvdim=10, cvside=5, cvh=5, wallmid=1){
	difference(){
	union(){
	translate([0,0,-bigbox/2+(sides+cvh+cvside/2)])
		cube([cvdim+cvside*2,cvdim+cvside*2, cvh], center=true);
	translate([-cvdim+cvside/2, 0, 0])
		cube([cvside*wallmid, bigbox, bigboxht], center=true);
	}
 	translate([0,0,sides])
		cube([cvdim+.2,cvdim+.2,bigbox-sides*2], center=true);
	translate([-cvdim+cvside/2,0,0])
		cube([cvside*wallmid+.1,cvside,bigboxht-sides*2-cvside*2], center=true);
	}
}

module openbox (midwall=1){
	difference(){
		union(){
			cuvette(wallmid=midwall);
			box(mid=midwall-(midwall-1)/2);
		}
		translate([0,0,0]) rotate([0,90,0])
			cylinder(r=5/2, h=bigbox*2, center=true, $fn=36);
	}
}

module lid () {
	difference(){
		// review level for printing if changing scale-z from 0.7
		scale([1, 1, 0.7])
			cube([bigbox-.1,bigbox-.1,10], center=true);
		translate([0,0,-bigboxht/2]) scale([1.0, 1.0, 1])
			openbox(midwall=1.1);
	}
}

openbox(midwall=1.0);

translate([0,0,-bigbox/2+8.55])
translate([bigbox+1,0,0]) rotate([0,180,0])
lid();



