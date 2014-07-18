grow=1.265;

module scoop(cornerrad=3, longside=88-1, shortside=63.5-1, ht=20, grow=grow, wallthin=1){
translate([0, 0, 10])
	linear_extrude(height = 20, center = true, convexity = 10, twist = 0, scale=grow, $fn=100)
		difference(){
			union(){
			translate([0,6,0])
				square([shortside+8,1], center=true);
			translate([0,-6,0])
				square([shortside+8,1], center=true);
			translate([-6,0,0])
				square([1,longside+8], center=true);
			translate([6,0,0])
				square([1,longside+8], center=true);
			minkowski(){
				circle(r=cornerrad, $fn=32);
				square([shortside-cornerrad*2, longside-cornerrad*2], center=true);
			}}
			minkowski(){
				circle(r=cornerrad, $fn=32);
				square([shortside-cornerrad*2-wallthin*2, longside-cornerrad*2-wallthin*2], center=true);
			}
		}
	// floor with hole for can
	translate([0, 0, 1])
	difference(){
	linear_extrude(height=2, center = true, convexity = 10, twist = 0, scale=1, $fn=100)
			minkowski(){
				circle(r=cornerrad, $fn=32);
				square([shortside-cornerrad*2, longside-cornerrad*2], center=true);
			}
	cylinder(r=58/2, h=4, center=true, $fn=128);
	}
}

module measures(lx=63.5, ly=88){
	rotate([0,90,0])
		cylinder(r=4, h=lx, center=true, $fn=6);
	rotate([90,0,0])
		cylinder(r=4, h=ly, center=true, $fn=6);
	cylinder(r=53.72/2, h=3, center=true, $fn=64);
}

module poop(holerad=1.0, fudge=-.8){
	difference(){
		scoop();
		for(xy=[[63.5*grow/2-fudge, [90,0,0]], 
					[-63.5*grow/2+fudge, [90,0,0]],
					[88*grow/2-fudge, [90,90,90]],
					[-88*grow/2+fudge, [90,90,90]]]){
			translate([xy[0],0,17.5]) rotate(xy[1])
				cylinder(r=holerad, h=150, center=true, $fn=12);
			translate([0,xy[0],17.5]) rotate(xy[1])
				cylinder(r=holerad, h=150, center=true, $fn=12);
			}
	}
}

poop();
